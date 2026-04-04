# Ideole Mobile App - Architecture & Screen Specification

**Design System**: Sahara (Eb Garamond + Manrope, Terracotta #C2652A, Warm Cream #FAF5EE)
**Framework**: Flutter
**State Management**: Provider/ChangeNotifier (TBD)
**Navigation**: Bottom Tab Bar + Feature-level nested navigation

---

## Table of Contents

1. [Navigation Structure](#navigation-structure)
2. [Core 14 Screens](#core-14-screens)
3. [Reusable Components](#reusable-components)
4. [Screen-Component Matrix](#screen-component-matrix)
5. [Data Flow & State Management](#data-flow--state-management)
6. [API Integration Points](#api-integration-points)
7. [Implementation Order](#implementation-order)

---

## Navigation Structure

### Bottom Tab Navigation (4 Tabs)

```
┌─────────────────────────────────────────────────┐
│                  MAIN APP                        │
├─────────────────────────────────────────────────┤
│                                                   │
│          [TAB CONTENT STACKED HERE]              │
│                                                   │
│                                                   │
├─────────────────────────────────────────────────┤
│ [Feed] [Communities] [Profile] [Settings]        │
└─────────────────────────────────────────────────┘
```

### Navigation Tree

```
Root (Splash)
└── AuthGate
    ├── Sign In Screen
    └── Sign Up Screen
    
    └── MainApp (Bottom Tab Navigation)
        ├── Feed Stack
        │   ├── Idea Feed Screen
        │   ├── Create Idea Screen
        │   └── Idea Detail Screen
        │       └── Manage Reviewers (collapsible)
        │       └── Invite Modal (bottom sheet)
        │       └── Rate Idea Modal (bottom sheet)
        │
        ├── Communities Stack
        │   ├── Communities List Screen
        │   └── Community Detail Screen
        │       └── Community Members (section)
        │       └── Community Ideas (section)
        │
        ├── Profile Stack
        │   ├── Profile Dashboard Screen
        │   ├── Edit Profile Modal
        │   ├── My Ideas (tab/section)
        │   ├── My Communities (tab/section)
        │   └── Settings Screen
        │
        └── System Screens
            ├── Error State Screen
            └── Empty State Variants
```

---

## Core 14 Screens

### **SCREEN 1: Splash Screen**
**Purpose**: App startup, check authentication status, initialize app state
**Components**: 
- Logo centered
- Loading indicator
- App name

**Lifecycle**:
1. Show for 2-3 seconds
2. Check `SharedPreferences` for saved JWT token
3. If token exists: Validate token → Fetch user profile → Navigate to MainApp
4. If no token: Navigate to Sign In
5. On error: Show Error State → Allow retry

**Interactions**:
- Auto-navigates to Auth or MainApp
- No user interaction

---

### **SCREEN 2: Sign In Screen**
**Purpose**: Authenticate user with email/password
**Components**:
- `SaharaAppBar` (title: "Welcome Back")
- `EmailTextField` (label: "Email")
- `PasswordTextField` (label: "Password", obscured)
- `PrimaryButton` (label: "Sign In", onPressed: login)
- `TextLink` (label: "Forgot password?", navigate to password reset flow)
- `SecondaryButton` (label: "Create Account", navigate to Sign Up)
- `ErrorMessage` (displays validation/API errors)
- `LoadingOverlay` (show during API request)

**Data Flow**:
```
EmailTextField + PasswordTextField 
  → Zod validation (client-side)
  → POST /api/auth/login
  → Save JWT token to SharedPreferences
  → Fetch user profile
  → Navigate to MainApp
```

**State**:
- `isLoading: bool`
- `email: String`
- `password: String`
- `errorMessage: String?`

**API Calls**:
- `POST /api/auth/login` → Returns `{ accessToken, refreshToken, user }`

---

### **SCREEN 3: Sign Up Screen**
**Purpose**: Register new user account
**Components**:
- `SaharaAppBar` (title: "Create Account")
- `EmailTextField` (label: "Email")
- `PasswordTextField` (label: "Password")
- `PasswordConfirmTextField` (label: "Confirm Password")
- `NameTextField` (label: "Full Name")
- `BioTextField` (label: "Bio (optional)")
- `PrimaryButton` (label: "Sign Up", onPressed: register)
- `TextLink` (label: "Already have an account?", navigate to Sign In)
- `ErrorMessage` (displays validation/API errors)
- `SuccessMessage` (shows after registration)
- `LoadingOverlay`

**Data Flow**:
```
Form fields 
  → Zod validation (password strength, email format)
  → POST /api/auth/register
  → Auto-login (same JWT flow as Sign In)
  → Navigate to MainApp
```

**State**:
- `isLoading: bool`
- `email: String`
- `password: String`
- `confirmPassword: String`
- `name: String`
- `bio: String?`
- `errorMessage: String?`

**API Calls**:
- `POST /api/auth/register` → Returns JWT + user profile
- Auto-login via POST /api/auth/login

---

### **SCREEN 4: Idea Feed Screen**
**Purpose**: Display list of ideas user can view (respects visibility)
**Components**:
- `SaharaAppBar` (title: "Ideas Feed")
  - Filter button (My Ideas / All Ideas toggle)
  - Notification bell icon (placeholder for v2)
- `IdeaCard` (reusable, shows title, creator, description, rating circles)
  - Card image/placeholder
  - Idea title (headline medium)
  - Creator avatar + name (body small)
  - Description snippet (body small, truncated)
  - Rating badge (shows avg score if available)
  - Visibility badge (PUBLIC/PROTECTED/PRIVATE)
  - Quick actions: `TapHandler` to navigate to detail
- `FloatingActionButton` (navigate to Create Idea)
- `RefreshIndicator` (pull-to-refresh feed)
- `PaginationLoader` (infinite scroll)
- `EmptyState` (if no ideas)

**Data Flow**:
```
Page Load:
  → GET /api/ideas (with optional: filter=myIdeas)
  → Display ideas respecting visibility
  → Cache in state

User Pull-Refresh:
  → GET /api/ideas (fresh)
  → Update cache

User Scroll:
  → GET /api/ideas (with pagination offset)
  → Append to cache

User Tap IdeaCard:
  → Navigate to Idea Detail
  → Pass idea ID as param
```

**State**:
- `ideas: List<Idea>`
- `isLoading: bool`
- `isRefreshing: bool`
- `paginationOffset: int`
- `filterMode: 'all' | 'myIdeas'`
- `errorMessage: String?`

**API Calls**:
- `GET /api/ideas` (with query params: `limit=10&offset=0&filter=myIdeas?`)
- `GET /api/ideas/:ideaId` (when user navigates to detail)

---

### **SCREEN 5: Create Idea Screen**
**Purpose**: Form for user to create new idea
**Components**:
- `SaharaAppBar` (title: "Create New Vision", back button)
- `FormSections`:
  1. **Basic Info Section**
     - `TitleTextField` (label: "Vision Title", maxLength: 100)
     - `DescriptionTextArea` (label: "Description", maxLength: 500, char counter)
  
  2. **Visibility Section**
     - `RadioButtonGroup` (options: PUBLIC, PROTECTED, PRIVATE)
     - Helper text explaining each visibility level
  
  3. **Media Section** (optional for MVP)
     - `ImageUploadButton` (select cover image)
     - Image preview
  
  4. **Evaluation Criteria Section** (optional)
     - `TextLink` (label: "Add evaluation criteria", shows form)
     - If added: `CriteriaItem` (name, weight)
     - `RemoveButton` per criterion
  
  5. **Action Buttons**
     - `PrimaryButton` (label: "Create Idea", onPressed: submit)
     - `SecondaryButton` (label: "Save as Draft", onPressed: save locally)
     - Bottom padding for safe area

**Data Flow**:
```
User fills form
  → Client-side Zod validation
  → (Optional) Upload image to storage
  → POST /api/ideas { title, description, visibility, imageUrl? }
  → If criteria provided: POST /api/ideas/:ideaId/criteria (for each)
  → Success toast notification
  → Navigate to Idea Detail
```

**State**:
- `title: String`
- `description: String`
- `visibility: 'PUBLIC' | 'PROTECTED' | 'PRIVATE'`
- `imageUrl: String?`
- `criteria: List<{ name: String, weight: double? }>`
- `isLoading: bool`
- `errorMessage: String?`
- `draftSaved: bool`

**API Calls**:
- `POST /api/ideas` → Create idea
- `POST /api/ideas/:ideaId/criteria` → Create evaluation criteria (if provided)

---

### **SCREEN 6: Idea Detail Screen**
**Purpose**: Full view of single idea with all details
**Components**:
- **Hero Section**
  - `HeroImage` (cover image or placeholder)
  - Gradient overlay with text
  - Idea title (display medium/large)
  - Creator info (avatar, name, date)
  - Visibility badge

- **Metrics Section**
  - `MetricCard` x3 (Evaluation Criteria display)
    - Criterion name (label)
    - Average score (body large, bold)
    - Visual bar/circle indicator
  - `RateButton` (secondary, navigate to rate modal)
  - Edit/Delete buttons (if owner)

- **Evaluation Criteria Section**
  - For each criterion: name + description
  - List of who has rated (avatar list)

- **Manage Reviewers Section** (Collapsible)
  - `CollapsibleHeader` (title: "Manage Reviewers")
  - `ReviewerItem` (avatar, name, status badge: pending/submitted/rejected)
  - `InviteButton` (secondary, opens invite modal)
  - `RemoveButton` per reviewer (if owner)

- **Action Buttons** (sticky/floating)
  - `PrimaryButton` (label: "Rate Idea")
  - `SecondaryButton` (label: "Discuss")
  - `IconButton` (Share, Bookmark - v2 features)

**Data Flow**:
```
Page Load:
  → GET /api/ideas/:ideaId
  → GET /api/ideas/:ideaId/criteria
  → (Future) GET /api/ideas/:ideaId/ratings
  → Display all data

User Taps "Rate Idea":
  → Open Rate Idea Modal
  → Submit rating
  → Refresh idea detail

User Taps "Invite Reviewer":
  → Open Invite Modal
  → Select user
  → POST /api/ideas/:ideaId/invites
  → Update reviewer list

User Taps "Edit/Delete" (if owner):
  → Navigate to Create Idea screen (edit mode)
  → Allow updates
  → DELETE if needed
```

**State**:
- `idea: Idea`
- `criteria: List<Criterion>`
- `ratings: List<Rating>?` (future)
- `reviewers: List<Reviewer>`
- `isLoading: bool`
- `errorMessage: String?`
- `userRating: Rating?` (if current user has rated)

**API Calls**:
- `GET /api/ideas/:ideaId`
- `GET /api/ideas/:ideaId/criteria`

---

### **SCREEN 6a: Rate Idea Modal** (Bottom Sheet)
**Purpose**: Submit evaluation scores for idea
**Components**:
- Modal header (title: "Rate This Vision")
- For each evaluation criterion:
  - `CriterionName` (label)
  - `Slider` (0-10 or 0-5, depending on design)
  - `ScoreDisplay` (shows selected value)
- `TextArea` (optional: "Additional feedback")
- `PrimaryButton` (label: "Submit Rating")
- `SecondaryButton` (label: "Cancel")

**Data Flow**:
```
User adjusts sliders
  → Display live score feedback
  → User adds optional feedback
  → User taps Submit
  → POST /api/ideas/:ideaId/ratings { scores, feedback }
  → Close modal
  → Refresh idea detail metrics
```

**State**:
- `scores: Map<criteriaId, number>`
- `feedback: String?`
- `isSubmitting: bool`

---

### **SCREEN 6b: Invite Collaborators Modal** (Bottom Sheet)
**Purpose**: Invite users to review/collaborate on idea
**Components**:
- Modal header (title: "Invite Reviewer")
- `UserSearchField` (search by email/name)
- `UserList` (showing search results or recent contacts)
  - `UserListItem` (avatar, name, email)
  - `SelectCheckbox` (allow multi-select)
- `RoleSelector` (dropdown: Reviewer, Collaborator)
- `PrimaryButton` (label: "Send Invites")
- `SecondaryButton` (label: "Cancel")

**Data Flow**:
```
User searches for contact
  → Filter users list
  → User selects users to invite
  → User selects role
  → Tap "Send Invites"
  → POST /api/ideas/:ideaId/invites { userIds, role }
  → Close modal
  → Refresh reviewer list in detail
```

**State**:
- `searchQuery: String`
- `filteredUsers: List<User>`
- `selectedUserIds: List<String>`
- `selectedRole: 'reviewer' | 'collaborator'`
- `isSubmitting: bool`

---

### **SCREEN 7: Communities List Screen**
**Purpose**: Discover and browse communities
**Components**:
- `SaharaAppBar` (title: "Communities")
  - Search icon (opens search)
  - Filter icon (opens filter modal)
- `SearchBar` (search by name, description)
- `FilterChips` (filter by: joined, active, size)
- `CommunityCard` (reusable, in grid or list)
  - Community image/placeholder
  - Community name (headline small)
  - Member count (body small)
  - Brief description (body small, truncated)
  - `JoinButton` or `ViewButton` (depending on membership)
  - Tap handler → navigate to community detail
- `RefreshIndicator`
- `PaginationLoader`
- `EmptyState`

**Data Flow**:
```
Page Load:
  → GET /api/organisations/:orgId/communities
  → Display communities
  → Cache results

User Searches:
  → Filter local cache (or API with query)
  → Display results

User Taps Community:
  → Navigate to Community Detail
  → Pass communityId

User Taps "Join":
  → POST /api/communities/:communityId/memberships/request
  → Success notification
  → Update button to "Leave" (after approval)
```

**State**:
- `communities: List<Community>`
- `filteredCommunities: List<Community>`
- `isLoading: bool`
- `searchQuery: String`
- `activeFilters: List<String>`
- `userMemberships: Set<String>` (cached community IDs user is member of)

**API Calls**:
- `GET /api/organisations/:orgId/communities`
- `GET /api/users/me/memberships` (to determine which communities user is in)

---

### **SCREEN 8: Community Detail Screen**
**Purpose**: Full view of community with ideas and members
**Components**:
- **Hero Section**
  - `HeroImage` (community cover)
  - Community name (display medium)
  - Member count (body medium)
  - Join/Leave button or Admin section

- **Tab Navigation**
  - Tab 1: "Ideas" 
  - Tab 2: "Members"

- **Tab 1: Ideas Section**
  - `IdeaCard` list (ideas within this community)
  - Create new idea button (if member)
  - Empty state if no ideas

- **Tab 2: Members Section**
  - `MemberListItem` (avatar, name, role badge)
  - Member count header
  - Scroll list
  - Admin controls if user is community admin (remove member)

- **Action Buttons**
  - `PrimaryButton` (label: "Create Idea", if member)
  - `SecondaryButton` (label: "Manage", if admin - opens admin modal)

**Data Flow**:
```
Page Load:
  → GET /api/communities/:communityId
  → GET /api/communities/:communityId/ideas (or filtered GET /api/ideas)
  → GET /api/communities/:communityId/members (optional, if endpoint exists)
  → Display all tabs

User Switches Tabs:
  → Show cached data or fetch if needed

User Taps Idea:
  → Navigate to Idea Detail
  
User Taps "Create Idea":
  → Navigate to Create Idea (pre-select community)
  
User Taps "Leave Community":
  → DELETE /api/communities/:communityId/memberships/:membershipId
  → Navigate back to Communities List
```

**State**:
- `community: Community`
- `ideas: List<Idea>`
- `members: List<Member>`
- `isLoading: bool`
- `activeTab: 'ideas' | 'members'`
- `userRole: 'admin' | 'member' | 'none'`

**API Calls**:
- `GET /api/communities/:communityId`
- `GET /api/ideas` (with filter: `communityId`)

---

### **SCREEN 9: Profile Dashboard Screen**
**Purpose**: User's main profile view with stats and quick actions
**Components**:
- **Profile Header**
  - `UserAvatar` (large, centered)
  - User name (headline medium)
  - User bio (body small)
  - "Edit Profile" button (secondary)

- **Stats Section**
  - `StatCard` x3
    - Ideas Created: count
    - Communities Joined: count
    - Pending Invitations: count
  - Tap on "Pending Invitations" → Show invitation list modal

- **Quick Actions**
  - `PrimaryButton` (label: "Create New Idea")
  - `SecondaryButton` (label: "Browse Communities")

- **Profile Sections** (Expandable/Tabs)
  - "My Ideas" tab (list of user's ideas)
  - "My Communities" tab (list of joined communities)

- **Bottom Navigation**
  - "Settings" link
  - "Logout" button

**Data Flow**:
```
Page Load:
  → GET /api/users/me (current user profile)
  → GET /api/users/me/ideas (user's ideas)
  → GET /api/users/me/memberships (user's communities)
  → Display all data

User Taps "Edit Profile":
  → Navigate to Edit Profile Modal

User Taps Idea:
  → Navigate to Idea Detail

User Taps Community:
  → Navigate to Community Detail

User Taps "Pending Invitations":
  → Show invitation list modal (future feature)
```

**State**:
- `user: User`
- `userIdeas: List<Idea>`
- `userCommunities: List<Community>`
- `pendingInvitations: List<Invitation>?` (future)
- `isLoading: bool`
- `activeTab: 'ideas' | 'communities'`

**API Calls**:
- `GET /api/users/me`
- `GET /api/users/me/ideas`
- `GET /api/users/me/memberships`

---

### **SCREEN 9a: Edit Profile Modal**
**Purpose**: Update user profile information
**Components**:
- Modal header (title: "Edit Profile")
- `AvatarUploadButton` (select/upload new avatar)
- `NameTextField` (label: "Full Name")
- `BioTextArea` (label: "Bio")
- `LocationTextField` (label: "Location - optional")
- `PrimaryButton` (label: "Save Changes")
- `SecondaryButton` (label: "Cancel")
- `ErrorMessage`

**Data Flow**:
```
User modifies fields
  → Zod validation
  → (Optional) Upload avatar image
  → PUT /api/users/me { name, bio, location, avatarUrl? }
  → Update local user state
  → Show success message
  → Close modal
```

**State**:
- `name: String`
- `bio: String`
- `location: String?`
- `avatarUrl: String?`
- `isLoading: bool`
- `errorMessage: String?`

**API Calls**:
- `PUT /api/users/me`

---

### **SCREEN 10: Settings Screen**
**Purpose**: App settings and preferences
**Components**:
- `SaharaAppBar` (title: "Settings", back button)
- **Settings Sections**:
  1. **Account**
     - Email: display only (email)
     - Last active: timestamp display
     - Change password: button → password modal (future)
  
  2. **Notifications** (future)
     - Push notifications: toggle
     - Email notifications: toggle
     - Digest emails: dropdown
  
  3. **Privacy** (future)
     - Profile visibility: dropdown
     - Allow idea sharing: toggle
  
  4. **About**
     - App version: display
     - Terms of Service: link
     - Privacy Policy: link
  
  5. **Danger Zone**
     - Refresh token: button (manual logout all devices)
     - Logout: button → confirmation → POST /api/auth/logout
     - Delete account: button → confirmation modal

- Bottom padding for safe area

**Data Flow**:
```
User Toggles Setting:
  → Update local SharedPreferences
  → (Future) PATCH /api/users/me/preferences

User Taps "Logout":
  → Confirmation dialog
  → POST /api/auth/logout
  → Clear stored tokens
  → Navigate to Sign In

User Taps "Delete Account":
  → Confirmation modal
  → DELETE /api/users/me
  → Clear all data
  → Navigate to Sign In
```

**State**:
- `appVersion: String`
- `userEmail: String`
- `lastActive: DateTime`
- `notificationSettings: Map` (future)
- `privacySettings: Map` (future)

---

### **SCREEN 11: Error State Screen**
**Purpose**: Handle API errors, network failures, server errors
**Components**:
- `ErrorIcon` (large, centered)
- `ErrorTitle` (headline medium: "Oops, something went wrong")
- `ErrorMessage` (body medium: descriptive error message)
- `RetryButton` (primary, reloads/retries last action)
- `HomeButton` (secondary, navigate to Feed)
- `ContactSupportLink` (text link, future feature)

**Navigation Flow**:
```
API Error Occurs:
  → Any screen can show error state overlay or full-screen
  → User taps "Retry"
  → Repeat last failed API call
  → User taps "Home"
  → Navigate to Feed
```

**State**:
- `errorCode: String`
- `errorMessage: String`
- `lastAttemptedAction: Function?` (to retry)

---

### **SCREEN 12: Empty State Variants**
**Purpose**: Gracefully handle empty lists/no data scenarios
**Components** (used in multiple contexts):

**Variant 1: No Ideas**
- Icon (empty briefcase)
- Title: "No ideas yet"
- Message: "Create your first vision or explore community ideas"
- `PrimaryButton` (label: "Create Idea")
- `SecondaryButton` (label: "Browse Communities")

**Variant 2: No Communities**
- Icon (empty group)
- Title: "No communities yet"
- Message: "Discover and join communities to share ideas"
- `PrimaryButton` (label: "Browse Communities")

**Variant 3: No Collaborators**
- Icon (empty person)
- Title: "No reviewers invited"
- Message: "Invite people to review and provide feedback on your vision"
- `PrimaryButton` (label: "Invite Reviewer")

**Variant 4: No Search Results**
- Icon (magnifying glass)
- Title: "No results found"
- Message: "Try a different search term"
- `SecondaryButton` (label: "Clear search")

---

### **SCREEN 13: Splash/Loading Screen** (Component)
- Centered logo (Ideole branding)
- Loading spinner below
- App tagline or version number

---

### **SCREEN 14: Network Error Screen** (Component)
- Offline icon
- Title: "No internet connection"
- Message: "Check your connection and try again"
- `RetryButton` (checks connectivity)

---

## Reusable Components

### **Design Tokens First**
All components use:
- Colors: `SaharaColors.primary`, `SaharaColors.onPrimary`, etc.
- Typography: `SaharaTypography.bodyLarge`, `SaharaTypography.headlineMedium`, etc.
- Spacing: `const EdgeInsets.all(16)`, `const SizedBox(height: 8)`, etc.
- Border radius: `BorderRadius.circular(4)`, `BorderRadius.circular(8)`, etc.

### **Atomic Components**

#### **Buttons**
1. **PrimaryButton**
   - Background: `SaharaColors.primary`
   - Text: `SaharaColors.onPrimary`
   - Border radius: `8`
   - Padding: `16 vertical, 24 horizontal`
   - Props: `label: String, onPressed: VoidCallback, isLoading: bool?`

2. **SecondaryButton**
   - Background: `SaharaColors.surfaceVariant`
   - Text: `SaharaColors.onSurfaceVariant`
   - Border: `1px SaharaColors.outline`
   - Border radius: `8`
   - Padding: `16 vertical, 24 horizontal`
   - Props: `label: String, onPressed: VoidCallback`

3. **TextButton**
   - Background: transparent
   - Text: `SaharaColors.primary`
   - Underline: on hover/focus
   - Props: `label: String, onPressed: VoidCallback`

4. **IconButton**
   - Background: transparent
   - Icon color: `SaharaColors.onSurface`
   - Size: `24 / 32 / 48`

#### **Input Fields**
1. **TextFieldInput**
   - Border: `1px SaharaColors.outline`
   - Border radius: `8`
   - Padding: `12 vertical, 16 horizontal`
   - Label: `SaharaTypography.labelMedium`
   - Props: `label: String, hint: String?, value: String, onChanged: Function, validator: Function?`

2. **PasswordField**
   - Same as TextFieldInput
   - Eye icon toggle for visibility
   - Hide/show password state

3. **TextAreaInput**
   - Multiline variant
   - Character counter (e.g., "120/500")
   - Props: `label, hint, value, onChanged, maxLength, validator`

4. **SearchField**
   - Clear button (X icon) when text entered
   - Rounded corners (border-radius: 24)
   - Props: `onChanged, onClear`

#### **Cards & Containers**
1. **IdeaCard**
   - Shadow / elevation: `2`
   - Border radius: `12`
   - Padding: `16`
   - Layout:
     ```
     [CoverImage]
     [Title]
     [Creator Avatar + Name]
     [Description snippet]
     [Rating badge + Visibility badge]
     ```
   - Props: `idea: Idea, onTap: Function`

2. **CommunityCard**
   - Shadow / elevation: `2`
   - Border radius: `12`
   - Padding: `16`
   - Layout:
     ```
     [Community Image]
     [Community Name]
     [Member Count]
     [Description]
     [Join/View Button]
     ```
   - Props: `community: Community, onTap: Function, onJoin: Function?`

3. **MemberCard**
   - Border: `1px SaharaColors.outline`
   - Border radius: `8`
   - Padding: `12`
   - Layout:
     ```
     [Avatar] [Name + Role] [Action Button?]
     ```
   - Props: `member: Member, action: Widget?`

4. **StatCard**
   - Background: `SaharaColors.surfaceVariant`
   - Border radius: `12`
   - Padding: `16`
   - Layout:
     ```
     [Title]
     [Large Number]
     [Subtitle]
     ```
   - Props: `title: String, value: num, subtitle: String?`

#### **Badges & Indicators**
1. **VisibilityBadge**
   - Colors:
     - PUBLIC: Green
     - PROTECTED: Amber
     - PRIVATE: Red
   - Border radius: `4`
   - Padding: `4 vertical, 8 horizontal`
   - Props: `visibility: String`

2. **RatingBadge**
   - Circular indicator (0-10 scale)
   - Center number
   - Background: `SaharaColors.primary`
   - Props: `score: double`

3. **StatusBadge**
   - For reviewer status (pending, submitted, rejected)
   - Colors based on status
   - Border radius: `4`
   - Props: `status: String`

4. **MemberCountBadge**
   - Compact badge: "120 members"
   - Background: `SaharaColors.surfaceVariant`
   - Props: `count: int`

#### **Navigation Components**
1. **SaharaAppBar**
   - Background: `SaharaColors.surface`
   - Title: `SaharaTypography.headlineSmall`
   - Back button (if not root)
   - Action icons (right-aligned)
   - Props: `title: String, actions: List<Widget>?, onBackPressed: Function?`

2. **BottomTabBar**
   - 4 tabs: Feed, Communities, Profile, Settings
   - Active tab: `SaharaColors.primary`
   - Inactive tab: `SaharaColors.onSurfaceVariant`
   - Icons + labels

#### **Dialog & Modal Components**
1. **ConfirmationDialog**
   - Title, message
   - Primary button (e.g., "Delete")
   - Secondary button (e.g., "Cancel")
   - Props: `title, message, onConfirm, onCancel`

2. **BottomSheet**
   - Rounded top corners (border-radius: 16)
   - Drag handle
   - Scrollable content
   - Use for: Rate Idea, Invite Collaborators, etc.

3. **LoadingOverlay**
   - Semi-transparent dark background
   - Centered spinner + optional text
   - Blocks interaction

#### **List & Grid Components**
1. **ListView** (for ideas, communities)
   - Spacing between items: `8`
   - Padding: `16`

2. **GridView** (for community cards)
   - Cross-axis count: `2`
   - Spacing: `12`
   - Padding: `16`

3. **ScrollableList**
   - Infinite scroll with pagination
   - Loading indicator at bottom
   - Refresh indicator at top

#### **Typography Components**
1. **HeadlineText**
   - Props: `text: String, size: 'large' | 'medium' | 'small'`
   - Uses: `SaharaTypography.headline[Large/Medium/Small]`

2. **BodyText**
   - Props: `text: String, size: 'large' | 'medium' | 'small', color: Color?`
   - Uses: `SaharaTypography.body[Large/Medium/Small]`

3. **LabelText**
   - Props: `text: String, size: 'large' | 'medium' | 'small'`
   - Uses: `SaharaTypography.label[Large/Medium/Small]`

---

## Screen-Component Matrix

| Screen | Primary Components | Supporting Components | Modals/Sheets |
|--------|-------------------|----------------------|----------------|
| **Splash** | Logo, LoadingSpinner | - | - |
| **Sign In** | SaharaAppBar, EmailTextField, PasswordTextField, PrimaryButton, TextLink, ErrorMessage, LoadingOverlay | BodyText, HeadlineText | - |
| **Sign Up** | SaharaAppBar, EmailTextField, PasswordTextField, ConfirmPasswordField, NameTextField, BioTextArea, PrimaryButton, TextLink, ErrorMessage, LoadingOverlay | BodyText, HeadlineText | - |
| **Idea Feed** | SaharaAppBar, IdeaCard, RefreshIndicator, PaginationLoader, EmptyState, FloatingActionButton | BodyText, VisibilityBadge, RatingBadge | - |
| **Create Idea** | SaharaAppBar, TitleTextField, DescriptionTextArea, RadioButtonGroup (Visibility), ImageUploadButton, CriteriaForm, PrimaryButton, SecondaryButton | LabelText, BodyText, ErrorMessage | - |
| **Idea Detail** | SaharaAppBar, HeroImage, MetricCard, EvaluationCriteriaList, CollapsibleSection (Reviewers), PrimaryButton (Rate), SecondaryButton (Discuss) | HeadlineText, BodyText, VisibilityBadge, RatingBadge, StatusBadge, UserAvatar | Rate Modal, Invite Modal |
| **Communities List** | SaharaAppBar, CommunityCard, SearchBar, FilterChips, RefreshIndicator, PaginationLoader, EmptyState | BodyText, MemberCountBadge | Filter Modal |
| **Community Detail** | SaharaAppBar, HeroImage, TabBar, IdeaCard (Ideas Tab), MemberCard (Members Tab), PrimaryButton (Create Idea) | HeadlineText, BodyText, StatCard | Manage Admins Modal |
| **Profile Dashboard** | SaharaAppBar, UserAvatar, HeadlineText, StatCard, PrimaryButton (Create Idea), TabBar (My Ideas / My Communities), IdeaCard / CommunityCard | BodyText, LabelText, SecondaryButton | Edit Profile Modal |
| **Settings** | SaharaAppBar, SettingsSection, Toggle, Dropdown, TextLink, LogoutButton | BodyText, LabelText, ConfirmationDialog | Change Password Modal |
| **Error State** | ErrorIcon, HeadlineText, BodyText, RetryButton, HomeButton | - | - |
| **Empty State** | Icon, HeadlineText, BodyText, PrimaryButton, SecondaryButton | - | - |

---

## Data Flow & State Management

### **State Architecture**

We'll use **Provider** with **ChangeNotifier** pattern:

```
lib/
├── controllers/
│   ├── auth_controller.dart (manages login, signup, token)
│   ├── idea_controller.dart (manages ideas crud, listing)
│   ├── community_controller.dart (manages communities)
│   ├── user_controller.dart (manages user profile)
│   └── app_controller.dart (global app state)
├── models/
│   ├── idea.dart
│   ├── community.dart
│   ├── user.dart
│   └── rating.dart (future)
├── services/
│   ├── api_service.dart (HTTP client, base requests)
│   ├── idea_service.dart (idea API calls)
│   ├── community_service.dart (community API calls)
│   ├── auth_service.dart (auth/token management)
│   └── storage_service.dart (SharedPreferences, local cache)
└── screens/
    ├── splash.dart
    ├── auth/
    ├── feed/
    ├── communities/
    └── profile/
```

### **State Flow Example: Idea Feed**

```
User Opens App
  ↓
[IdeaFeedController] initializes with ChangeNotifier
  ↓
[IdeaService.getIdeas()] → GET /api/ideas
  ↓
[notifyListeners()] → Rebuild UI with ideas list
  ↓
User Pulls Refresh
  ↓
[IdeaService.refresh()] → Fresh GET /api/ideas
  ↓
[notifyListeners()] → Update UI
  ↓
User Scrolls (pagination)
  ↓
[IdeaService.loadMore(offset)] → GET /api/ideas?offset=10
  ↓
[notifyListeners()] → Append to list
```

### **Global State: Auth**

```
[SharedPreferences] stores: accessToken, refreshToken, userId
  ↓
[AuthController] checks token on app start
  ↓ (if valid)
Auto-login → Fetch user profile
  ↓ (if invalid/expired)
Navigate to Sign In
  ↓
After successful login
  ↓
Save token + user to [SharedPreferences]
[AuthController] updates notifyListeners()
  ↓
Navigate to MainApp (bottom tab navigation)
```

---

## API Integration Points

### **Authentication Flow**
```
POST /api/auth/register
  ↓ Success response: { accessToken, refreshToken, user }
  ↓ Save to SharedPreferences
  ↓ Auto-login sequence

POST /api/auth/login
  ↓ Success response: { accessToken, refreshToken, user }
  ↓ Save token
  ↓ Navigate to MainApp

POST /api/auth/refresh (on token expiry)
  ↓ Refresh accessToken
  ↓ Retry failed request

POST /api/auth/logout
  ↓ Clear tokens
  ↓ Navigate to Sign In
```

### **Ideas Flow**
```
GET /api/ideas
  ↓ Optional auth header
  ↓ Returns ideas respecting visibility
  ↓ Cache in controller

GET /api/ideas/:ideaId
  ↓ Optional auth
  ↓ Full idea data + criteria

POST /api/ideas
  ↓ Auth required
  ↓ Create new idea

PUT /api/ideas/:ideaId
  ↓ Auth + ownership check
  ↓ Update idea

DELETE /api/ideas/:ideaId
  ↓ Auth + ownership check
  ↓ Delete idea

POST /api/ideas/:ideaId/criteria (future)
  ↓ Auth + ownership check
  ↓ Create evaluation criteria
```

### **Communities Flow**
```
GET /api/organisations/:orgId/communities
  ↓ List org communities

GET /api/communities/:communityId
  ↓ Full community data

POST /api/communities/:communityId/memberships/request
  ↓ Auth required
  ↓ Request to join

GET /api/users/me/memberships
  ↓ User's joined communities
```

### **User Flow**
```
GET /api/users/me
  ↓ Current user profile

PUT /api/users/me
  ↓ Update profile (name, bio, avatar)

GET /api/users/me/ideas
  ↓ User's ideas

GET /api/users/me/memberships
  ↓ User's communities
```

---

## Implementation Order

### **Phase 1: Foundation** (Weeks 1-2)
- [x] Setup colors.dart design tokens
- [x] Setup typography.dart design tokens
- [ ] Create spacing/sizing constants
- [ ] Create all atomic components (buttons, inputs, badges)
- [ ] Setup API service + HTTP client
- [ ] Setup storage service (SharedPreferences wrapper)

### **Phase 2: Auth** (Week 2)
- [ ] Build Sign In Screen
- [ ] Build Sign Up Screen
- [ ] Implement AuthController + AuthService
- [ ] Setup token persistence
- [ ] Implement auth middleware
- [ ] Build Splash Screen with auth check

### **Phase 3: Core Feed** (Week 3)
- [ ] Build Idea Feed Screen
- [ ] Implement IdeaController + IdeaService
- [ ] Build IdeaCard component
- [ ] Add refresh + pagination
- [ ] Build Create Idea Screen
- [ ] Implement idea creation flow

### **Phase 4: Idea Detail** (Week 4)
- [ ] Build Idea Detail Screen
- [ ] Display evaluation criteria
- [ ] Build Rate Idea Modal (basic, no submission yet)
- [ ] Build Invite Collaborators Modal (basic)
- [ ] Display reviewer list (collapsible)

### **Phase 5: Communities** (Week 5)
- [ ] Build Communities List Screen
- [ ] Build Community Detail Screen
- [ ] Implement CommunityController + CommunityService
- [ ] Add membership request/join flow
- [ ] Display community ideas and members

### **Phase 6: Profile** (Week 5-6)
- [ ] Build Profile Dashboard Screen
- [ ] Build Edit Profile Modal
- [ ] Build Settings Screen
- [ ] Implement UserController
- [ ] Add logout flow

### **Phase 7: Polish & Testing** (Week 7)
- [ ] Error states + error handling
- [ ] Empty states for all lists
- [ ] Loading states + network error handling
- [ ] Navigation transitions
- [ ] Testing (widgets, integration)
- [ ] Performance optimization

### **Phase 8: Future Features** (v1.1+)
- [ ] Rating submission (when backend ready)
- [ ] Comments/discussion screen (when backend ready)
- [ ] Invitations (when backend ready)
- [ ] Messaging (when backend ready)
- [ ] Notifications
- [ ] Search/filtering enhancements
- [ ] Bookmarks/Favorites
- [ ] Dark mode

---

## Summary: How It All Works Together

### **User Journey: Create & Share Idea**
1. User opens app → **Splash** checks auth
2. Not logged in → **Sign In** screen
3. Logs in → Navigates to **MainApp** (Feed tab)
4. Taps FAB → **Create Idea** form
5. Fills form + selects visibility + adds criteria → Submits
6. API creates idea + POST /api/ideas/criteria
7. Success → Navigates to **Idea Detail** showing new idea
8. Options: Edit, delete, invite reviewers, rate (future)

### **User Journey: Explore & Join Community**
1. From Feed → Taps **Communities** tab
2. **Communities List** shows all communities
3. Taps community → **Community Detail**
4. Sees community's ideas + members
5. Taps "Join" → Request sent
6. (Future) Admin approves → User becomes member
7. Can now create ideas in this community

### **User Journey: View Profile**
1. Taps **Profile** tab
2. **Profile Dashboard** shows stats, recent ideas, communities
3. Taps "Edit Profile" → **Edit Profile** modal
4. Updates info → POST /api/users/me
5. Taps "Settings" → **Settings** screen
6. Can logout, change preferences (future), delete account

### **Error Handling**
- Any API error → **Error State** overlay/screen
- Network down → **Network Error** screen with retry
- Empty results → **Empty State** variants encouraging action
- Validation error → Inline error messages on forms

---

This architecture ensures:
- ✅ **Modularity**: Each screen is self-contained
- ✅ **Reusability**: Components used across multiple screens
- ✅ **Scalability**: Easy to add new features (ratings, comments, messaging)
- ✅ **Maintainability**: Clear separation of concerns (screens, controllers, services)
- ✅ **Performance**: Local caching, pagination, lazy loading
- ✅ **UX**: Consistent design, error handling, loading states
