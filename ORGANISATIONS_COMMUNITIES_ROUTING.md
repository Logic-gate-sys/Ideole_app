# Organizations & Communities Routing Guide

This document provides instructions for integrating the Organizations and Communities screens into your app's navigation.

## Navigation Hierarchy

```
Home Screen
├── Navigate to: Organizations List
│   ├── Create Organization (FAB or button)
│   │   └── Result: Returns to Organizations List
│   └── Tap Card: Organization Detail
│       ├── Create Community (Button)
│       │   └── Go to: Create Community Screen
│       │       └── Result: Returns to Organization Detail
│       └── Tap Community: Community Detail
│           └── Join/Start Idea buttons navigate to respective features
```

## Routes Configuration

### Define Named Routes

Add these routes to your main route configuration file:

```dart
// In your main.dart or routes configuration
static const String organisations = '/organisations';
static const String createOrganisation = '/organisations/create';
static const String organisationDetail = '/organisations/:id';
static const String createCommunity = '/organisations/:organisationId/community/create';
static const String communityDetail = '/organisations/:organisationId/community/:communityId';
```

### MaterialPageRoute Examples

#### NavigatorObserver Setup
```dart
// In MaterialApp
navigatorObservers: [HeroController()],
```

#### From Home Screen to Organizations List
```dart
ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OrganisationsListScreen(),
      ),
    );
  },
  child: const Text('Browse Organizations'),
)
```

#### From Organizations List to Organization Detail
```dart
// In OrganisationsListScreen card onTap
onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => OrganisationDetailScreen(
        organisation: organisation,
      ),
    ),
  );
}
```

#### From Organization Detail to Create Community
```dart
// In OrganisationDetailScreen FAB or button
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CreateCommunityScreen(
        organisationId: organisation.id,
      ),
    ),
  );
}
```

#### From Organization Detail to Community Detail
```dart
// In OrganisationDetailScreen community card
onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CommunityDetailScreen(
        community: community,
        organisationId: organisation.id,
      ),
    ),
  );
}
```

#### From Create Organization Back to List
```dart
// After successful creation in CreateOrganisationScreen
if (result != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Organization created!')),
  );
  Navigator.of(context).pop(); // Return to list
}
```

#### From Create Community Back to Detail
```dart
// After successful creation in CreateCommunityScreen
if (result != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Community created!')),
  );
  Navigator.of(context).pop(); // Return to organization detail
}
```

## Sample Implementation (GoRouter)

If using GoRouter, here's a complete setup:

```dart
// lib/config/router.dart
import 'package:go_router/go_router.dart';
import 'package:ideole/features/organisations/index.dart';
import 'package:ideole/features/communities/index.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Organizations routes
        GoRoute(
          path: 'organisations',
          name: 'organisations',
          builder: (context, state) => const OrganisationsListScreen(),
          routes: [
            GoRoute(
              path: 'create',
              name: 'create-organisation',
              builder: (context, state) => const CreateOrganisationScreen(),
            ),
            GoRoute(
              path: ':id',
              name: 'organisation-detail',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return OrganisationDetailScreen(organisationId: id);
              },
              routes: [
                GoRoute(
                  path: 'community/create',
                  name: 'create-community',
                  builder: (context, state) {
                    final organisationId = state.pathParameters['id']!;
                    return CreateCommunityScreen(
                      organisationId: organisationId,
                    );
                  },
                ),
                GoRoute(
                  path: 'community/:communityId',
                  name: 'community-detail',
                  builder: (context, state) {
                    final communityId =
                        state.pathParameters['communityId']!;
                    final organisationId =
                        state.pathParameters['id']!;
                    return CommunityDetailScreen(
                      communityId: communityId,
                      organisationId: organisationId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
```

## Usage with GoRouter

```dart
// Navigate to organizations list
context.goNamed('organisations');

// Navigate to create organization
context.goNamed('create-organisation');

// Navigate to organization detail
context.goNamed(
  'organisation-detail',
  pathParameters: {'id': 'org_123'},
);

// Navigate to create community
context.goNamed(
  'create-community',
  pathParameters: {'id': 'org_123'},
);

// Navigate to community detail
context.goNamed(
  'community-detail',
  pathParameters: {
    'id': 'org_123',
    'communityId': 'com_456',
  },
);
```

## Integration Points

### Provider Setup
Ensure these controllers are provided at the appropriate level:

```dart
// In your main MaterialApp or root widget
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => OrganisationController(),
    ),
    ChangeNotifierProvider(
      create: (_) => CommunityController(),
    ),
  ],
  child: YourApp(),
)
```

### Screen Parameters
Each screen accepts specific parameters:

```dart
// OrganisationsListScreen
const OrganisationsListScreen()

// CreateOrganisationScreen
const CreateOrganisationScreen()

// OrganisationDetailScreen
OrganisationDetailScreen(
  organisation: Organisation(...),
  // OR use organisationId to fetch
  organisationId: 'org_123',
)

// CreateCommunityScreen
CreateCommunityScreen(
  organisationId: 'org_123',
)

// CommunityDetailScreen
CommunityDetailScreen(
  community: Community(...),
  organisationId: 'org_123',
)
```

## Deep Linking Support

To support deep links:

```dart
// lib/config/router.dart (GoRouter)
_goRouterBuilder() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // ... existing routes
    ],
    redirect: (context, state) {
      // Handle deep links
      final location = state.location;
      
      if (location.startsWith('/organisations/')) {
        // Route to appropriate screen
      }
      return null;
    },
  );
}
```

## Bottom Navigation Integration

To add organizations/communities to bottom nav:

```dart
// In your main app with BottomNavigationBar
int _selectedIndex = 0;

// Add 'Organizations' or 'Teams' tab
BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Organizations',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Communities',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.profile),
      label: 'Profile',
    ),
  ],
  currentIndex: _selectedIndex,
  onTap: (index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        // Organizations
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const OrganisationsListScreen(),
          ),
        );
        break;
      case 2:
        // Communities
        break;
      case 3:
        // Profile
        break;
    }
  },
)
```

## Drawer Integration

Add organizations to app drawer:

```dart
// In your app drawer
ListTile(
  leading: const Icon(Icons.business),
  title: const Text('Organizations'),
  onTap: () {
    Navigator.of(context).pop(); // Close drawer
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OrganisationsListScreen(),
      ),
    );
  },
),
```

## AppBar Integration

Connect AppBar back button to navigation:

```dart
// All screens have AppBar with automatic back button
AppBar(
  title: const Text('Organization'),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.of(context).pop(),
  ),
)
```

## Error Handling & Navigation

Handle errors gracefully:

```dart
// If organization not found
try {
  final org = await controller.getOrganisation(organisationId);
  if (org == null) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organization not found')),
      );
      Navigator.of(context).pop();
    }
  }
} catch (e) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

## Testing Navigation

Unit tests for navigation:

```dart
testWidgets('Navigate to organization detail', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Tap organizations button
  await tester.tap(find.text('Browse Organizations'));
  await tester.pumpAndSettle();
  
  // Tap first organization
  await tester.tap(find.byType(Card).first);
  await tester.pumpAndSettle();
  
  // Verify detail screen shown
  expect(find.text('Communities'), findsWidgets);
});
```

## Performance Optimization

To optimize navigation performance:

1. **Lazy Load Controllers**: Only create when needed
2. **Cache Screens**: Use PageStorage to preserve scroll position
3. **Preload Data**: Fetch data before navigation if possible
4. **Use Skeletons**: Show loading skeletons while data loads

## Future Enhancements

- [ ] Tab-based navigation within organizations
- [ ] Organization switcher in AppBar
- [ ] Favorites/recent organizations quick access
- [ ] Organization search in navigation
- [ ] Breadcrumb navigation
- [ ] URL sharing deep links
- [ ] Browser back button support
- [ ] Animation transitions between screens

## Quick Reference

| Action | Example |
|--------|---------|
| List organizations | `OrganisationsListScreen()` |
| Create organization | `CreateOrganisationScreen()` |
| View organization | `OrganisationDetailScreen(organisation: org)` |
| Create community | `CreateCommunityScreen(organisationId: id)` |
| View community | `CommunityDetailScreen(community: com, organisationId: id)` |

Navigate to the Ideole_app/README.md or specific screen files for additional implementation details.
