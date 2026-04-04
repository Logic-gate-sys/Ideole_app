
---
# **Core Features for  MVP**

1. **User Authentication & Profile**

   * Sign up / login (JWT)
   * Basic profile info: name, email, skills

2. **Idea Management**

   * Post an idea
   * Update idea (optional)
   * Idea visibility: **Private (invite only)** or **Public**

3. **Invite Reviewers**

   * Send invitations to specific users
   * Track status (Pending / Accepted)

4. **Idea Rating**

   * Structured scoring: Originality, Feasibility, Impact
   * Aggregate average score per idea

5. **Comments / Critiques**

   * Comment thread per idea
   * Real-time updates with Socket.io

6. **Basic Stats / Dashboard**

   * Show average rating and number of reviewers/comments for each idea

7. **Public Idea Option**

   * Toggle idea from private → public so all users can rate/comment
---

# **Endpoints**

 RESTful API MVP:

---

## **1. Users / Authentication**

| Method | Endpoint       | Description              |
| ------ | -------------- | ------------------------ |![alt text](image.png)
| POST   | `/auth/signup` | Register new user        |
| POST   | `/auth/login`  | Login, returns JWT       |
| GET    | `/users/me`    | Get current user profile |
| PATCH  | `/users/me`    | Update user profile      |

---
## **2. Ideas**

| Method | Endpoint            | Description                                                |
| ------ | ------------------- | ---------------------------------------------------------- |
| POST   | `/ideas`            | Create a new idea                                          |
| GET    | `/ideas`            | Get all ideas visible to the user (public + invited)       |
| GET    | `/ideas/:id`        | Get idea details                                           |
| PATCH  | `/ideas/:id`        | Update idea details (title, problem, solution, visibility) |
| PATCH  | `/ideas/:id/public` | Make idea public                                           |

---

## **3. Invitations**

| Method | Endpoint                      | Description                      |
| ------ | ----------------------------- | -------------------------------- |
| POST   | `/ideas/:id/invite`           | Invite a user to review the idea |
| GET    | `/ideas/:id/invites`          | Get list of invited reviewers    |
| PATCH  | `/ideas/:id/invite/:inviteId` | Accept / reject invitation       |

---

## **4. Ratings / Reviews**

| Method | Endpoint           | Description                          |
| ------ | ------------------ | ------------------------------------ |
| POST   | `/ideas/:id/rate`  | Submit a rating for an idea          |
| GET    | `/ideas/:id/stats` | Get aggregated rating stats for idea |

**Example rating payload:**

```json
{
  "originality": 8,
  "feasibility": 6,
  "impact": 9
}
```

---

## **5. Comments**

| Method | Endpoint              | Description                   |
| ------ | --------------------- | ----------------------------- |
| POST   | `/ideas/:id/comments` | Add a comment / critique      |
| GET    | `/ideas/:id/comments` | Get all comments for the idea |

**Socket.io events for real-time:**

* `new_comment` → emitted to idea participants either community or invited fellas
* `rating_updated` → emitted to idea owner + participants
---

# **MVP User Flow **
1. User signs up → logs in → sees **Home Feed**
2. User posts an idea → chooses **Only community** or **Public** or **Only invites**
3. User invites reviewers → reviewers receive notifications
4. Reviewers rate idea → rating aggregated → updates appear in real-time
5. Reviewers comment → owner sees comments live
6. Owner can toggle **public** → everyone else can rate/comment

---
* **Core loop implemented:** Post → Invite → Rate → Comment → Stats
* All endpoints map directly to Prisma models (`User`, `Idea`, `IdeaInvite`, `IdeaRating`, `IdeaComment`)
* Real-time updates via Socket.io
* Everything else (communities, messaging, originality AI, sessions) can be **V2**
---
