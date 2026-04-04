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

## Implementation Status (April 4, 2026)

### SECTION A: ✅ FULLY IMPLEMENTED (7 Features)

1. **Authentication** - register, login, refresh, logout
2. **User Management** - profile, update profile, track active timestamps  
3. **Organisation Management** - create, read, update, delete organisations
4. **Community Management** - create, read, update, delete communities
5. **Membership Management** - request, approve, reject, remove memberships
6. **Idea Management** - create, read, update, delete ideas with visibility control
7. **Evaluation Criteria** - create, read, update, delete custom evaluation criteria

**Key Features Implemented**:

- `optionalAuth` Middleware: Allows public access to GET endpoints with authenticated fallback
- Idea Visibility: PUBLIC (everyone), PROTECTED (community members), PRIVATE (owner only)
- RBAC: Role-based access control with ownership checks via `authorise()` middleware
- Zod Validation: All POST/PUT endpoints validated via Zod schemas

### SECTION B: ❌ NOT YET IMPLEMENTED (5 Features)

1. **Rating System** - submit scores, calculate averages, get stats
2. **Comments** - post, read, update, delete critiques/discussions
3. **Invitations** - invite reviewers, accept, decline invites
4. **Conversations & Messaging** - DIRECT/IDEA/COMMUNITY contexts, send/receive messages
5. **Cron Jobs** - dormancy checks, community dissolution, auto-stage promotion

**What's Needed**:

- Routes, controllers, services for rating calculation & stage progression
- Routes, controllers, services for comment CRUD
- Routes, controllers, services for invitation system
- Routes, controllers, services for messaging system
- Background job handlers for scheduled tasks

---
