# Organizations & Communities Feature Documentation

This document provides comprehensive documentation for the Organizations and Communities features in the Ideole mobile app, including API integration, screens, controllers, and services.

## Overview

The Organizations and Communities features enable users to create and manage organizational structures with nested communities for idea collaboration. This hierarchical structure supports:

- **Organizations**: Top-level entities owned by users, with configurable tiers (starter, professional, enterprise)
- **Communities**: Sub-entities within organizations where teams collaborate on ideas

## Architecture

```
organisations/
├── controllers/
│   └── organisation_controller.dart    # State management
├── services/
│   └── organisation_service.dart       # API integration
├── screens/
│   ├── organisations_list_screen.dart
│   ├── organisation_detail_screen.dart
│   ├── create_organisation_screen.dart
│   └── index.dart
└── index.dart

communities/
├── controllers/
│   └── community_controller.dart       # State management
├── services/
│   └── community_service.dart          # API integration
├── screens/
│   ├── create_community_screen.dart
│   ├── community_detail_screen.dart
│   └── index.dart
└── index.dart

shared/models/
├── organisation_model.dart
└── community_model.dart
```

## Data Models

### Organisation Model

```dart
class Organisation {
  final String id;            // Unique identifier
  final String name;          // Organization name
  final String tier;          // 'starter', 'professional', 'enterprise'
  final int maxCommunities;   // Maximum communities allowed
  final String ownerId;       // User ID of owner
  final DateTime createdAt;   // Creation timestamp
}
```

**Key Methods:**
- `isOwnedBy(String userId)`: Check if user owns this organization

### Community Model

```dart
class Community {
  final String id;              // Unique identifier
  final String name;            // Community name
  final String? description;    // Community description
  final String visibility;      // 'PUBLIC', 'PROTECTED', 'PRIVATE'
  final String status;          // 'ACTIVE', 'DORMANT', 'BANNED', 'PENDING'
  final String adminId;         // User ID of admin
  final String organisationId;  // Parent organization ID
  final DateTime createdAt;     // Creation timestamp
}
```

**Key Methods:**
- `isAdminOf(String userId)`: Check if user is admin
- `isActive`: Check if community is active
- `isPublic`: Check if community is public

## API Integration

### Base Endpoints

**Organization Endpoints:**
```
POST   /organisations                           # Create organization
GET    /organisations                           # List user's organizations
GET    /organisations/:id                       # Get organization details
PUT    /organisations/:id                       # Update organization
DELETE /organisations/:id                       # Delete organization
```

**Community Endpoints:**
```
POST   /organisations/:organisationId/communities                          # Create community
GET    /organisations/:organisationId/communities                          # List communities
GET    /organisations/:organisationId/communities/:communityId             # Get community
PUT    /organisations/:organisationId/communities/:communityId             # Update community
DELETE /organisations/:organisationId/communities/:communityId             # Delete community
```

### API Request/Response Examples

**Create Organization:**
```dart
// Request
POST /organisations
{
  "name": "TechStartup Co.",
  "tier": "professional"
}

// Response
{
  "success": true,
  "data": {
    "id": "org_123",
    "name": "TechStartup Co.",
    "tier": "professional",
    "maxCommunities": 20,
    "ownerId": "user_456",
    "createdAt": "2024-04-01T10:00:00Z"
  }
}
```

**Create Community:**
```dart
// Request
POST /organisations/org_123/communities
{
  "name": "Product Discussions",
  "description": "Ideas related to product features",
  "visibility": "PROTECTED"
}

// Response
{
  "success": true,
  "data": {
    "id": "com_789",
    "name": "Product Discussions",
    "description": "Ideas related to product features",
    "visibility": "PROTECTED",
    "status": "ACTIVE",
    "adminId": "user_456",
    "organisationId": "org_123",
    "createdAt": "2024-04-01T10:30:00Z"
  }
}
```

## Services

### OrganisationService

Handles all API requests related to organizations.

**Methods:**

```dart
// Create a new organization
Future<Organisation> createOrganisation({
  required String name,
  required String tier,
})

// Get specific organization
Future<Organisation> getOrganisation(String organisationId)

// List all user's organizations
Future<List<Organisation>> listOrganisations()

// Update organization
Future<Organisation> updateOrganisation({
  required String organisationId,
  required String name,
  required String tier,
})

// Delete organization
Future<void> deleteOrganisation(String organisationId)
```

### CommunityService

Handles all API requests related to communities.

**Methods:**

```dart
// Create community
Future<Community> createCommunity({
  required String organisationId,
  required String name,
  String? description,
  required String visibility,
})

// Get specific community
Future<Community> getCommunity({
  required String organisationId,
  required String communityId,
})

// List communities in organization
Future<List<Community>> listCommunities(String organisationId)

// Update community
Future<Community> updateCommunity({
  required String organisationId,
  required String communityId,
  required String name,
  String? description,
  required String visibility,
})

// Delete community
Future<void> deleteCommunity({
  required String organisationId,
  required String communityId,
})
```

## State Management

### OrganisationController

ChangeNotifier pattern for managing organization state.

**State Properties:**
- `organisations`: List<Organisation> - List of user's organizations
- `selectedOrganisation`: Organisation? - Currently selected organization
- `isLoading`: bool - Loading state
- `error`: String? - Error message

**Key Methods:**
```dart
Future<Organisation?> createOrganisation(...)
Future<Organisation?> getOrganisation(String id)
Future<List<Organisation>> listOrganisations()
Future<Organisation?> updateOrganisation(...)
Future<void> deleteOrganisation(String id)
```

### CommunityController

ChangeNotifier pattern for managing community state.

**State Properties:**
- `communitiesByOrg`: Map<String, List<Community>> - Communities organized by organization ID
- `selectedCommunity`: Community? - Currently selected community
- `isLoading`: bool - Loading state
- `error`: String? - Error message

**Key Methods:**
```dart
Future<Community?> createCommunity(...)
Future<Community?> getCommunity(...)
Future<List<Community>> listCommunities(String organisationId)
Future<Community?> updateCommunity(...)
Future<void> deleteCommunity(...)
```

## Screens

### Organizations Feature

#### 1. OrganisationsListScreen
**Purpose:** Display list of user's organizations

**Features:**
- List all user-owned organizations
- Create new organization button
- Card display with organization info (name, tier, creation date)
- Tap to navigate to organization detail
- Pull-to-refresh functionality
- Empty state with creation prompt

**Theme Integration:**
- Uses AppColors, AppSpacing, AppTextStyles
- Organization icon with primaryContainer background
- Tier displayed as label with primary color

#### 2. CreateOrganisationScreen
**Purpose:** Create a new organization

**Features:**
- Organization name input validation (3-100 characters)
- Tier selection with visual cards:
  - Starter: Up to 5 communities
  - Professional: Up to 20 communities
  - Enterprise: Unlimited communities
- Feature highlights for each tier
- Animated header with fade-in
- Create button with loading state
- Error handling with snackbars

**Validations:**
- Name is required and 3-100 characters
- Tier must be selected

#### 3. OrganisationDetailScreen
**Purpose:** View organization details and manage communities

**Features:**
- Organization header with gradient background
- Organization name and tier badge
- Communities list within organization
- Create community button
- Stats section (ideas, members, comments)
- Pull-to-refresh communities
- Empty state with community creation prompt
- Community cards with visibility icons
- Navigation to community detail

### Communities Feature

#### 1. CreateCommunityScreen
**Purpose:** Create a new community within an organization

**Features:**
- Community name input (3-100 characters)
- Optional description (max 500 characters)
- Visibility selection:
  - Public: Anyone can discover and join
  - Protected: Anyone can discover, approval to join
  - Private: Invite only
- Animated header
- Visibility cards with icons and descriptions
- Radio button selection for visibility
- Create button with loading state

**Validations:**
- Name is required and 3-100 characters
- Description max 500 characters

#### 2. CommunityDetailScreen
**Purpose:** View community details and manage members

**Features:**
- Community header with visibility indicator
- About section showing description
- Stats section (ideas, members, comments)
- Join Community button
- Start an Idea button
- Recent Ideas section (placeholder)
- Visibility badge with appropriate color-coding
  - Public: Primary color
  - Protected: Secondary color
  - Private: Tertiary color
- Admin/member indicators

## Usage Examples

### Create Organization
```dart
final controller = context.read<OrganisationController>();
final org = await controller.createOrganisation(
  name: 'TechCorp',
  tier: 'professional',
);
```

### List Organizations
```dart
final controller = context.read<OrganisationController>();
final orgs = await controller.listOrganisations();
```

### Create Community
```dart
final controller = context.read<CommunityController>();
final community = await controller.createCommunity(
  organisationId: 'org_123',
  name: 'Product Ideas',
  description: 'Discuss product features',
  visibility: 'PROTECTED',
);
```

### List Communities
```dart
final controller = context.read<CommunityController>();
final communities = await controller.listCommunities('org_123');
```

## Theme Integration

All screens use centralized theme constants:

### Colors
- **AppColors.primary** (#C2652A) - Main actions, tier badges
- **AppColors.primaryContainer** - Background for icons
- **AppColors.secondary** - Protected visibility
- **AppColors.tertiary** - Private visibility
- **AppColors.surface** - Screen background
- **AppColors.surfaceVariant** - Card backgrounds
- **AppColors.outline** - Borders
- **AppColors.onSurface** - Primary text
- **AppColors.onSurfaceVariant** - Secondary text

### Typography
- **AppTextStyles.displaySmall/Medium/Large** - Titles
- **AppTextStyles.headlineSmall/Medium** - Section headers
- **AppTextStyles.bodyLarge/Medium/Small** - Body text
- **AppTextStyles.labelSmall/Medium** - Labels, badges

### Spacing (8pt grid)
- `AppSpacing.sm` (4pt)
- `AppSpacing.md` (8pt)
- `AppSpacing.lg` (16pt)
- `AppSpacing.xl` (24pt)
- `AppSpacing.xxxl` (32pt)

### Border Radius
- `AppRadius.md` (12pt) - Cards, inputs
- `AppRadius.lg` (16pt) - Larger elements
- `AppRadius.xl` (24pt) - Chips, badges

## Error Handling

All screens implement consistent error handling:

1. **Try-Catch Blocks**: Network and parsing errors caught
2. **Snackbar Notifications**: Error messages displayed to users
3. **Loading States**: UI disabled during API calls
4. **Error Messages**: User-friendly messages in controller.error
5. **Null Safety**: All API responses validated

## Tier System

Organizations support three tiers with different capabilities:

| Feature | Starter | Professional | Enterprise |
|---------|---------|--------------|-----------|
| Communities | 5 | 20 | Unlimited |
| Members | Unlimited | Unlimited | Unlimited |
| Ideas per Community | Unlimited | Unlimited | Unlimited |
| Support | Community | Priority | Dedicated |

## Future Enhancements

- [ ] Organization member management and roles
- [ ] Community membership requests and approvals
- [ ] Organization analytics and insights
- [ ] Community moderation tools
- [ ] Bulk community operations
- [ ] Community templates
- [ ] Tier upgrade/downgrade flows
- [ ] Organization branding (logo, colors)
- [ ] Community categories and tags
- [ ] Member invitations via email

## Testing Checklist

- [ ] Create organization with different tiers
- [ ] List user's organizations
- [ ] View organization detail
- [ ] Create community with all visibility levels
- [ ] List communities within organization
- [ ] View community detail
- [ ] Join community (when implemented)
- [ ] Delete organization
- [ ] Delete community
- [ ] Error handling for failed API calls
- [ ] Loading states during API calls
- [ ] Form validation all fields
- [ ] Navigation between screens
- [ ] Theme colors and spacing applied correctly
- [ ] Responsive layout on different screen sizes

## Notes

- All API calls require authentication (token in header)
- Organizations are owned by users (only owner can manage)
- Communities are created within organizations
- Visibility controls who can discover and access communities
- Status field manages community lifecycle (ACTIVE, DORMANT, BANNED)
- Membership tracking via Membership table (platform-side)
