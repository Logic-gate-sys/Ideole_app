# Ideole API Endpoints Specification

**Tech Stack**: Node/Express, Zod, Jose JWT, Helmet, Morgan, Multer

---

# ✅ SECTION A: FULLY IMPLEMENTED FEATURES

These features have complete route definitions, controllers, services, and schemas implemented.

---

## 1. Authentication (4 routes)

POST /api/auth/register - Register new user
POST /api/auth/login - Login user
POST /api/auth/refresh - Refresh JWT token
POST /api/auth/logout - Logout user

## 2. User Management (6 routes)

GET /api/users/:userId - Get user by ID (public profile)
GET /api/users/me - Get current user profile (authenticated)
PUT /api/users/me - Update user profile (authenticated)
PATCH /api/users/me/active - Update last active timestamp (authenticated)
GET /api/users/me/memberships - Get user's community memberships (authenticated)
GET /api/users/me/ideas - Get user's ideas (authenticated)

## 3. Organisation Management (5 routes)

POST /api/organisations - Create organisation (authenticated)
GET /api/organisations - List user's organisations (authenticated)
GET /api/organisations/:orgId - Get organisation by ID
PUT /api/organisations/:orgId - Update organisation (authenticated, owner)
DELETE /api/organisations/:orgId - Delete organisation (authenticated, owner)

## 4. Community Management (7 routes)

POST /api/organisations/:orgId/communities - Create community (authenticated, org owner)
GET /api/organisations/:orgId/communities - List communities in organisation
GET /api/communities/:communityId - Get community by ID
PUT /api/communities/:communityId - Update community (authenticated, admin)
DELETE /api/communities/:communityId - Delete community (authenticated, admin)
PATCH /api/communities/:communityId/dormant - Mark community as dormant (admin/cron)
DELETE /api/communities/:communityId/dissolve - Dissolve dormant community (cron)

## 5. Membership Management (6 routes)

POST /api/communities/:communityId/memberships/request - Request to join community (authenticated)
GET /api/communities/:communityId/memberships/pending - List pending requests (authenticated, admin)
PATCH /api/communities/:communityId/memberships/:membershipId/approve - Approve join request (authenticated, admin)
PATCH /api/communities/:communityId/memberships/:membershipId/reject - Reject join request (authenticated, admin)
DELETE /api/communities/:communityId/memberships/:membershipId - Remove member (authenticated, admin)

## 6. Idea Management (5 routes)

POST /api/ideas - Create idea (authenticated, with optional criteria)
GET /api/ideas - Get all ideas feed (optional auth, respects visibility)
GET /api/ideas/:ideaId - Get single idea (optional auth, respects visibility)
PUT /api/ideas/:ideaId - Update idea (authenticated, owner only)
DELETE /api/ideas/:ideaId - Delete idea (authenticated, owner only)

## 7. Evaluation Criteria (4 routes)

GET /api/ideas/:ideaId/criteria - Get idea's evaluation criteria (optional auth)
POST /api/ideas/:ideaId/criteria - Create criteria (authenticated, owner only, INCEPTION stage)
PUT /api/ideas/:ideaId/criteria/:criteriaId - Update criteria (authenticated, owner only, INCEPTION stage)
DELETE /api/ideas/:ideaId/criteria/:criteriaId - Delete criteria (authenticated, owner only, INCEPTION stage)

---

# ❌ SECTION B: NOT YET IMPLEMENTED FEATURES

These features are planned but do not yet have routes, controllers, services, or schemas implemented.

---

## 8. Rating System (5 routes)

POST /api/ideas/:ideaId/ratings - Submit rating (authenticated, not self)
GET /api/ideas/:ideaId/ratings - Get all ratings for idea
GET /api/ideas/:ideaId/ratings/stats - Get rating statistics (average scores, overall)
PUT /api/ideas/:ideaId/ratings/:ratingId - Update rating (authenticated, author only)
DELETE /api/ideas/:ideaId/ratings/:ratingId - Delete rating (authenticated, author/owner only)

## 9. Comments (4 routes)

POST /api/ideas/:ideaId/comments - Post comment (authenticated)
GET /api/ideas/:ideaId/comments - Get comments for idea (queryable: sortBy, limit, offset)
PUT /api/ideas/:ideaId/comments/:commentId - Update comment (authenticated, author only)
DELETE /api/ideas/:ideaId/comments/:commentId - Delete comment (authenticated, author/owner only)

## 10. Invitations (5 routes)

POST /api/ideas/:ideaId/invites - Invite user to review (authenticated, owner only)
GET /api/users/me/invites - Get pending invites (authenticated)
GET /api/ideas/:ideaId/invites - Get invites for idea (authenticated, owner only)
PATCH /api/invites/:inviteId/accept - Accept invitation (authenticated)
PATCH /api/invites/:inviteId/decline - Decline invitation (authenticated)

## 11. Conversations & Messaging (6 routes)

POST /api/conversations - Create conversation (authenticated, IDEA|COMMUNITY|DIRECT)
GET /api/conversations - List user's conversations (authenticated)
GET /api/conversations/:conversationId - Get conversation with messages (paginated)
POST /api/conversations/:conversationId/messages - Send message (authenticated)
GET /api/conversations/:conversationId/messages - Get messages (paginated)
PUT /api/conversations/:conversationId/messages/:messageId - Update message (authenticated, sender only, within 30min)
DELETE /api/conversations/:conversationId/messages/:messageId - Delete message (authenticated, sender/owner only)

## 12. Admin & Cron Jobs (3 routes)

POST /api/admin/cron/check-dormancy - Check communities for dormancy (admin)
POST /api/admin/cron/dissolve-dormant - Dissolve dormant communities (admin/cron)
POST /api/admin/cron/update-idea-stages - Auto-promote ideas based on ratings (admin/cron)

---

## Authentication Middleware

### authenticate

- Requires valid JWT token in `Authorization: Bearer {token}` header
- Validates token via Jose library
- Attaches user object to `req.user` with id, email, role
- Returns 401 if token missing, invalid, or user not found

### optionalAuth

- Attempts authentication but doesn't fail if token missing/invalid
- If valid token present: attaches user to `req.user`
- If no token or invalid token: allows request to proceed with `req.user = undefined`
- Used for endpoints that support both public and authenticated access
- Enables conditional visibility: PUBLIC ideas accessible to all, PROTECTED/PRIVATE ideas visible based on user context

### authorise(permission)

- Enforces role-based access control (RBAC)
- Requires authenticated user (used after `authenticate`)
- Checks ownership/permissions on specific resources
- Returns 403 if user lacks required permission
- Examples:
  - `idea:create` - Can create ideas
  - `idea:update:own` - Can update own ideas
  - `idea:delete:own` - Can delete own ideas
  - `criteria:create:own` - Can create criteria on own ideas
  - `criteria:update:own` - Can update criteria on own ideas
  - `criteria:delete:own` - Can delete criteria on own ideas

All endpoints marked with `Headers: Authorization: Bearer {token}` require authenticate + authorise.
All endpoints marked with `Headers: Optional Authorization: Bearer {token}` use optionalAuth (allow public access).

---

## Error Handling

Standard response format:

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

Common error codes:

- `VALIDATION_ERROR` - Zod validation failed
- `UNAUTHORIZED` - Missing/invalid token
- `FORBIDDEN` - User lacks permission
- `NOT_FOUND` - Resource doesn't exist
- `CONFLICT` - Duplicate resource
- `INTERNAL_ERROR` - Server error

---

## Implementation Priority (Deprecated - See "Implementation Status" below)

This organization has been reorganized into SECTION A (Fully Implemented) and SECTION B (Not Yet Implemented).

---

## Implementation Status (April 4, 2026)

### ✅ Completed

**Phase 1 - Core**:

- ✅ Auth (register, login, refresh, logout)
- ✅ User (profile, update)
- ✅ Ideas (CRUD routes with proper auth)
- ✅ Evaluation Criteria (CRUD routes)
- ✅ Optional Authentication Middleware (`optionalAuth`)

**Phase 2 - Community**:

- ✅ Organisation (CRUD routes with RBAC)
- ✅ Community (CRUD routes with RBAC)
- ✅ Membership (request/approve/reject/remove routes)

**Notes on Implementation**:

1. **optionalAuth Middleware**:
   - Newly implemented in `src/middlewares/auth.middleware.ts`
   - Allows GET endpoints for ideas/criteria to be publicly accessible
   - Authenticated users get filtered results based on visibility (PUBLIC/PROTECTED/PRIVATE)
   - Unauthenticated users see only PUBLIC items

2. **Idea Routes** (`src/routes/idea.route.ts`):
   - GET endpoints use `optionalAuth` for public access
   - POST/PUT/DELETE endpoints require `authenticate` + `authorise` with ownership checks
   - Supports visibility-based access control (PUBLIC, PROTECTED, PRIVATE)

3. **Auth/RBAC Integration**:
   - All write operations use `authorise()` middleware
   - Permission strings: `idea:create`, `idea:update:own`, `idea:delete:own`, etc.
   - Ownership determined by comparing `req.user.id` with resource `ownerId`

---

## Implementation Status (April 6, 2026)

### 📊 OVERALL PROGRESS

**Backend**: 7/12 features complete (58%) | **Frontend**: 4/9 features complete (44%)

---

### ✅ SECTION A: FULLY IMPLEMENTED (7 Backend Features)

| # | Feature | Routes | Status | Frontend | Notes |
|---|---------|--------|--------|----------|-------|
| 1 | **Authentication** | 4 | ✅ Complete | ✅ Sign In/Up | Email/password, JWT tokens, refresh flow |
| 2 | **User Management** | 6 | ✅ Complete | ❌ Partial | Profile fetching works, edit profile UI needed |
| 3 | **Organisation Mgmt** | 5 | ✅ Complete | ✅ Create, List, Detail | Full CRUD with ownership checks |
| 4 | **Community Mgmt** | 5 | ✅ Complete | ✅ Create, List, Detail | Full CRUD with ownership checks |
| 5 | **Membership Mgmt** | 6 | ✅ Complete | ❌ Skeleton | Join/request flows API ready |
| 6 | **Idea Mgmt** | 5 | ✅ Complete | ✅ Create, List, Detail | CRUD + visibility control |
| 7 | **Evaluation Criteria** | 4 | ✅ Complete | ⚠️ Basic | Criteria display, editing not implemented |

**Key Backend Features**:
- ✅ `optionalAuth` middleware for public/authenticated fallback
- ✅ Idea visibility tiers: PUBLIC → PROTECTED → PRIVATE
- ✅ RBAC with ownership checks via `authorise()` middleware
- ✅ Zod input validation on all POST/PUT endpoints
- ✅ JWT + refresh token architecture
- ✅ PostgreSQL/Prisma ORM integration

**Frontend Services Ready** ✅:
- `ApiService` (HTTP client with auto platform detection: localhost for web, 10.0.2.2 for emulator)
- `AuthService` (login, register, logout, token refresh)
- `IdeaService` (CRUD, fetch ideas, get by ID)
- `CommunityService` (CRUD, list communities)
- `OrganisationService` (CRUD, list organisations)
- `StorageService` (JWT token/user persistence via SharedPreferences)

---

### ❌ SECTION B: NOT YET IMPLEMENTED (5 Backend Features)

| # | Feature | Routes | Complexity | Impact | Frontend |
|---|---------|--------|-----------|--------|----------|
| 8 | **Rating System** | 5 | Medium | HIGH | Enables idea evaluation & ranking |
| 9 | **Comments** | 4 | Medium | HIGH | Enables idea discussion & feedback |
| 10 | **Invitations** | 5 | Medium | MEDIUM | Enables reviewer assignment |
| 11 | **Messaging** | 6 | Hard | MEDIUM | Enables async communication |
| 12 | **Cron Jobs** | 3 | Hard | LOW | Enables auto-promotion & cleanup |

**What's Needed**:
- Database models for ratings, comments, invitations, messages (Prisma)
- Controllers & services for each feature
- Input validation schemas (Zod)
- RBAC for partial updates (authors can edit their comments, etc.)
- WebSocket setup for real-time messaging (optional)

---

### 🎨 FRONTEND IMPLEMENTATION STATUS

#### ✅ FULLY IMPLEMENTED SCREENS

| Screen | Location | Status | Features |
|--------|----------|--------|----------|
| **Sign In** | `auth/screens/sign_in_screen.dart` | ✅ Complete | Email/password login, error handling, forgot password link |
| **Sign Up** | `auth/screens/signup_screen.dart` | ✅ Complete | Full registration form with password strength validation |
| **Idea Feed** | `feed/screens/idea_feed_screen.dart` | ✅ Complete | Paginated idea list, pull-to-refresh, create button |
| **Create Idea** | `idea/screens/create_idea_screen.dart` | ✅ Complete | Title/description form, visibility toggle, error handling |
| **Idea Detail** | `idea/screens/idea_detail_screen.dart` | ✅ Complete | Full idea view, evaluation criteria display |
| **Communities List** | `communities/screens/communities_screen.dart` | ✅ Complete | Browse all communities, search/filter |
| **Community Detail** | `communities/screens/community_detail_screen.dart` | ✅ Complete | Community info, stats, member/idea lists |

#### ❌ NOT IMPLEMENTED SCREENS

| Screen | Location | Status | Why Needed |
|--------|----------|--------|-----------|
| **Profile Dashboard** | `profile/screens/profile_screen.dart` | ❌ Not Started | Show user info, ideas, communities, stats |
| **Edit Profile** | `profile/screens/edit_profile_modal.dart` | ❌ Not Started | Allow users to update name, bio, avatar |
| **Settings** | `profile/screens/settings_screen.dart` | ❌ Not Started | Logout, preferences, app settings |
| **Idea Rating Modal** | `idea/screens/rate_idea_modal.dart` | ❌ Not Started | Score ideas (requires backend rating system) |
| **Comments Section** | `idea/screens/comments_section.dart` | ❌ Not Started | Post/view comments on ideas |
| **Invite Reviewers** | `idea/screens/invite_reviewers_modal.dart` | ❌ Not Started | Assign reviewers to ideas |
| **Messages/Inbox** | `messages/screens/messages_screen.dart` | ❌ Not Started | View conversations & messages |

#### ✅ IMPLEMENTED CONTROLLERS

| Controller | Location | Status | Handles |
|------------|----------|--------|---------|
| AuthController | `auth/controllers/` | ✅ Complete | Login, register, logout, user state |
| IdeaController | `feed/controllers/` | ✅ Complete | Fetch ideas, pagination, refresh |
| CreateIdeaController | `idea/controllers/` | ✅ Complete | Form validation, idea creation |
| CommunityController | `communities/controllers/` | ✅ Complete | Fetch communities, list, detail |
| OrganisationController | `organisations/controllers/` | ✅ Complete | Fetch organisations, list, detail |

#### ❌ NOT IMPLEMENTED CONTROLLERS

| Controller | Purpose |
|------------|---------|
| RatingController | Manage idea ratings submission & display |
| CommentController | Manage comment CRUD |
| InvitationController | Manage reviewer invitations |
| MessagingController | Manage conversations & messages |
| UserController | Manage profile updates, user data |

---

### 🎯 RECOMMENDED NEXT STEPS

#### Phase 1: Profile & Settings (2-3 days)
- [ ] Implement ProfileController
- [ ] Build Profile Dashboard screen (display user, ideas, communities)
- [ ] Build Edit Profile modal/screen
- [ ] Build Settings screen with logout
- **Impact**: Complete 4 core UI screens, improve UX

#### Phase 2: Rating System (3-4 days)
- [ ] Add `IdeaRating` model to Prisma schema
- [ ] Implement rating routes/controller/service in backend
- [ ] Build RatingController in frontend
- [ ] Create Rate Idea modal UI
- **Impact**: Enable idea quality feedback

#### Phase 3: Comments (3-4 days)
- [ ] Add `IdeaComment` model to Prisma schema
- [ ] Implement comment routes/controller/service
- [ ] Build CommentController in frontend
- [ ] Create comments section on Idea Detail screen
- **Impact**: Enable collaborative discussion

#### Backlog (Lower Priority)
- Invitations system (medium complexity)
- Messaging system (high complexity, uses WebSocket)
- Cron jobs (infrastructure complexity)

---
