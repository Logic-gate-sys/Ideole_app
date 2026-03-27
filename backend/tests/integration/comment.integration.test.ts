import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { TestHelpers } from '../helpers/test-helpers.ts';

describe('------- Invite Integration Tests ---------', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('POST /api/ideole/ideas/:ideaId/invite - Send Invite', () => {
    it('should send invite and return 201', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/invite`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({ reviewerId: reviewer.id });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.reviewerId).toBe(reviewer.id);
      expect(response.body.data.status).toBe('PENDING');
    });

    it('should return 403 if user is not creator', async () => {
      const creator = await TestHelpers.createUser();
      const other = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/invite`)
        .set('Authorization', `Bearer ${other.id}`)
        .send({ reviewerId: reviewer.id });

      expect(response.status).toBe(403);
    });

    it('should return 409 if already invited', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      // First invite
      await request(app)
        .post(`/api/ideole/ideas/${idea.id}/invite`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({ reviewerId: reviewer.id });

      // Try to invite again
      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/invite`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({ reviewerId: reviewer.id });

      expect(response.status).toBe(409);
    });
  });

  describe('PATCH /api/ideole/ideas/:ideaId/invite/:inviteId - Accept Invite', () => {
    it('should accept invite and return 200', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);
      const invite = await TestHelpers.createInvite(idea.id, reviewer.id);

      const response = await request(app)
        .patch(`/api/ideole/ideas/${idea.id}/invite/${invite.id}`)
        .set('Authorization', `Bearer ${reviewer.id}`);

      expect(response.status).toBe(200);
      expect(response.body.data.status).toBe('ACCEPTED');
    });

    it('should return 403 if user is not the reviewer', async () => {
      const scenario = await TestHelpers.createCompleteScenario();
      const otherUser = await TestHelpers.createUser();
      const invite = scenario.invites[0];

      const response = await request(app)
        .patch(`/api/ideole/ideas/${scenario.idea.id}/invite/${invite.id}`)
        .set('Authorization', `Bearer ${otherUser.id}`);

      expect(response.status).toBe(403);
    });
  });

  describe('GET /api/ideole/ideas/:ideaId/invites - Get Idea Invites', () => {
    it('should return all invites for an idea', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get(`/api/ideole/ideas/${scenario.idea.id}/invites`)
        .set('Authorization', `Bearer ${scenario.creator.id}`);

      expect(response.status).toBe(200);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data.length).toBe(3);
    });
  });

  describe('GET /api/ideole/user/invites - Get User Invites', () => {
    it('should return invites for a user', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get('/api/ideole/user/invites')
        .set('Authorization', `Bearer ${scenario.reviewers[0].id}`);

      expect(response.status).toBe(200);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('GET /api/ideole/user/invites/pending - Get Pending Invites', () => {
    it('should return only pending invites for user', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get('/api/ideole/user/invites/pending')
        .set('Authorization', `Bearer ${scenario.reviewers[0].id}`);

      expect(response.status).toBe(200);
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });
});
