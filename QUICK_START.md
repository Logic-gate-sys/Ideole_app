# Ideole Backend - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- Node.js (v16+)
- PostgreSQL database
- npm or yarn installed

### 1. Setup Database
```bash
# Configure .env with DATABASE_URL
echo "DATABASE_URL=postgresql://user:password@localhost:5432/ideole_db" > .env

# Run migrations
npx prisma migrate dev --name init

# Generate Prisma Client
npx prisma generate
```

### 2. Install Dependencies
```bash
cd backend
npm install
```

### 3. Run Tests (TDD Way!)
```bash
# First time - run all tests
npm run test

# Watch mode for development
npm run test:watch

# Check coverage
npm run test:coverage
```

### 4. Start Development Server
```bash
npm run dev
```

Visit: `http://localhost:3000`

---

## 📁 Project Structure at a Glance

```
src/
├── routes/ideole.route.ts          ← All API endpoints defined here
├── controllers/                     ← HTTP logic (extracts data, calls services)
│   ├── idea.controller.ts
│   ├── rating.controller.ts
│   ├── ideole-comment.controller.ts
│   └── ideole-invite.controller.ts
├── services/                        ← Business logic (well-tested!)
│   ├── idea.service.ts
│   ├── rating.service.ts
│   ├── comment.service.ts
│   ├── invite.service.ts
│   └── user.service.ts
├── schema/                          ← Request validation (Zod)
│   ├── idea.schema.ts
│   ├── rating.schema.ts
│   ├── invite.schema.ts
│   ├── comment.schema.ts
│   ├── user.schema.ts
│   └── types.d.ts
└── middlewares/
    └── validate.middleware.ts       ← Validates requests using schemas

tests/
├── unit/                            ← Test services in isolation
│   ├── idea.service.unit.test.ts
│   ├── rating.service.unit.test.ts
│   ├── comment.service.unit.test.ts
│   ├── invite.service.unit.test.ts
│   └── user.service.unit.test.ts
├── integration/                     ← Test full API flows
│   ├── idea.integration.test.ts
│   ├── rating.integration.test.ts
│   ├── comment.integration.test.ts
│   └── invite.integration.test.ts
└── helpers/
    └── test-helpers.ts              ← Factories for test data
```

---

## 🧪 Understanding the Test Structure

### Running Tests
```bash
npm run test                 # Run once
npm run test:watch         # Run in watch mode
npm run test:coverage      # With coverage report
```

### Test Files Organization

#### Unit Tests (Fast, Focused)
Located in: `tests/unit/`
- Test **service logic only**
- No HTTP involved
- Run in milliseconds
- 70+ tests total

Example:
```bash
# Create an idea without HTTP
idea = await IdeaService.createIdea({...})
expect(idea.title).toBe('...')
```

#### Integration Tests (Complete Flow)
Located in: `tests/integration/`
- Test **full HTTP request/response**
- Include validation & auth
- More realistic
- 28+ tests total

Example:
```bash
# Full POST request through Express
response = await request(app)
  .post('/api/ideole/ideas')
  .send({...})
expect(response.status).toBe(201)
```

---

## 💡 How to Add a New Feature (TDD Style)

### Example: Add ability to edit a comment

#### Step 1: Write the Test
```typescript
// In tests/unit/comment.service.unit.test.ts
describe('CommentService.updateComment', () => {
  it('should update comment content', async () => {
    const user = await TestHelpers.createUser();
    const idea = await TestHelpers.createIdea(user.id);
    const comment = await TestHelpers.createComment(idea.id, user.id);

    const result = await CommentService.updateComment(
      comment.id,
      { content: 'Updated!' },
      user.id
    );

    expect(result.content).toBe('Updated!');
  });

  it('should throw error if not comment creator', async () => {
    const user = await TestHelpers.createUser();
    const other = await TestHelpers.createUser();
    const idea = await TestHelpers.createIdea(user.id);
    const comment = await TestHelpers.createComment(idea.id, user.id);

    await expect(
      CommentService.updateComment(comment.id, { content: 'Hacked' }, other.id)
    ).rejects.toThrow('Only comment creator can edit');
  });
});
```

#### Step 2: Run Test (It Fails!)
```bash
npm run test -- comment.service.unit.test.ts
# FAIL - updateComment is not defined
```

#### Step 3: Write Minimal Implementation
```typescript
// In src/services/comment.service.ts
async updateComment(commentId: string, input: any, userId: string) {
  const comment = await prisma.ideaComment.findUnique({
    where: { id: commentId }
  });

  if (!comment) throw new Error('Comment not found');
  if (comment.userId !== userId) {
    throw new Error('Only comment creator can edit');
  }

  return await prisma.ideaComment.update({
    where: { id: commentId },
    data: { content: input.content },
    include: { user: { select: { id: true, name: true } } }
  });
}
```

#### Step 4: Run Test (It Passes!)
```bash
npm run test -- comment.service.unit.test.ts
# PASS ✓
```

#### Step 5: Add Schema Validation
```typescript
// In src/schema/comment.schema.ts
export const updateCommentSchema = z.object({
  body: z.object({
    content: z.string()
      .min(1, 'Comment cannot be empty')
      .max(1000, 'Comment too long'),
  }),
});
```

#### Step 6: Add Controller Method
```typescript
// In src/controllers/ideole-comment.controller.ts
async updateComment(req: Request, res: Response) {
  try {
    const userId = (req as any).user?.id;
    const { commentId, ideaId } = req.params;
    const { content } = req.body;

    const comment = await CommentService.updateComment(
      commentId,
      { content },
      userId
    );

    return res.status(200).json({ success: true, data: comment });
  } catch (error: any) {
    if (error.message === 'Comment not found') {
      return res.status(404).json({ success: false, error: 'Not found' });
    }
    if (error.message.includes('creator')) {
      return res.status(403).json({ success: false, error: error.message });
    }
    return res.status(500).json({ success: false, error: error.message });
  }
}
```

#### Step 7: Add Route
```typescript
// In src/routes/ideole.route.ts
ideaRouter.patch(
  '/ideas/:ideaId/comments/:commentId',
  validateParams(commentIdParamSchema),
  validateBody(updateCommentSchema),
  CommentController.updateComment
);
```

#### Step 8: Write Integration Test
```typescript
// In tests/integration/comment.integration.test.ts
it('should update comment via HTTP', async () => {
  const creator = await TestHelpers.createUser();
  const idea = await TestHelpers.createIdea(creator.id);
  const comment = await TestHelpers.createComment(idea.id, creator.id);

  const response = await request(app)
    .patch(`/api/ideole/ideas/${idea.id}/comments/${comment.id}`)
    .set('Authorization', `Bearer ${creator.id}`)
    .send({ content: 'Updated content' });

  expect(response.status).toBe(200);
  expect(response.body.data.content).toBe('Updated content');
});
```

#### Step 9: Run All Tests
```bash
npm run test
# Everything passes! ✓
```

---

## 📚 Key Endpoints Reference

### Ideas
```
POST   /api/ideole/ideas              Create idea
GET    /api/ideole/ideas              List visible ideas
GET    /api/ideole/ideas/:ideaId      Get idea details
PATCH  /api/ideole/ideas/:ideaId      Update idea
PATCH  /api/ideole/ideas/:ideaId/public  Toggle public
```

### Ratings
```
POST   /api/ideole/ideas/:ideaId/rate      Submit rating
GET    /api/ideole/ideas/:ideaId/stats     Get average ratings
GET    /api/ideole/ideas/:ideaId/ratings   Get all ratings
```

### Invites
```
POST   /api/ideole/ideas/:ideaId/invite    Send invite
PATCH  /api/ideole/ideas/:ideaId/invite/:inviteId Accept
GET    /api/ideole/ideas/:ideaId/invites   List invites
GET    /api/ideole/user/invites            My invites
GET    /api/ideole/user/invites/pending    My pending
```

### Comments
```
POST   /api/ideole/ideas/:ideaId/comments           Create
GET    /api/ideole/ideas/:ideaId/comments           List
DELETE /api/ideole/ideas/:ideaId/comments/:commentId Delete
```

---

## 🔍 Useful Commands

```bash
# Development
npm run dev                    # Start server with auto-reload

# Testing
npm run test                   # Run all tests
npm run test:watch           # Save to auto-retest
npm run test:coverage        # See coverage report

# Database
npx prisma studio           # GUI for database
npx prisma migrate dev       # Create new migration
npx prisma db reset         # Reset database (dev only!)

# Build
npm run build                # Compile TypeScript
npm start                    # Run compiled JS
```

---

## 📖 Further Reading

- **TDD Guide**: `TDD_GUIDE.md` - Complete testing philosophy
- **Implementation Details**: `IMPLEMENTATION_SUMMARY.md` - What was built
- **Prisma Schema**: `prisma/schema.prisma` - Database models
- **Zod Docs**: https://zod.dev/ - Validation library

---

## ❓ Common Questions

**Q: Where do I add new business logic?**
A: In `src/services/` - Write test first!

**Q: Where do I add validations?**
A: In `src/schema/` - Use Zod schemas

**Q: How do I test my changes?**
A: Write test first, then implement. Run `npm run test:watch`

**Q: Do I need to restart the server when testing?**
A: No! Tests use test database and don't affect running server.

**Q: How do I add authentication?**
A: Implement auth middleware in `src/middlewares/` - tests show how

---

## ✅ Checklist for Your First Feature

- [ ] Write unit test first
- [ ] Run test (it fails)
- [ ] Write service implementation
- [ ] Run test (it passes)
- [ ] Add Zod schema for validation
- [ ] Add controller method
- [ ] Add route definition
- [ ] Write integration test
- [ ] Run full test suite
- [ ] Test manually with API client (Postman/Insomnia)

---

## 🎯 Ready to Code?

1. Pick a feature to add
2. Follow the 9-step guide above
3. Write tests first!
4. Run `npm run test:watch` while coding
5. Feel confident with full coverage

**Happy testing! 🚀**
