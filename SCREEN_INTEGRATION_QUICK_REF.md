# Screen Integration - Quick Reference

## All Integrated Screens

### ✅ Main Navigation (main.dart)
- **Feed Tab (0)** → `IdeaFeedScreen`
- **Communities Tab (1)** → `CommunitiesScreen`
- **Organisations Tab (2)** → `OrganisationsScreen`
- **Profile Tab (3)** → Placeholder (Coming Soon)
- **Settings Tab (4)** → Placeholder (Coming Soon)

### ✅ Detail Screens
- `OrganisationDetailScreen` - Push from Organisations
- `IdeaDetailScreen` - Push from Feed (ready for modals)
- `CommunityDetailScreen` - Push from Communities

### ✅ Modal Widgets
- `RatingModal` - Draggable sheet for rating ideas
- `InviteCollaboratorsModal` - Search & invite reviewers
- `DiscussionSection` - Display threaded comments
- `ManageReviewersModal` - Manage idea reviewers

---

## Controllers in MultiProvider (In order of use)

```dart
MultiProvider(
  providers: [
    // Feed - Load ideas, create, view details
    ChangeNotifierProvider<IdeaController>(...),
    ChangeNotifierProvider<CreateIdeaController>(...),
    ChangeNotifierProvider<IdeaDetailController>(...),
    
    // Communities - Browse communities
    ChangeNotifierProvider<CommunityController>(...),
    
    // Organisations - Browse organisations  
    ChangeNotifierProvider<OrganisationController>(...),
    
    // Modals - Manage reviewers inline
    ChangeNotifierProvider<ManageReviewersController>(...),
  ],
  child: MainApp(),
)
```

---

## How to Access in Any Widget

### Example 1: Load Ideas on Screen Enter
```dart
class _IdeaFeedScreenState extends State<IdeaFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Load after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IdeaController>().loadIdeas();
    });
  }
}
```

### Example 2: Display Data & Listen for Changes
```dart
@override
Widget build(BuildContext context) {
  // This rebuilds whenever IdeaController notifies
  return Consumer<IdeaController>(
    builder: (_, controller, __) {
      if (controller.isLoading) return LoadingWidget();
      if (controller.errorMessage != null) return ErrorWidget();
      if (controller.ideas.isEmpty) return EmptyWidget();
      
      return ListView(
        children: controller.ideas.map((idea) => IdeaCard(idea)).toList(),
      );
    },
  );
}
```

### Example 3: Trigger Action
```dart
ElevatedButton(
  onPressed: () {
    context.read<OrganisationController>().loadMore();
  },
  child: Text('Load More'),
)
```

### Example 4: Open Modal
```dart
void _showReviewerModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ManageReviewersModal(
      ideaId: idea.id,
      ideaTitle: idea.title,
      onReviewersChanged: _refreshIdea,
    ),
  );
}
```

---

## Controllers Overview

| Controller | Purpose | Key Methods | Status |
|-----------|---------|-----------|--------|
| `IdeaController` | Load feed ideas | `loadIdeas()`, `loadMore()` | ✅ |
| `CreateIdeaController` | Create new idea | `createIdea()` | ✅ |
| `IdeaDetailController` | Idea details | `getIdea()`, `updateIdea()` | ✅ |
| `CommunityController` | Browse communities | `loadCommunities()`, `loadMore()` | ✅ |
| `OrganisationController` | Browse organisations | `loadOrganisations()`, `loadMore()` | ✅ |
| `ManageReviewersController` | Manage reviewers | `loadReviewers()`, `removeReviewer()` | ✅ |

---

## Service Layer (Auto-injected into Controllers)

```dart
IdeaController uses:
  └─ IdeaService
      └─ ApiService (HTTP)

ReviewerService uses:
  └─ ApiService (HTTP)
  └─ StorageService (JWT tokens)
```

All services handle:
- ✅ Authentication (Bearer tokens)
- ✅ Error handling (throw exceptions)
- ✅ Network (platform-aware URLs)

---

## Screen-to-Screen Navigation

### From Feed
```dart
// Go to idea detail
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => IdeaDetailScreen(idea: idea),
  ),
);

// Go to create idea
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreateIdeaScreen(),
  ),
);
```

### From Organisations
```dart
// Go to org detail
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OrganisationDetailScreen(organisation: org),
  ),
);
```

### Go Back
```dart
Navigator.pop(context);
```

---

## Error States Handled

All screens display appropriate states:

```
Loading → Spinner shown while fetching
Error → Red error message displayed
Empty → "No items found" message
Success → Content displayed normally
```

Example pattern in all screens:
```dart
if (controller.isLoading) {
  return Center(child: CircularProgressIndicator());
}

if (controller.errorMessage != null) {
  return ErrorWidget(message: controller.errorMessage);
}

if (controller.items.isEmpty) {
  return EmptyWidget();
}

return ContentWidget(items: controller.items);
```

---

## Modals Usage

### RatingModal
```dart
showModalBottomSheet(
  context: context,
  builder: (_) => RatingModal(
    ideaId: ideaId,
    criteriaList: criteriaList,
    onSubmit: (ratings) => submitRatings(ratings),
  ),
);
```

### InviteCollaboratorsModal
```dart
showModalBottomSheet(
  context: context,
  builder: (_) => InviteCollaboratorsModal(
    ideaId: ideaId,
    onInviteComplete: () => refreshUI(),
  ),
);
```

### ManageReviewersModal
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (_) => ManageReviewersModal(
    ideaId: ideaId,
    ideaTitle: ideaTitle,
    onReviewersChanged: () => refreshUI(),
  ),
);
```

### DiscussionSection (Widget, not modal)
```dart
// Just add to widget tree
DiscussionSection(ideaId: ideaId)
```

---

## Platform Compatibility

### Web
```dart
ApiService.baseUrl = 'http://localhost:3000/api'
```

### Android Emulator
```dart
ApiService.baseUrl = 'http://10.0.2.2:3000/api'
```

### iOS Simulator
```dart
ApiService.baseUrl = 'http://localhost:3000/api' (localhost redirect)
```

---

## Key Integration Points

✅ **main.dart:**
- 6 controllers in MultiProvider
- 5-tab bottom navigation
- Auth gate before MainApp

✅ **IdeaFeedScreen:**
- Loads ideas on init
- Infinite scroll pagination
- Navigate to detail on tap
- FAB for create idea

✅ **CommunitiesScreen:**
- Search communities
- Infinite scroll
- View community details

✅ **OrganisationsScreen:**
- Search organisations
- Infinite scroll  
- View organisation details

✅ **Detail Screens:**
- Use navigator.push/pop
- Access controllers via context.read/watch
- Show modals for operations

✅ **Modals:**
- All styled with Sahara design tokens
- ManageReviewersModal has controller
- Others use service calls directly

---

## Testing the Integration

### Just Opened App?
```
✓ Auth screen (if not logged in)
✓ MainApp appears after login
✓ Feed tab shows ideas
```

### Click Feed Tab
```
✓ Ideas load with spinner
✓ Infinite scroll works (scroll down → more load)
✓ Tap idea → Detail screen opens
```

### Click Communities Tab
```
✓ Communities load
✓ Search works
✓ Tap community → Detail screen
```

### Click Organisations Tab
```
✓ Organisations load
✓ Infinite scroll works
✓ Tap organisation → Detail screen with stats
```

### In Idea Detail
```
✓ Rate Idea button → RatingModal opens
✓ Manage Reviewers button → ManageReviewersModal with data
✓ Invite Reviewers button → InviteCollaboratorsModal opens
✓ Discussion section shows comments
```

---

## What's Next?

### Profile Screen (Tab 3)
- Show logged-in user info
- Display ideas created
- Show reviews submitted
- Link to logout

### Settings Screen (Tab 4)
- App preferences
- Notification settings
- Privacy controls
- Logout button

### Backend Features
- Rating system API
- Comments system API
- Email notifications
- User profile endpoints

---

## Debugging Tips

### Controller not updating UI?
```dart
// Make sure you're using Consumer or context.watch, not context.read
❌ Wrong:
Text(context.read<IdeaController>().ideas.length.toString())

✅ Right:
Consumer<IdeaController>(
  builder: (_, controller, __) => 
    Text(controller.ideas.length.toString()),
);
```

### API not being called?
```dart
// Check console for errors:
// [GET] http://localhost:3000/api/ideas
// Should see this log
```

### Modal doesn't appear?
```dart
// Make sure you're using showModalBottomSheet correctly:
showModalBottomSheet(
  context: context,
  isScrollControlled: true,  // Important for large modals
  builder: (context) => YourModal(),
);
```

### Infinite scroll not working?
```dart
// Check ScrollController listener:
_scrollController.addListener(_onScroll);

// And pagination method:
void _onScroll() {
  if (_scrollController.position.pixels == 
      _scrollController.position.maxScrollExtent) {
    context.read<Controller>().loadMore();
  }
}
```
