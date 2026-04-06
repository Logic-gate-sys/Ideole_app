# Manage Reviewers - Implementation Guide

## Overview

The **Manage Reviewers** modal provides a comprehensive interface for viewing, managing, and communicating with idea reviewers. It separates active reviewers from pending invitations, provides clear status indicators, and enables actions like resending invites, canceling invitations, and removing reviewers.

## File Structure

```
lib/features/shared_modal_widgets/
├── manage_reviewers_controller.dart  (135 lines)
│   ├── ReviewerItem model
│   ├── ReviewerStatus enum
│   └── ManageReviewersController
├── manage_reviewers_modal.dart       (390 lines)
│   ├── ManageReviewersModal widget
│   ├── _ManageReviewersModalState
│   └── Helper methods for rendering
└── [existing other modals]
```

## Components

### 1. **ManageReviewersController** (Data & State Management)

Extends `ChangeNotifier` for reactive state management.

**Key Properties:**
- `reviewers` - Complete list of all reviewers
- `activeReviewers` - Filtered list of joined reviewers
- `pendingReviewers` - Filtered list with pending invitations
- `isLoading` - Loading state for async operations
- `errorMessage` - Error feedback for failed operations

**Methods:**

```dart
void initialize(String ideaId)
// Load reviewer data for a specific idea

Future<bool> removeReviewer(String reviewerId)
// Remove an active reviewer from the idea

Future<bool> resendInvitation(String reviewerId)
// Resend invitation to pending reviewer

Future<bool> cancelInvitation(String reviewerId)
// Cancel a pending invitation

void clearError()
// Clear error message display
```

**Model Classes:**

```dart
class ReviewerItem {
  final String id;
  final String name;
  final String role;
  final String expertise;
  final String? avatarUrl;
  final ReviewerStatus status;
  final DateTime? joinedDate;
  final DateTime? invitedDate;
}

enum ReviewerStatus {
  joined,    // Active reviewer
  pending,   // Invitation pending
  declined,  // Declined invitation
}
```

### 2. **ManageReviewersModal** (UI Widget)

Draggable bottom sheet modal for managing idea reviewers.

**Key Features:**

#### Header Section
- Idea title breadcrumb
- Active/Pending reviewer counts
- Close button
- Visual hierarchy with Sahara design tokens

#### Content Sections

**Active Reviewers:**
- Display joined reviewers with clear status
- Show role and expertise
- Timeline info ("Joined 2 days ago")
- Remove action button
- Color-coded with success/primary palette

**Pending Reviewers:**
- Show invitations with pending status
- Display invitation timeline ("Invited 1h ago")
- Resend invitation button
- Cancel invitation button
- Color-coded with warning palette

#### Reviewer Card Structure
```
┌─────────────────────────────────┐
│ [Avatar] Name          [Status] │
│          Role                   │
│                                 │
│ [Expertise Tag]                 │
│                                 │
│ Timeline info (joined/invited)  │
│                                 │
│ [Action Buttons]                │
└─────────────────────────────────┘
```

**States:**

1. **Loading State** - Centered spinner while fetching data
2. **Empty State** - "No Reviewers Yet" with call-to-action
3. **Error State** - Error message with dismiss button
4. **Content State** - Separated sections for active/pending reviewers

## Integration Guide

### 1. Add to MultiProvider in main.dart

```dart
class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => IdeaController()),
        ChangeNotifierProvider(create: (_) => CommunityController()),
        ChangeNotifierProvider(create: (_) => OrganisationController()),
        ChangeNotifierProvider(create: (_) => ManageReviewersController()), // ADD THIS
      ],
      child: // ... rest of app
    );
  }
}
```

### 2. Show Modal from Idea Detail Screen

```dart
void _showManageReviewers() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ManageReviewersModal(
      ideaId: widget.idea.id,
      ideaTitle: widget.idea.title,
      onReviewersChanged: () {
        // Refresh idea detail data if needed
        _refreshIdeaDetails();
      },
    ),
  );
}
```

### 3. Backend Integration (TODO)

The controller includes placeholder comments for these API calls:

```dart
// In removeReviewer():
// await _reviewerService.removeReviewer(_currentIdeaId!, reviewerId);

// In resendInvitation():
// await _reviewerService.resendInvitation(_currentIdeaId!, reviewerId);

// In cancelInvitation():
// await _reviewerService.cancelInvitation(_currentIdeaId!, reviewerId);
```

**Expected API Endpoints:**
- `DELETE /ideas/{ideaId}/reviewers/{reviewerId}` - Remove reviewer
- `POST /ideas/{ideaId}/reviewers/{reviewerId}/resend-invite` - Resend invite
- `DELETE /ideas/{ideaId}/reviewers/{reviewerId}/invite` - Cancel invite

### 4. Service Layer Integration

Create `ReviewerService` with methods:

```dart
class ReviewerService {
  Future<List<ReviewerItem>> fetchReviewers(String ideaId) async {
    final response = await apiService.get('/ideas/$ideaId/reviewers');
    return (response as List)
        .map((json) => ReviewerItem.fromJson(json))
        .toList();
  }

  Future<void> removeReviewer(String ideaId, String reviewerId) async {
    await apiService.delete('/ideas/$ideaId/reviewers/$reviewerId');
  }

  Future<void> resendInvitation(String ideaId, String reviewerId) async {
    await apiService.post(
      '/ideas/$ideaId/reviewers/$reviewerId/resend-invite',
      body: {},
    );
  }

  Future<void> cancelInvitation(String ideaId, String reviewerId) async {
    await apiService.delete(
      '/ideas/$ideaId/reviewers/$reviewerId/invite',
    );
  }
}
```

## Design System Integration

### Color Usage

| Element | Color | Reference |
|---------|-------|-----------|
| Active status badge | `#2DAA6F` (success) | Status indicator for joined reviewers |
| Pending status badge | `#F5A623` (warning) | Status indicator for pending invites |
| Primary buttons | `#C2652A` (primary terracotta) | Resend buttons |
| Dangerous actions | `#CD5C5C` (error red) | Remove buttons |
| Text main | `#2D2D2D` | Reviewer names, roles |
| Text secondary | `#666666` | Subtitle text |
| Text tertiary | `#999999` | Timeline info, timestamps |
| Borders | Light gray | Card borders |
| Background light | `#FFF8F6` | Badge backgrounds |

### Typography

- **Header** - Headline Small (EB Garamond, 24px)
- **Reviewer Name** - Body Medium + Bold (Manrope, 16px)
- **Role/Timeline** - Body Small (Manrope, 14px)
- **Status Badge** - Label Small + Bold (Manrope, 12px)
- **Expertise Tag** - Label Small (Manrope, 12px)

## Key Features

### 1. Status Separation
- Automatically groups reviewers by status (Active vs. Pending)
- Shows count indicators at top
- Distinct visual styling per status

### 2. Timeline Information
- "Joined X days ago" for active reviewers
- "Invited XhAgo" or "Invited X days ago" for pending
- Relative time format for user-friendly display

### 3. Action Management
- **Active Reviewers**: Remove option only
- **Pending Reviewers**: Resend invite + Cancel options
- Confirmation dialog for destructive actions
- Success feedback via SnackBar

### 4. Error Handling
- Graceful error display in modal
- Dismiss button to clear errors
- Optional callback for parent widget to refresh data

### 5. Empty State
- Friendly message when no reviewers exist
- Suggests next action (invite reviewers)
- Consistent with app empty state pattern

## Testing Checklist

### Unit Tests
- [ ] Controller state updates correctly on loadReviewers()
- [ ] activeReviewers getter filters correctly
- [ ] pendingReviewers getter filters correctly
- [ ] removeReviewer() removes from list and calls API
- [ ] resendInvitation() calls appropriate API
- [ ] cancelInvitation() removes from list

### Widget Tests
- [ ] Modal renders with correct dimensions
- [ ] Close button dismisses modal
- [ ] Reviewer cards display all required info
- [ ] Active and pending sections render when populated
- [ ] Empty state shows when no reviewers
- [ ] Loading spinner appears during data fetch
- [ ] Error message displays on API failure

### Integration Tests
- [ ] Load reviewers from API
- [ ] Remove reviewer and refresh list
- [ ] Resend invitation and show success message
- [ ] Cancel invitation and verify removal
- [ ] Modal callback triggers parent refresh
- [ ] Navigation works from idea detail screen

## Related Components

- **[InviteCollaboratorsModal](invite_collaborators_modal.dart)** - Invite new reviewers to idea
- **[RatingModal](rating_modal.dart)** - Rate idea criteria (Originality, Feasibility, Impact)
- **[DiscussionSection](discussion_section.dart)** - Display reviewer comments

## Future Enhancements

1. **Reviewer Feedback Summary** - Show average ratings and comment count
2. **Change Reviewer Role** - Modify reviewer permissions (lead, assistant, observer)
3. **Bulk Actions** - Remove multiple reviewers, resend batch invites
4. **Reviewer Analytics** - Track who reviewed, time spent, feedback quality
5. **Review Reminders** - Auto-send reminders to pending reviewers
6. **Reviewer Search** - Search/filter reviewers by name, role, expertise
7. **Avatar Upload** - Allow reviewers to set profile pictures
8. **Notifications** - Notify reviewers of status changes via push notifications

## Code Quality Notes

- **Stateless Components** - Consider extracting `_buildReviewerCard()` to separate widget for reusability
- **Constants** - Extract magic numbers (margins, radii) to theme constants
- **Scroll Performance** - Current ListView is efficient; consider ListView.builder for 100+ reviewers
- **Accessibility** - Add semantic labels and keyboard navigation
- **Internationalization** - Extract hardcoded strings to translation files

## API Response Format (Expected)

```json
{
  "data": [
    {
      "id": "reviewer-1",
      "name": "Julian Vane",
      "role": "Senior Architect",
      "expertise": "Sustainable Design",
      "avatarUrl": "https://...",
      "status": "joined",
      "joinedDate": "2024-01-09T10:30:00Z"
    },
    {
      "id": "reviewer-2",
      "name": "Elena Moretti",
      "role": "Urban Planner",
      "status": "pending",
      "invitedDate": "2024-01-10T15:45:00Z"
    }
  ]
}
```
