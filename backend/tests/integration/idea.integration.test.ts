import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { TestHelpers } from '../helpers/test-helpers.ts';

describe('------- Idea Integration Tests ---------', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('POST /api/ideole/ideas - Create Idea', () => {
    it('should create a new idea and return 201', async () => {
      const user = await TestHelpers.createUser();

      const response = await request(app)
        .post('/api/ideole/ideas')
        .set('Authorization', `Bearer ${user.id}`) // Simulate auth
        .send({
          title: 'AI-Powered Task Manager',
          problemText: 'Users struggle to organize tasks across platforms',
          solutionText: 'Create a unified AI-powered task management platform',
          category: 'Productivity',
          visibility: 'PRIVATE',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe('AI-Powered Task Manager');
      expect(response.body.data.creatorId).toBe(user.id);
    });
  });

  describe('GET /api/ideole/ideas - Get Visible Ideas', () => {
    it('should return public ideas to any user', async () => {
      const creator = await TestHelpers.createUser();
      const viewer = await TestHelpers.createUser();

      await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const response = await request(app)
        .get('/api/ideole/ideas')
        .set('Authorization', `Bearer ${viewer.id}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.ideas.length).toBe(1);
    });

    it('should return user\'s own ideas', async () => {
      const user = await TestHelpers.createUser();
      await TestHelpers.createMultipleIdeas(user.id, 3);

      const response = await request(app)
        .get('/api/ideole/ideas')
        .set('Authorization', `Bearer ${user.id}`);

      expect(response.status).toBe(200);
      expect(response.body.data.ideas.length).toBe(3);
    });
  });

  describe('GET /api/ideole/ideas/:ideaId - Get Idea Details', () => {
    it('should return idea with all relations', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get(`/api/ideole/ideas/${scenario.idea.id}`)
        .set('Authorization', `Bearer ${scenario.creator.id}`);

      expect(response.status).toBe(200);
      expect(response.body.data.title).toBe(scenario.idea.title);
      expect(response.body.data.creator).toBeDefined();
      expect(response.body.data.ratings).toBeDefined();
      expect(response.body.data.comments).toBeDefined();
    });
  });

  describe('PATCH /api/ideole/ideas/:ideaId - Update Idea', () => {
    it('should update idea and return 200', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const response = await request(app)
        .patch(`/api/ideole/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({
          title: 'Updated Idea Title',
          problemText: 'Updated problem',
        });

      expect(response.status).toBe(200);
      expect(response.body.data.title).toBe('Updated Idea Title');
    });

    it('should return 403 if user is not creator', async () => {
      const creator = await TestHelpers.createUser();
      const other = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const response = await request(app)
        .patch(`/api/ideole/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${other.id}`)
        .send({ title: 'Hacked' });

      expect(response.status).toBe(403);
    });
  });

  describe('PATCH /api/ideole/ideas/:ideaId/public - Toggle Visibility', () => {
    it('should make idea public', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { isPublic: false });

      const response = await request(app)
        .patch(`/api/ideole/ideas/${idea.id}/public`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({ isPublic: true });

      expect(response.status).toBe(200);
      expect(response.body.data.isPublic).toBe(true);
    });
  });
});
