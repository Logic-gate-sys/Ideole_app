# Service & Controller Object Pattern

This guide documents the standardized patterns used in services and controllers for consistency and maintainability.

## Core Principles

1. **Explicit Type Definitions** - All service functions have explicit return types
2. **Consistent Response Objects** - Services return rich, structured objects
3. **Layered Validation** - Schemas → Controllers → Services
4. **Reusable Utilities** - Response wrapping and error handling are centralized
5. **Clean Separation** - Services contain business logic, controllers handle HTTP

## Service Layer Pattern

### 1. Define Response Type Interface

Define the shape of data your service returns:

```typescript
export interface MyFeatureResponse {
  data: {
    id: string;
    name: string;
    // ... other properties
  };
  metadata?: {
    created: Date;
    status: string;
  };
}
```

### 2. Implement Service Functions with Explicit Types

```typescript
export async function createMyFeature(
  input: CreateMyFeatureInput,
): Promise<MyFeatureResponse> {
  // Validation
  if (existing) {
    throw new Error('Entity already exists');
  }

  // Business logic
  const entity = await prisma.myFeature.create({
    data: { /* ... */ }
  });

  // Build response object
  return {
    data: {
      id: entity.id,
      name: entity.name,
    },
    metadata: {
      created: entity.createdAt,
      status: entity.status,
    }
  };
}
```

### 3. Error Handling in Services

- Throw `Error` with descriptive messages
- Don't catch errors - let controllers handle them
- Use consistent error messages

```typescript
if (!user) {
  throw new Error('User not found');
}

if (!hasPermission) {
  throw new Error('Access denied');
}
```

## Controller Layer Pattern

### 1. Import Utilities

```typescript
import type { Request, Response } from 'express';
import { sendSuccess, sendError, handleControllerError } from '../lib/response.ts';
import { handleControllerError } from '../lib/error.ts';
```

### 2. Implement Handlers with Type Annotations

```typescript
export async function createMyFeature(
  req: Request,
  res: Response,
): Promise<Response> {
  try {
    // Validate input
    const input = createMyFeatureSchema.parse(req.body);

    // Call service
    const result = await createMyFeature(input);

    // Return success
    return sendSuccess(res, result, 201);
  } catch (error) {
    // Handle errors
    return handleControllerError(error, res);
  }
}
```

### 3. Response Utilities

**Success Response:**
```typescript
sendSuccess(res, data, statusCode?)
// Returns: { success: true, data }
```

**Error Response:**
```typescript
sendError(res, errorMessage, statusCode?, details?)
// Returns: { success: false, error, details? }
```

**Logout Response:**
```typescript
sendLogout(res)
// Returns: { success: true, message: 'Logged out successfully' }
```

### 4. Error Handling

`handleControllerError()` automatically detects error types:
- **ZodError** → 400 with validation details
- **Generic Error** → 400 with error message

```typescript
return handleControllerError(error, res);
```

## Example: Complete Feature Implementation

### Schema (`src/schema/comment.schema.ts`)

```typescript
import { z } from 'zod';

export const createCommentSchema = z.object({
  ideaId: z.string().uuid(),
  content: z.string().min(1).max(500),
});

export type CreateCommentInput = z.infer<typeof createCommentSchema>;
```

### Service (`src/services/comment.service.ts`)

```typescript
export interface CommentResponse {
  id: string;
  content: string;
  authorId: string;
  ideaId: string;
  createdAt: Date;
}

export async function createComment(
  input: CreateCommentInput,
): Promise<CommentResponse> {
  const comment = await prisma.comment.create({
    data: {
      content: input.content,
      ideaId: input.ideaId,
      authorId: req.user.id, // From context
    },
  });

  return {
    id: comment.id,
    content: comment.content,
    authorId: comment.authorId,
    ideaId: comment.ideaId,
    createdAt: comment.createdAt,
  };
}
```

### Controller (`src/controllers/comment.controller.ts`)

```typescript
export async function createComment(
  req: Request,
  res: Response,
): Promise<Response> {
  try {
    const input = createCommentSchema.parse(req.body);
    const result = await commentService.createComment(input);
    return sendSuccess(res, result, 201);
  } catch (error) {
    return handleControllerError(error, res);
  }
}
```

## Key Characteristics

| Aspect | Pattern |
|--------|---------|
| **Service return types** | Explicit interfaces, always Promise-wrapped |
| **Error handling** | Throw Error in services, catch in controllers |
| **Response wrapper** | Use `sendSuccess()`, `sendError()`, `sendLogout()` |
| **Field exposure** | Only safe, necessary fields in responses |
| **Type inference** | From Zod schemas at validation layer |
| **Consistency** | All services follow same return structure |

## Benefits

✅ **DRY** - No repeated error handling or response wrapping  
✅ **Type-safe** - Explicit return types prevent bugs  
✅ **Maintainable** - Consistent patterns across all features  
✅ **Testable** - Clear service contracts, easy to mock  
✅ **Scalable** - Easy to add new services/controllers following same pattern
