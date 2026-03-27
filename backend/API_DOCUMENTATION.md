# Ideole Backend API Documentation

## Overview

Ideole is a collaborative idea management platform that enables users to create, share, rate, and receive feedback on ideas. The backend provides a RESTful API with comprehensive features for idea management, peer reviews, invitations, and community engagement.

### Key Features

- **Idea Management**: Create, read, update, and manage ideas with different visibility levels
- **Visibility Control**: Share ideas as PRIVATE, COMMUNITY, or PUBLIC
- **Peer Reviews**: Submit structured ratings on originality, feasibility, and impact
- **Invitation System**: Invite specific reviewers to evaluate ideas
- **Comments & Feedback**: Enable detailed critiques and discussions on ideas
- **Access Control**: Permission-based access to ideas and operations

---

## Architecture

### Technology Stack

- **Framework**: Express.js v5.2.1
- **Language**: TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Validation**: Zod v4.3.6
- **Testing**: Vitest v4.0.18 with 91 comprehensive tests

### Project Structure

```
backend/
├── src/
│   ├── controllers/       # Request handlers
│   ├── services/          # Business logic layer
│   ├── routes/            # API endpoints (modular)
│   ├── schema/            # Zod validation schemas
│   ├── middlewares/       # Express middlewares
│   ├── lib/               # Utilities (Prisma, Socket.io)
│   ├── app.ts             # Express app setup
│   └── index.ts           # Server entry point
├── tests/                 # Unit & integration tests
├── prisma/
│   └── schema.prisma      # Database schema
└── vitest.config.ts       # Test configuration
```

---

## Authentication

All endpoints require Bearer token authentication via the `Authorization` header.

### Header Format

```
Authorization: Bearer {userId}
```

### Example

```bash
curl -X GET http://localhost:3000/api/ideole/ideas \
  -H "Authorization: Bearer 550e8400-e29b-41d4-a716-446655440000"
```

---

## Base URL

```
http://localhost:3000/api/ideole
```

---

## API Endpoints

### 1. Ideas Management

#### 1.1 Create Idea

**POST** `/ideas`

Create a new idea with specified visibility level.

**Request Body**

```json
{
  "title": "AI-Powered Task Manager",
  "problemText": "Users struggle to organize tasks across multiple platforms and tools",
  "solutionText": "Build a unified AI-powered task management platform with smart categorization",
  "category": "Productivity",
  "visibility": "PRIVATE"
}
```

**Request Validation**

- `title`: String, 5-200 characters (required)
- `problemText`: String, 10-2000 characters (required)
- `solutionText`: String, 10-2000 characters (required)
- `category`: String, 2-50 characters (required)
- `visibility`: Enum - `PRIVATE` | `COMMUNITY` | `PUBLIC` (default: `PRIVATE`)

**Response** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "AI-Powered Task Manager",
    "problemText": "Users struggle to organize tasks across multiple platforms",
    "solutionText": "Build a unified AI-powered task management platform",
    "category": "Productivity",
    "visibility": "PRIVATE",
    "isPublic": false,
    "creatorId": "user-id-123",
    "createdAt": "2026-03-27T15:26:00Z",
    "updatedAt": "2026-03-27T15:26:00Z"
  }
}
```

**Error Responses**

- `400 Bad Request`: Invalid request body
- `401 Unauthorized`: Missing or invalid authorization
- `500 Internal Server Error`: Server error

---

#### 1.2 Get Visible Ideas

**GET** `/ideas`

Retrieve paginated list of visible ideas (public, user's own, and invited ideas).

**Query Parameters**

- `page`: Integer, minimum 1 (default: 1)
- `limit`: Integer, minimum 1 (default: 10)
- `visibility`: Enum - `PRIVATE` | `COMMUNITY` | `PUBLIC` (optional)

**Example Request**

```
GET /ideas?page=1&limit=10&visibility=PUBLIC
Authorization: Bearer {userId}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "ideas": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "title": "AI-Powered Task Manager",
        "category": "Productivity",
        "visibility": "PUBLIC",
        "isPublic": true,
        "creatorId": "creator-id",
        "createdAt": "2026-03-27T15:26:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 42
    }
  }
}
```

**Error Responses**

- `400 Bad Request`: Invalid query parameters
- `401 Unauthorized`: Missing authorization
- `500 Internal Server Error`: Server error

---

#### 1.3 Get User's Own Ideas

**GET** `/user/ideas`

Retrieve all ideas created by the authenticated user.

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "ideas": [
      {
        "id": "idea-uuid",
        "title": "My Idea Title",
        "category": "Tech",
        "visibility": "PRIVATE",
        "createdAt": "2026-03-27T15:26:00Z"
      }
    ]
  }
}
```

---

#### 1.4 Get Idea Details

**GET** `/ideas/:ideaId`

Retrieve complete idea details with all relations (creator, ratings, comments).

**Path Parameters**

- `ideaId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "AI-Powered Task Manager",
    "problemText": "User struggle description",
    "solutionText": "Solution description",
    "category": "Productivity",
    "visibility": "PUBLIC",
    "isPublic": true,
    "creatorId": "creator-uuid",
    "creator": {
      "id": "creator-uuid",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "ratings": [
      {
        "id": "rating-uuid",
        "originality": 8,
        "feasibility": 7,
        "impact": 9,
        "reviewer": {
          "id": "reviewer-uuid",
          "name": "Jane Smith"
        }
      }
    ],
    "comments": [
      {
        "id": "comment-uuid",
        "content": "Great idea!",
        "userId": "commenter-uuid",
        "createdAt": "2026-03-27T16:00:00Z"
      }
    ],
    "createdAt": "2026-03-27T15:26:00Z",
    "updatedAt": "2026-03-27T15:26:00Z"
  }
}
```

**Error Responses**

- `404 Not Found`: Idea does not exist
- `401 Unauthorized`: Access denied

---

#### 1.5 Update Idea

**PATCH** `/ideas/:ideaId`

Update an idea (creator only). All fields are optional.

**Path Parameters**

- `ideaId`: UUID string (required)

**Request Body** (all optional)

```json
{
  "title": "Updated Title",
  "problemText": "Updated problem description",
  "solutionText": "Updated solution description",
  "category": "Technology",
  "visibility": "PUBLIC"
}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "idea-uuid",
    "title": "Updated Title",
    "category": "Technology",
    "visibility": "PUBLIC",
    "updatedAt": "2026-03-27T16:00:00Z"
  }
}
```

**Error Responses**

- `403 Forbidden`: User is not the creator
- `404 Not Found`: Idea does not exist
- `500 Internal Server Error`: Update failed

---

#### 1.6 Toggle Idea Visibility

**PATCH** `/ideas/:ideaId/public`

Toggle whether an idea is public (creator only).

**Path Parameters**

- `ideaId`: UUID string (required)

**Request Body**

```json
{
  "isPublic": true
}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "idea-uuid",
    "isPublic": true,
    "visibility": "PUBLIC",
    "updatedAt": "2026-03-27T16:00:00Z"
  }
}
```

---

### 2. Ratings

#### 2.1 Create Rating

**POST** `/ideas/:ideaId/rate`

Submit a structured rating for an idea. Rater must be invited or idea must be public.

**Path Parameters**

- `ideaId`: UUID string (required)

**Request Body**

```json
{
  "originality": 8,
  "feasibility": 7,
  "impact": 9
}
```

**Field Constraints**

- `originality`: Integer, 1-10 (required)
- `feasibility`: Integer, 1-10 (required)
- `impact`: Integer, 1-10 (required)

**Response** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "rating-uuid",
    "ideaId": "idea-uuid",
    "reviewerId": "user-uuid",
    "originality": 8,
    "feasibility": 7,
    "impact": 9,
    "createdAt": "2026-03-27T16:00:00Z"
  }
}
```

**Error Responses**

- `403 Forbidden`:
  - Cannot rate own idea
  - User not invited and idea is not public
  - User already rated this idea
- `404 Not Found`: Idea does not exist
- `500 Internal Server Error`: Server error

---

#### 2.2 Get Rating Stats

**GET** `/ideas/:ideaId/stats`

Retrieve aggregated statistics for an idea's ratings.

**Path Parameters**

- `ideaId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "totalRatings": 5,
    "averageOriginality": 8.2,
    "averageFeasibility": 7.6,
    "averageImpact": 8.8,
    "averageOverall": 8.2
  }
}
```

**Error Responses**

- `404 Not Found`: Idea does not exist

---

#### 2.3 Get All Ratings for Idea

**GET** `/ideas/:ideaId/ratings`

Retrieve all individual ratings submitted for an idea.

**Path Parameters**

- `ideaId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "rating-uuid",
      "originality": 8,
      "feasibility": 7,
      "impact": 9,
      "reviewer": {
        "id": "reviewer-uuid",
        "name": "Jane Smith",
        "email": "jane@example.com"
      },
      "createdAt": "2026-03-27T16:00:00Z"
    }
  ]
}
```

---

### 3. Invitations

#### 3.1 Send Invite

**POST** `/ideas/:ideaId/invite`

Invite a specific user to review an idea (creator only).

**Path Parameters**

- `ideaId`: UUID string (required)

**Request Body**

```json
{
  "reviewerId": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Field Constraints**

- `reviewerId`: UUID string (required, must be valid user)

**Response** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "invite-uuid",
    "ideaId": "idea-uuid",
    "reviewerId": "reviewer-uuid",
    "status": "PENDING",
    "reviewer": {
      "id": "reviewer-uuid",
      "name": "Jane Smith",
      "email": "jane@example.com"
    },
    "idea": {
      "id": "idea-uuid",
      "title": "My Great Idea"
    },
    "createdAt": "2026-03-27T16:00:00Z"
  }
}
```

**Error Responses**

- `403 Forbidden`: User is not the creator
- `404 Not Found`: Idea or reviewer does not exist
- `409 Conflict`: User already invited for this idea

---

#### 3.2 Accept Invite

**PATCH** `/ideas/:ideaId/invite/:inviteId`

Accept an invitation to review an idea (invited user only).

**Path Parameters**

- `ideaId`: UUID string (required)
- `inviteId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "invite-uuid",
    "ideaId": "idea-uuid",
    "reviewerId": "user-uuid",
    "status": "ACCEPTED",
    "updatedAt": "2026-03-27T16:00:00Z"
  }
}
```

**Error Responses**

- `403 Forbidden`: User is not the invited reviewer
- `404 Not Found`: Invite does not exist

---

#### 3.3 Get Idea Invites

**GET** `/ideas/:ideaId/invites`

Retrieve all invitations for an idea (creator only).

**Path Parameters**

- `ideaId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "invites": [
      {
        "id": "invite-uuid",
        "reviewerId": "reviewer-uuid",
        "status": "PENDING",
        "reviewer": {
          "id": "reviewer-uuid",
          "name": "Jane Smith"
        },
        "createdAt": "2026-03-27T16:00:00Z"
      }
    ]
  }
}
```

---

#### 3.4 Get User's Received Invites

**GET** `/user/invites`

Retrieve all invitations received by the authenticated user.

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "invites": [
      {
        "id": "invite-uuid",
        "ideaId": "idea-uuid",
        "status": "PENDING",
        "idea": {
          "id": "idea-uuid",
          "title": "Great Idea",
          "category": "Tech"
        },
        "creator": {
          "id": "creator-uuid",
          "name": "John Doe"
        },
        "createdAt": "2026-03-27T16:00:00Z"
      }
    ]
  }
}
```

---

#### 3.5 Get Pending Invites

**GET** `/user/invites/pending`

Retrieve all pending (unaccepted) invitations for the user.

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "invites": [
      {
        "id": "invite-uuid",
        "ideaId": "idea-uuid",
        "status": "PENDING",
        "idea": {
          "title": "Project Idea"
        }
      }
    ]
  }
}
```

---

### 4. Comments

#### 4.1 Create Comment

**POST** `/ideas/:ideaId/comments`

Add a comment/critique to an idea. User must have access to the idea.

**Path Parameters**

- `ideaId`: UUID string (required)

**Request Body**

```json
{
  "content": "Great idea! The market validation approach is strong. Consider the scalability challenges..."
}
```

**Field Constraints**

- `content`: String, 1-1000 characters (required)

**Response** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "comment-uuid",
    "ideaId": "idea-uuid",
    "userId": "user-uuid",
    "content": "Great idea! The market validation...",
    "createdAt": "2026-03-27T16:00:00Z"
  }
}
```

**Error Responses**

- `403 Forbidden`: User does not have access to the idea
- `404 Not Found`: Idea does not exist

---

#### 4.2 Get Comments for Idea

**GET** `/ideas/:ideaId/comments`

Retrieve paginated comments for an idea.

**Path Parameters**

- `ideaId`: UUID string (required)

**Query Parameters**

- `page`: Integer, minimum 1 (default: 1)
- `limit`: Integer, minimum 1 (default: 20)

**Example Request**

```
GET /ideas/idea-uuid/comments?page=1&limit=20
Authorization: Bearer {userId}
```

**Response** `200 OK`

```json
{
  "success": true,
  "data": {
    "comments": [
      {
        "id": "comment-uuid",
        "content": "Great idea!",
        "userId": "user-uuid",
        "user": {
          "id": "user-uuid",
          "name": "Jane Smith"
        },
        "createdAt": "2026-03-27T16:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5
    }
  }
}
```

**Error Responses**

- `404 Not Found`: Idea does not exist

---

#### 4.3 Delete Comment

**DELETE** `/ideas/:ideaId/comments/:commentId`

Delete a comment (comment creator or idea creator only).

**Path Parameters**

- `ideaId`: UUID string (required)
- `commentId`: UUID string (required)

**Response** `200 OK`

```json
{
  "success": true,
  "message": "Comment deleted"
}
```

**Error Responses**

- `403 Forbidden`: User is not comment creator or idea creator
- `404 Not Found`: Comment does not exist

---

## Data Models

### User

```json
{
  "id": "uuid",
  "name": "string",
  "email": "string (unique)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

### Idea

```json
{
  "id": "uuid",
  "title": "string (5-200)",
  "problemText": "string (10-2000)",
  "solutionText": "string (10-2000)",
  "category": "string (2-50)",
  "visibility": "PRIVATE | COMMUNITY | PUBLIC",
  "isPublic": "boolean",
  "creatorId": "uuid",
  "creator": "User object (optional)",
  "ratings": "IdeaRating[] (optional)",
  "comments": "IdeaComment[] (optional)",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

### IdeaRating

```json
{
  "id": "uuid",
  "ideaId": "uuid",
  "reviewerId": "uuid",
  "reviewer": "User object (optional)",
  "originality": "integer (1-10)",
  "feasibility": "integer (1-10)",
  "impact": "integer (1-10)",
  "createdAt": "ISO8601"
}
```

### IdeaInvite

```json
{
  "id": "uuid",
  "ideaId": "uuid",
  "reviewerId": "uuid",
  "reviewer": "User object (optional)",
  "idea": "Idea object (optional)",
  "status": "PENDING | ACCEPTED",
  "createdAt": "ISO8601"
}
```

### IdeaComment

```json
{
  "id": "uuid",
  "ideaId": "uuid",
  "userId": "uuid",
  "user": "User object (optional)",
  "content": "string (1-1000)",
  "createdAt": "ISO8601"
}
```

---

## HTTP Status Codes

| Code | Meaning | Common Scenarios |
|------|---------|------------------|
| 200 | OK | Successful GET, PATCH, DELETE |
| 201 | Created | Successful POST creating a resource |
| 400 | Bad Request | Invalid request body or parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Insufficient permissions or access denied |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Resource already exists (duplicate invites) |
| 500 | Server Error | Internal server error |

---

## Common Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    // Resource data
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": "Human-readable error message",
  "details": [
    // Optional validation details
    {
      "path": "fieldName",
      "message": "Error description"
    }
  ]
}
```

---

## Access Control

### Public Ideas (visibility: PUBLIC)

- Any authenticated user can view
- Any authenticated user can rate (if not creator)
- Any authenticated user can comment

### Community Ideas (visibility: COMMUNITY)

- Creator and invited reviewers can view
- Invited reviewers can rate and comment

### Private Ideas (visibility: PRIVATE)

- Only creator can view
- Only invited reviewers can view (after being invited)
- Only invited reviewers can rate and comment

---

## Rate Limiting & Quotas

Currently, there are no implemented rate limits. All endpoints are available to authenticated users.

---

## Testing

The API includes comprehensive test coverage:

- **50 Unit Tests**: 100% passing, testing business logic
- **41 Integration Tests**: Testing full request/response cycles
- **Total**: 91 tests covering all major features

Run tests:

```bash
npm run test                    # Run all tests
npm run test -- --coverage      # Run with coverage report
npm run test -- path/to/test.ts # Run specific test file
```

---

## Error Handling Examples

### Invalid Request Body

```json
{
  "success": false,
  "error": "Invalid body",
  "details": [
    {
      "path": "title",
      "message": "Title must be at least 5 characters"
    },
    {
      "path": "visibility",
      "message": "Invalid enum value"
    }
  ]
}
```

### Unauthorized Access

```json
{
  "success": false,
  "error": "Only the creator can invite reviewers"
}
```

### Duplicate Resource

```json
{
  "success": false,
  "error": "User has already been invited for this idea"
}
```

---

## Best Practices

### Authentication

- Always include the `Authorization` header with Bearer token
- Store tokens securely on the client side
- Never expose tokens in logs or error messages

### Pagination

- Default page size is typically 10-20 items
- Always handle pagination gracefully in client
- Use `limit` and `page` query parameters

### Validation

- The server validates all inputs using Zod schemas
- Respond to validation errors with appropriate field-level details
- Client-side validation should mirror server rules

### Error Handling

- Always check the `success` field in responses
- Log detailed error information for debugging
- Display user-friendly error messages to end users

---

## Visibility Levels Explained

| Level | Access | Use Case |
|-------|--------|----------|
| **PRIVATE** | Creator only (unless invited) | Confidential ideas, internal projects |
| **COMMUNITY** | Invited reviewers | Collaborative team projects |
| **PUBLIC** | All authenticated users | Published ideas, seeking broad feedback |

---

## Future Enhancements

- Real-time updates via WebSocket/Socket.io
- Advanced filtering and search
- Rate limiting and quota management
- API key authentication for third-party apps
- Webhook notifications
- Bulk operations
- Analytics and insights

---

**Last Updated**: March 27, 2026  
**API Version**: 1.0.0  
