import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { TestHelpers } from '../helpers/test-helpers.ts';

describe('------- Comment Integration Tests ---------', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('POST /api/ideole/ideas/:ideaId/comments - Create Comment', () => {
    it('should create comment on public idea and return 201', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/comments`)
        .set('Authorization', `Bearer ${commenter.id}`)
        .send({
          content: 'This is a great idea with excellent potential!',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.content).toBe('This is a great idea with excellent potential!');
    });

    it('should allow creator to comment on own idea', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/comments`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({
          content: 'My own comment on my idea',
        });

      expect(response.status).toBe(201);
    });

    it('should return 403 if user has no access to private idea', async () => {
      const creator = await TestHelpers.createUser();
      const other = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/comments`)
        .set('Authorization', `Bearer ${other.id}`)
        .send({
          content: 'Unauthorized comment',
        });

      expect(response.status).toBe(403);
    });
  });

  describe('GET /api/ideole/ideas/:ideaId/comments - Get Comments', () => {
    it('should return all comments for an idea', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get(`/api/ideole/ideas/${scenario.idea.id}/comments`)
        .set('Authorization', `Bearer ${scenario.creator.id}`);

      expect(response.status).toBe(200);
      expect(response.body.data.comments.length).toBe(3);
      expect(response.body.data.pagination.total).toBe(3);
    });
  });

  describe('DELETE /api/ideole/ideas/:ideaId/comments/:commentId - Delete Comment', () => {
    it('should delete comment by creator and return 200', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      const response = await request(app)
        .delete(`/api/ideole/ideas/${idea.id}/comments/${comment.id}`)
        .set('Authorization', `Bearer ${commenter.id}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    it('should delete comment by idea creator', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      const response = await request(app)
        .delete(`/api/ideole/ideas/${idea.id}/comments/${comment.id}`)
        .set('Authorization', `Bearer ${creator.id}`);

      expect(response.status).toBe(200);
    });

    it('should return 403 if user has no permission', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const other = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      const response = await request(app)
        .delete(`/api/ideole/ideas/${idea.id}/comments/${comment.id}`)
        .set('Authorization', `Bearer ${other.id}`);

      expect(response.status).toBe(403);
    });
  });
});
