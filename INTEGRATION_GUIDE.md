# Integration Guide - Frontend & Backend APIs

## Overview

This document explains how all the new components (Organisations, Reviewers) are integrated between the Flutter frontend and Express.js backend.

---

## Architecture Pattern

### Frontend Layers

```
UI Screens (Widget)
    ↓
Controllers (ChangeNotifier - State Management)
    ↓
Services (API Communication)
    ↓
ApiService (HTTP Client with Platform Detection)
```

### Example Flow: Manage Reviewers

```
ManageReviewersModal (UI)
    ↓
ManageReviewersController (State)
    ↓
ReviewerService (API Calls)
    ↓
ApiService.get('/ideas/{ideaId}/reviewers')
    ↓
Backend ReviewerController
```

---

## Frontend Integration

### 1. **Main App Setup** (`main.dart`)

All controllers are registered in `MultiProvider` before the `MainApp` initializes:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<IdeaController>(create: (_) => IdeaController()),
    ChangeNotifierProvider<CommunityController>(create: (_) => CommunityController()),
    ChangeNotifierProvider<OrganisationController>(create: (_) => OrganisationController()),
    // Controllers are now available app-wide via Consumer<XYZController>
  ],
  child: const MainApp(),
)
```

### 2. **Bottom Navigation Updated**

Added new `Organisations` tab (index 2) and shifted other tabs:

```
Tab 0: Feed (IdeaFeedScreen)
Tab 1: Communities (CommunitiesScreen)
Tab 2: Organisations (OrganisationsScreen) ← NEW
Tab 3: Profile (Placeholder)
Tab 4: Settings (Placeholder)
```

### 3. **Controller Pattern** (State Management)

All controllers follow this pattern:

```dart
class XYZController extends ChangeNotifier {
  // State
  List<Item> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Service injection
  final _service = XYZService();
  
  // Getters
  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Methods call service and notify listeners
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.fetchItems();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
```

### 4. **Service Layer** (API Integration)

Services handle all HTTP communication:

```dart
class ReviewerService {
  final ApiService _apiService = ApiService();
  
  Future<List<Reviewer>> fetchIdeaReviewers(String ideaId) async {
    final response = await _apiService.get('/ideas/$ideaId/reviewers');
    return (response['data'] as List)
        .map((json) => Reviewer.fromJson(json))
        .toList();
  }
  
  Future<void> removeReviewer(String ideaId, String reviewerId) async {
    await _apiService.delete('/ideas/$ideaId/reviewers/$reviewerId');
  }
}
```

### 5. **ApiService** (HTTP Client)

Platform-aware base URL detection:

```dart
class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api'; // Android emulator
    }
  }
  
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
}
```

---

## Backend Integration

### 1. **Route Setup** (`backend/src/routes/index.ts`)

```typescript
import { setupReviewerRoutes } from './reviewer.route.ts';

// In router setup:
setupReviewerRoutes(router);
```

### 2. **Endpoint Structure**

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/ideas/:ideaId/reviewers` | Get all reviewers | ✓ Required |
| POST | `/ideas/:ideaId/reviewers` | Invite reviewer | ✓ Owner only |
| DELETE | `/ideas/:ideaId/reviewers/:reviewerId` | Remove reviewer | ✓ Owner only |
| POST | `/ideas/:ideaId/reviewers/:reviewerId/resend-invite` | Resend invite | ✓ Owner only |
| DELETE | `/ideas/:ideaId/reviewers/:reviewerId/invite` | Cancel invite | ✓ Owner only |
| POST | `/ideas/:ideaId/reviewers/:reviewerId/accept` | Accept invite | ✓ Self only |
| POST | `/ideas/:ideaId/reviewers/:reviewerId/decline` | Decline invite | ✓ Self only |

### 3. **Service Layer** (`backend/src/services/reviewer.service.ts`)

Handles business logic and database operations:

```typescript
export const ReviewerService = {
  async getIdeaReviewers(ideaId: string) {
    const invites = await prisma.ideaInvite.findMany({
      where: { ideaId },
      include: { reviewer: {...} },
    });
    return invites.map(transformToMobileFormat);
  },
  
  async canManageReviewers(ideaId: string, userId: string) {
    // Check ownership or admin status
    return idea.createdById === userId || member.role === 'ADMIN';
  },
  
  async removeReviewer(ideaId: string, reviewerId: string) {
    await prisma.ideaInvite.delete({...});
  }
}
```

### 4. **Controller Layer** (`backend/src/controllers/reviewer.controller.ts`)

HTTP request handlers with authorization:

```typescript
export const ReviewerControllers = {
  async removeReviewer(req: Request, res: Response) {
    const canManage = await ReviewerService.canManageReviewers(ideaId, userId);
    if (!canManage) {
      return res.status(403).json({...});
    }
    
    await ReviewerService.removeReviewer(ideaId, reviewerId);
    return res.status(200).json({success: true});
  }
}
```

### 5. **Database Model** (Prisma Schema)

```prisma
model IdeaInvite {
  id         String   @id @default(uuid())
  idea       Idea     @relation(fields: [ideaId], references: [id], onDelete: Cascade)
  ideaId     String
  reviewer   User     @relation(fields: [reviewerId], references: [id], onDelete: Cascade)
  reviewerId String
  status     Status   @default(PENDING)  // PENDING, ACCEPTED, DECLINED
  createdAt  DateTime @default(now())
  
  @@unique([ideaId, reviewerId])  // One invite per reviewer per idea
}
```

---

## Data Flow Examples

### Example 1: Remove Reviewer

**User Action:** Tap "Remove" button on active reviewer

```
ManageReviewersModal
  └─ _showRemoveConfirm()
      └─ ManageReviewersController.removeReviewer(reviewerId)
          └─ ReviewerService.removeReviewer(ideaId, reviewerId)
              └─ ApiService.delete('/ideas/{ideaId}/reviewers/{reviewerId}')
                  └─ HTTP DELETE to Backend
                      └─ ReviewerController.removeReviewer()
                          └─ Authorization check (canManageReviewers)
                              └─ ReviewerService.removeReviewer()
                                  └─ Prisma delete IdeaInvite
                                      └─ Response: {success: true}
                                          └─ Update UI (remove from list)
                                              └─ Show SnackBar: "Removed successfully"
```

### Example 2: Load Reviewers

**User Action:** Open ManageReviewersModal

```
initState()
  └─ ManageReviewersController.loadReviewers(ideaId)
      └─ _isLoading = true, notifyListeners() → Shows spinner
          └─ ReviewerService.fetchIdeaReviewers(ideaId)
              └─ ApiService.get('/ideas/{ideaId}/reviewers')
                  └─ HTTP GET to Backend
                      └─ ReviewerController.getIdeaReviewers()
                          └─ ReviewerService.getIdeaReviewers(ideaId)
                              └─ Prisma query IdeaInvite
                                  └─ Response: {success: true, data: [...]}
                                      └─ Parse and transform to ReviewerItem
                                          └─ _reviewers = [...], _isLoading = false
                                              └─ notifyListeners() → UI rebuilds
                                                  └─ Show reviewer cards separated by status
```

### Example 3: Resend Invitation

**User Action:** Tap "Resend" on pending reviewer

```
_buildReviewerCard(pending)
  └─ OutlinedButton("Resend")
      └─ ManageReviewersController.resendInvitation(reviewerId)
          └─ ReviewerService.resendInvitation(ideaId, reviewerId)
              └─ ApiService.post('/ideas/{ideaId}/reviewers/{reviewerId}/resend-invite', {})
                  └─ HTTP POST to Backend
                      └─ ReviewerController.resendInvitation()
                          └─ Authorization check
                              └─ ReviewerService.resendInvitation()
                                  └─ Verify status is PENDING
                                      └─ Update createdAt timestamp (mark as recent)
                                      └─ (TODO: Send email notification)
                                          └─ Response: {success: true}
                                              └─ Show SnackBar: "Invitation resent"
```

---

## Error Handling

### Frontend Error Flow

```dart
try {
  final result = await _service.operation();
} on Exception catch (e) {
  _errorMessage = e.toString();
  // Display in ErrorState or SnackBar
}
```

### Backend Error Response Format

```json
{
  "success": false,
  "message": "error",
  "details": "User does not have permission to manage reviewers for this idea"
}
```

### HTTP Status Codes

| Code | Meaning | Frontend Handling |
|------|---------|-------------------|
| 200 | Success | Show success message, update UI |
| 201 | Created | Show success message, update UI |
| 400 | Bad Request | Show error: "Invalid request" |
| 401 | Unauthorized | Redirect to login, refresh token |
| 403 | Forbidden | Show error: "Not authorized for this action" |
| 404 | Not Found | Show error: "Resource not found" |
| 500 | Server Error | Show error: "Server error, try again" |

---

## Testing the Integration

### 1. **Backend Test** (Using curl)

```bash
# Get reviewers for an idea
curl -X GET http://localhost:3000/api/ideas/{ideaId}/reviewers \
  -H "Authorization: Bearer {token}"

# Remove a reviewer
curl -X DELETE http://localhost:3000/api/ideas/{ideaId}/reviewers/{reviewerId} \
  -H "Authorization: Bearer {token}"

# Resend invitation
curl -X POST http://localhost:3000/api/ideas/{ideaId}/reviewers/{reviewerId}/resend-invite \
  -H "Authorization: Bearer {token}"
```

### 2. **Frontend Test Steps**

1. **Load Organisations Screen**
   - Tap "Organisations" tab
   - Should load paginated list of organisations
   - Check inspector for API calls

2. **View Idea Details with Reviewers**
   - Tap idea from feed
   - Tap "Manage Reviewers" button
   - ManageReviewersModal should load
   - Verify active/pending reviewers display correctly

3. **Manage Reviewers**
   - Remove an active reviewer
   - Resend invitation to pending reviewer
   - Verify UI updates and SnackBar shows
   - Check backend logs for API calls

### 3. **Network Inspector**

In Flutter:
```dart
// Monitor HTTP requests (add to ApiService)
void _monitorRequest(String method, String endpoint) {
  print('[${method.toUpperCase()}] $baseUrl$endpoint');
}
```

Using DevTools:
1. `flutter run` with web target
2. Open DevTools → Network tab
3. Verify requests have correct:
   - URL: `/api/ideas/{id}/reviewers`
   - Headers: `Authorization: Bearer {token}`
   - Status: 200, 404, 403, etc.

---

## Common Integration Issues & Solutions

### Issue 1: "401 Unauthorized"
- **Cause:** Token missing or expired
- **Solution:** Check `StorageService.getToken()`, refresh token if needed

### Issue 2: "403 Forbidden"
- **Cause:** User is not idea owner
- **Solution:** Only show "Remove Reviewer" button if user owns the idea

### Issue 3: API returns different field names
- **Cause:** Backend model fields don't match frontend expectations
- **Solution:** Use `factory Reviewer.fromJson()` to map fields

### Issue 4: Modal doesn't show data
- **Cause:** `loadReviewers()` not called or failed silently
- **Solution:** Add error state UI, check console logs

### Issue 5: Changes don't persist
- **Cause:** Frontend updates state but API call failed
- **Solution:** Add try/catch, restore previous state on error

---

## Deployment Checklist

- [x] Frontend main.dart updated with MultiProvider
- [x] Frontend bottom nav updated with Organisations tab
- [x] Frontend ReviewerService created
- [x] Frontend ManageReviewersController updated to use API
- [x] Backend reviewer routes created
- [x] Backend reviewer controller created
- [x] Backend reviewer service created
- [x] Backend routes registered in index.ts
- [ ] Database migrations run (`npx prisma migrate deploy`)
- [ ] Backend tests written for reviewer endpoints
- [ ] Frontend integration tests written
- [ ] Error handling tested (network failures, etc.)
- [ ] Permissions verified (ownership checks work)
- [ ] UI/UX tested across devices (phone, tablet, web)

---

## Next Steps

1. **Test the Integration**
   - Run backend: `npm run dev` (port 3000)
   - Run frontend web: `flutter run -d web` (localhost detected automatically)
   - Run frontend emulator: `flutter run` (10.0.2.2 detected automatically)

2. **Implement Remaining Modals**
   - InviteCollaboratorsModal needs ReviewerService integration
   - RatingModal needs RatingService backend

3. **Backend Rating System**
   - Create rating endpoints in IdeaController
   - Store criteria ratings in IdeaRating model
   - Add rating service for bulk operations

4. **Profile Screen**
   - Use existing `GET /users/me` endpoint
   - Display user stats (ideas created, reviews done)
   - Show managed organisations and communities

5. **Settings Screen**
   - Logout functionality
   - Notification preferences
   - Privacy settings

---

## File Reference

### Frontend Files
- `lib/main.dart` - Main app with MultiProvider setup
- `lib/services/reviewer_service.dart` - Reviewer API calls
- `lib/features/shared_modal_widgets/manage_reviewers_controller.dart` - State management
- `lib/features/shared_modal_widgets/manage_reviewers_modal.dart` - UI
- `lib/features/organisations/controllers/organisation_controller.dart` - Organisation state
- `lib/features/organisations/screens/organisations_screen.dart` - Organisation list

### Backend Files
- `backend/src/services/reviewer.service.ts` - Business logic
- `backend/src/controllers/reviewer.controller.ts` - HTTP handlers
- `backend/src/routes/reviewer.route.ts` - Route definitions
- `backend/src/routes/index.ts` - Route registration
- `backend/prisma/schema.prisma` - IdeaInvite model

---

## Git Commit Messages

```
feat(frontend): integrate organisations and reviewers into main navigation

- Add OrganisationController to MultiProvider
- Add OrganisationsScreen to bottom navigation (tab 2)
- Create ReviewerService for API communication
- Update ManageReviewersController to use live API
- Platform detection now supports web localhost and emulator

feat(backend): create reviewer management API endpoints

- Add ReviewerService for business logic
- Add ReviewerController with authorization checks
- Create reviewer routes for CRUD operations
- Support invitation workflow (pending → accepted/declined)
- Verify idea ownership before allowing management

test(integration): verify reviewer API flows

- Test get reviewers endpoint
- Test remove reviewer authorization
- Test resend/cancel invitation flows
- Verify error responses for invalid requests
```
