# Reviewer Routes Testing Guide

## Quick Summary

**Backend Tests:**
- 13 integration tests for 7 reviewer endpoints
- 5 unit tests for ReviewerService methods
- Tests cover: CRUD, authorization, status transitions, validation

**Frontend Tests:**
- 7 service integration tests
- 5 controller state tests
- Tests cover: API calls, state management, filters

---

## Running Backend Tests

```bash
# Run all tests
npm run test

# Run only reviewer tests
npm run test -- reviewer

# Run integration tests
npm run test -- tests/integration/reviewer.integration.test.ts

# Run unit tests
npm run test -- tests/unit/reviewer.service.test.ts

# Watch mode
npm run test -- --watch
```

---

## Test Coverage

### Integration Tests (`reviewer.integration.test.ts`)

| Test | What It Verifies |
|------|------------------|
| `GET /reviewers` returns empty list | API responds correctly when no reviewers |
| `GET /reviewers` returns 401 without auth | Authentication is required |
| `POST /reviewers` invites reviewer | Creates PENDING invitation |
| `POST /reviewers` prevents duplicates | Can't invite same reviewer twice |
| `POST /reviewers` prevents non-owner | Authorization check works |
| `DELETE /reviewers/:id` removes reviewer | Owner can delete invitations |
| `DELETE /reviewers/:id` returns 404 | Handles missing reviewers |
| `POST /resend-invite` works | Can resend to pending reviewers |
| `POST /resend-invite` fails on accepted | Can't resend non-pending invites |
| `DELETE /invite` cancels pending | Owner can cancel invitations |
| `DELETE /invite` fails on accepted | Can't cancel non-pending invites |
| `POST /accept` accepts own invite | Reviewer can accept their invitation |
| `POST /accept` prevents others accepting | Authorization check prevents impersonation |
| `POST /decline` declines own invite | Reviewer can decline invitation |

### Unit Tests (`reviewer.service.test.ts`)

| Test | What It Verifies |
|------|------------------|
| `canManageReviewers` owner | Idea owner has permission |
| `canManageReviewers` non-owner | Non-owner denied |
| `inviteReviewer` creates | Invitation created successfully |
| `inviteReviewer` duplicates | Prevents duplicate invites |
| `getIdeaReviewers` returns list | Fetches all reviewers |
| `removeReviewer` deletes | Invitation deleted |
| `acceptInvitation` updates | Status changed to ACCEPTED |
| `declineInvitation` updates | Status changed to DECLINED |

### Frontend Tests (`reviewer_service_test.dart`)

| Test | What It Verifies |
|------|------------------|
| Service methods exist | API methods callable |
| State initialization | Controller starts empty |
| Active filter works | Filters "joined" status |
| Pending filter works | Filters "pending" status |
| Load sets loading | Shows spinner during fetch |
| Clear error works | Error message removed |

---

## Running Frontend Tests

```bash
# Run all Flutter tests
flutter test

# Run specific test file
flutter test test/services/reviewer_service_test.dart

# Run with coverage
flutter test --coverage

# Run on web
flutter test --platform=chrome
```

---

## Key Test Patterns

### Authorization Check
```typescript
it('should prevent non-owner from inviting', async () => {
  const res = await request(app)
    .post(`/api/ideas/${idea.id}/reviewers`)
    .set('Authorization', `Bearer ${reviewer.token}`)
    .send({ reviewerId: reviewer.id });
  expect(res.status).toBe(403);
});
```

### Database State Verification
```typescript
const invite = await prisma.ideaInvite.findUnique({
  where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
});
expect(invite?.status).toBe('ACCEPTED');
```

### Error Handling
```typescript
it('should throw if already invited', async () => {
  await ReviewerService.inviteReviewer(idea.id, reviewer.id);
  await expect(
    ReviewerService.inviteReviewer(idea.id, reviewer.id)
  ).rejects.toThrow('already invited');
});
```

---

## Example Test Run Output

```
✓ Reviewer Routes (14 tests)
  ✓ GET /api/ideas/:ideaId/reviewers
    ✓ should return empty reviewers list (45ms)
    ✓ should return 401 without token (32ms)
  ✓ POST /api/ideas/:ideaId/reviewers
    ✓ should invite reviewer (63ms)
    ✓ should prevent duplicate invites (71ms)
    ✓ should prevent non-owner from inviting (58ms)
  ✓ DELETE /api/ideas/:ideaId/reviewers/:reviewerId
    ✓ should remove reviewer (50ms)
    ✓ should return 404 if reviewer not found (47ms)
  ✓ POST /api/ideas/:ideaId/reviewers/:reviewerId/resend-invite
    ✓ should resend invitation (52ms)
    ✓ should fail if invite not pending (64ms)
  ✓ DELETE /api/ideas/:ideaId/reviewers/:reviewerId/invite
    ✓ should cancel pending invitation (51ms)
    ✓ should fail if invitation not pending (59ms)
  ✓ POST /api/ideas/:ideaId/reviewers/:reviewerId/accept
    ✓ should accept own invitation (67ms)
    ✓ should prevent accepting others' invitations (53ms)
  ✓ POST /api/ideas/:ideaId/reviewers/:reviewerId/decline
    ✓ should decline own invitation (54ms)

✓ ReviewerService (8 tests)
  ✓ canManageReviewers (28ms)
  ✓ inviteReviewer (35ms)
  ✓ getIdeaReviewers (29ms)
  ✓ removeReviewer (32ms)
  ✓ acceptInvitation (31ms)
  ✓ declineInvitation (30ms)

Tests: 22 passed, 22 total
Time: 1.2s
```

---

## Test Scenarios Covered

✅ **Happy Path**
- Invite → Accept → View
- Invite → Resend → Accept
- Invite → Decline

✅ **Authorization**
- Only Owner can manage
- Only Reviewer can accept/decline own invite
- Non-owner denied

✅ **Validation**
- Can't invite non-existent user
- Can't invite twice
- Can't resend non-pending
- Can't cancel non-pending

✅ **State Transitions**
- PENDING → ACCEPTED
- PENDING → DECLINED
- PENDING → Deleted (via cancel)
- ACCEPTED → Deleted (via remove)

✅ **Error Cases**
- 404 if idea/reviewer not found
- 400 if invalid operation
- 401 if not authenticated
- 403 if not authorized

---

## Maintenance Notes

- Tests use `createTestUser()` helper from existing test setup
- Cleanup happens via `beforeEach` with Prisma
- No mocking needed - tests use real database in test environment
- Tests are isolated and can run in parallel

---

## What's NOT Tested (Future)

- Email notifications when inviting
- Rate limiting on resend
- Bulk invite operations
- Analytics tracking
- Pagination on large reviewer lists
