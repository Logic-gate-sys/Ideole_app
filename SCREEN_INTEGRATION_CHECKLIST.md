# Screen Integration Checklist

## Summary

All implemented screens are now fully integrated with `main.dart` and provide complete end-to-end navigation.

---

## Controllers Registration

### Registered in MultiProvider ✅
- `IdeaController` - Feed & idea management
- `CreateIdeaController` - Create new ideas
- `IdeaDetailController` - Individual idea details
- `CommunityController` - Community listing
- `OrganisationController` - Organisation listing
- `ManageReviewersController` - Reviewer management modals

### Access Pattern
```dart
// Any screen can access controllers like:
context.read<IdeaController>().loadIdeas();
context.watch<OrganisationController>().organisations;
```

---

## Screen Integration Map

### Bottom Tab Navigation

| Tab | Screen | Controller | Status |
|-----|--------|-----------|--------|
| 0 | IdeaFeedScreen | IdeaController | ✅ Full |
| 1 | CommunitiesScreen | CommunityController | ✅ Full |
| 2 | OrganisationsScreen | OrganisationController | ✅ Full |
| 3 | Placeholder | - | 📌 Coming Soon |
| 4 | Placeholder | - | 📌 Coming Soon |

### Screen Dependencies

#### IdeaFeedScreen
- **Controllers:** `IdeaController`, `CreateIdeaController`, `IdeaDetailController`
- **Features:** 
  - Load paginated ideas with infinite scroll
  - Create new idea via FAB
  - Navigate to idea details
  - Features: infinite scroll, card layout, empty/error states
- **Modals:** None (handles navigation to detail screen)

#### CommunitiesScreen
- **Controllers:** `CommunityController`
- **Features:**
  - Load paginated communities
  - Search communities
  - View community details
  - Join/leave communities
- **Modals:** None

#### OrganisationsScreen
- **Controllers:** `OrganisationController`
- **Features:**
  - Load paginated organisations
  - Search organisations
  - View organisation details
  - Infinite scroll pagination
- **Modals:** None

#### OrganisationDetailScreen
- **Navigation:** Pushed from OrganisationsScreen
- **Features:**
  - Show stats (members, projects)
  - Display member list
  - Join request button
- **Modals:** None (hero animation with app bar)

#### IdeaFeedScreen (Detail variant)
- **Navigation:** Pushed from IdeaFeedScreen
- **Controllers:** `IdeaDetailController`, `ManageReviewersController`
- **Features:**
  - Full idea description
  - Evaluation criteria display
  - Reviewer management
  - Discussion section
- **Modals:**
  - RatingModal (evaluate idea)
  - ManageReviewersModal (manage reviewers)
  - InviteCollaboratorsModal (invite reviewers)
  - DiscussionSection (view comments)

---

## Modal Widget Integration

### RatingModal
```dart
// Usage in idea detail or rating screen
showModalBottomSheet(
  context: context,
  builder: (_) => RatingModal(
    ideaId: idea.id,
    criteriaList: idea.criteria,
    onSubmit: (ratings) { /* save ratings */ },
  ),
);
```
- **Dependencies:** SaharaColors, AppTextStyles
- **State:** Stateful (sliders with local state)
- **Provider:** None (doesn't modify global state)

### InviteCollaboratorsModal
```dart
// Usage in idea detail or organisation screen
showModalBottomSheet(
  context: context,
  builder: (_) => InviteCollaboratorsModal(
    ideaId: idea.id,
    onInviteComplete: () { /* refresh */ },
  ),
);
```
- **Dependencies:** SaharaColors, AppTextStyles, search logic
- **State:** Stateful (search, selection)
- **Provider:** None (modifies via service calls)

### DiscussionSection
```dart
// Usage as widget in idea detail
DiscussionSection(ideaId: idea.id)
```
- **Dependencies:** Comments data model
- **State:** Stateless/Stateful hybrid (comment input)
- **Provider:** None (pure widget)

### ManageReviewersModal
```dart
// Usage in idea detail
showModalBottomSheet(
  context: context,
  builder: (_) => ManageReviewersModal(
    ideaId: idea.id,
    ideaTitle: idea.title,
    onReviewersChanged: () { /* refresh */ },
  ),
);
```
- **Dependencies:** `ManageReviewersController` (in MultiProvider)
- **State:** Uses controller for state management
- **Provider:** ✅ Registered in MultiProvider

---

## Navigation Flow

### Entry Point
```
MyApp (AuthController check)
  ↓
[Not Authenticated] → AuthScreen
  ↓ (on login success)
[Authenticated] → MultiProvider (6 controllers) → MainApp (5-tab navigation)
```

### Tab Navigation
```
MainApp (BottomNavigationBar)
  ├─ Tab 0: IdeaFeedScreen
  │   ├─ Uses: IdeaController
  │   ├─ Navigate to: IdeaDetailScreen (push)
  │   └─ FAB: CreateIdeaScreen (push)
  │
  ├─ Tab 1: CommunitiesScreen
  │   ├─ Uses: CommunityController
  │   └─ Navigate to: CommunityDetailScreen (push)
  │
  ├─ Tab 2: OrganisationsScreen
  │   ├─ Uses: OrganisationController
  │   └─ Navigate to: OrganisationDetailScreen (push)
  │
  ├─ Tab 3: ProfilePlaceholder (Coming Soon)
  │   └─ TODO: Show user profile, stats
  │
  └─ Tab 4: SettingsPlaceholder (Coming Soon)
      └─ TODO: App settings, logout
```

### Detail Screen Navigation
```
IdeaDetailScreen
  ├─ Modal: RatingModal (evaluate criteria)
  ├─ Modal: ManageReviewersModal (manage reviewers)
  │   └─ Uses: ManageReviewersController
  ├─ Modal: InviteCollaboratorsModal (invite people)
  ├─ Widget: DiscussionSection (comments thread)
  └─ Back: Returns to feed
```

---

## Data Flow

### Controller → UI Pattern
```
Controller.loadData()
  ↓ (notifyListeners)
Consumer<Controller> rebuilds
  ↓
Check: isLoading? → Show spinner
Check: errorMessage? → Show error state
Check: data.isEmpty? → Show empty state
Default: Show content
```

### Example: Load Organisations
```dart
// In OrganisationsScreen.initState
context.read<OrganisationController>().loadOrganisations();

// In build:
Consumer<OrganisationController>(
  builder: (_, controller, __) {
    if (controller.isLoading) return CircularProgressIndicator();
    if (controller.errorMessage != null) return ErrorWidget();
    if (controller.organisations.isEmpty) return EmptyWidget();
    return OrganisationList(organisations: controller.organisations);
  },
);
```

---

## Provider Dependency Tree

```
AuthController (top-level, before MultiProvider)
  ↓
MultiProvider
  ├─ IdeaController
  │   └─ IdeaService → ApiService
  ├─ CreateIdeaController
  │   └─ IdeaService → ApiService
  ├─ IdeaDetailController
  │   └─ IdeaService → ApiService
  ├─ CommunityController
  │   └─ CommunityService → ApiService
  ├─ OrganisationController
  │   └─ OrganisationService → ApiService
  └─ ManageReviewersController
      └─ ReviewerService → ApiService
```

All services use:
- `ApiService` (HTTP, platform-aware)
- `StorageService` (JWT tokens)

---

## Integration Verification Checklist

### ✅ Imports
- [x] All screen imports present in main.dart
- [x] All controller imports present
- [x] Modal widget imports available where used
- [x] Design system imports (SaharaColors, AppTextStyles)

### ✅ MultiProvider Setup
- [x] IdeaController registered
- [x] CreateIdeaController registered
- [x] IdeaDetailController registered
- [x] CommunityController registered
- [x] OrganisationController registered
- [x] ManageReviewersController registered

### ✅ Bottom Navigation
- [x] 5 tabs defined with icons and labels
- [x] Tab switching works (setState)
- [x] Body changes based on selected tab
- [x] Each tab shows correct screen

### ✅ Screen Implementations
- [x] IdeaFeedScreen - loads ideas, infinite scroll
- [x] CommunitiesScreen - loads communities
- [x] OrganisationsScreen - loads organisations
- [x] OrganisationDetailScreen - shows details
- [x] IdeaDetailScreen - ready for idea details + modals

### ✅ Modal Integration
- [x] RatingModal - design integrated
- [x] InviteCollaboratorsModal - design integrated
- [x] DiscussionSection - design integrated
- [x] ManageReviewersModal - controller integrated

### ✅ Error Handling
- [x] Loading states (spinners)
- [x] Error states (error messages)
- [x] Empty states (friendly messages)
- [x] Authorization (token from StorageService)

### ✅ Navigation
- [x] Tab switching works
- [x] Screen push/pop works
- [x] Modal presentation works
- [x] Back button handling works

### ✅ Services
- [x] ApiService with platform detection
- [x] StorageService for tokens
- [x] Domain services (Idea, Community, Organisation, Reviewer)

---

## Testing the Integration

### 1. **App Launch**
```bash
flutter run -d web
# ✓ Auth screen appears if not logged in
# ✓ Logs in successfully
# ✓ MainApp shows with 5 tabs
```

### 2. **Tab Navigation**
```
- Tap Tab 0 (Feed) → IdeaFeedScreen loads with ideas
- Tap Tab 1 (Communities) → CommunitiesScreen loads
- Tap Tab 2 (Organisations) → OrganisationsScreen loads
- Tap Tab 3 (Profile) → Placeholder shown
- Tap Tab 4 (Settings) → Placeholder shown
```

### 3. **Detail Navigation**
```
- Tap idea card → IdeaDetailScreen pushes
- Tap back → Returns to feed
- Tap organisation card → OrganisationDetailScreen pushes
- Tap back → Returns to organisations
```

### 4. **Modal Testing**
```
// In IdeaDetailScreen:
- Tap "Rate Idea" → RatingModal opens
- Tap "Invite Reviewers" → InviteCollaboratorsModal opens
- Tap "Manage Reviewers" → ManageReviewersModal opens
- Tap "Discussions" → DiscussionSection displayed
```

### 5. **State Management**
```
- Open Organisations, scroll down (infinite scroll works)
- Close app, reopen (token persists via StorageService)
- Go to Feed, create idea (form submission works)
- Rate idea (modal state updates)
```

---

## Remaining Implementation

### Profile Screen (Tab 3)
**TODO:**
- Create `profile_screen.dart`
- Create `user_profile_controller.dart`
- Add to MultiProvider
- Show: user info, stats, created ideas, reviews done
- Actions: edit profile, view activity, logout shortcut

### Settings Screen (Tab 4)
**TODO:**
- Create `settings_screen.dart`
- Add: app settings, notification preferences, logout
- Create `settings_controller.dart` (for preferences)

### Backend Integration Remaining
- Rating System API endpoints (create, update, delete ratings)
- Comment System API endpoints (create, delete comments)
- Invitation email notifications
- User profile endpoints

---

## Code Quality Notes

### What's Good ✅
- Clean separation of concerns (Screen → Controller → Service → API)
- Consistent error handling pattern across screens
- Reusable modal widgets with clear interfaces
- Provider pattern for state management
- Design system tokens applied consistently

### Areas for Improvement
- Type safety: Consider using generated models for API responses
- Testing: Integration tests for navigation flows
- Accessibility: Add semantic labels and keyboard navigation
- Internationalization: Extract hardcoded strings

---

## Quick Reference

### Access Controller in Widget
```dart
// Read (one-time)
var idea = context.read<IdeaController>().ideas[0];

// Watch (rebuild on change)
Consumer<IdeaController>(
  builder: (_, controller, __) => Text('${controller.ideas.length}'),
);
```

### Load Data on Screen Enter
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<IdeaController>().loadIdeas();
});
```

### Show Modal
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => ManageReviewersModal(...),
);
```

### Navigation
```dart
// Push detail screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => IdeaDetailScreen(idea: idea)),
);

// Pop back
Navigator.pop(context);
```
