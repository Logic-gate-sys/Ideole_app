import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { TestHelpers } from '../helpers/test-helpers.ts';

describe('------- Rating Integration Tests ---------', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('POST /api/ideole/ideas/:ideaId/rate - Create Rating', () => {
    it('should create a rating and return 201', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/rate`)
        .set('Authorization', `Bearer ${reviewer.id}`)
        .send({
          originality: 8,
          feasibility: 7,
          impact: 9,
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.originality).toBe(8);
    });

    it('should return 403 if user tries to rate own idea', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/rate`)
        .set('Authorization', `Bearer ${creator.id}`)
        .send({
          originality: 8,
          feasibility: 7,
          impact: 9,
        });

      expect(response.status).toBe(403);
    });

    it('should return 403 if rating twice', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      // First rating
      await request(app)
        .post(`/api/ideole/ideas/${idea.id}/rate`)
        .set('Authorization', `Bearer ${reviewer.id}`)
        .send({
          originality: 8,
          feasibility: 7,
          impact: 9,
        });

      // Try second rating
      const response = await request(app)
        .post(`/api/ideole/ideas/${idea.id}/rate`)
        .set('Authorization', `Bearer ${reviewer.id}`)
        .send({
          originality: 7,
          feasibility: 6,
          impact: 8,
        });

      expect(response.status).toBe(403);
    });

    it('should return 404 if idea not found', async () => {
      const reviewer = await TestHelpers.createUser();

      const response = await request(app)
        .post('/api/ideole/ideas/nonexistent-id/rate')
        .set('Authorization', `Bearer ${reviewer.id}`)
        .send({
          originality: 8,
          feasibility: 7,
          impact: 9,
        });

      expect(response.status).toBe(404);
    });
  });

  describe('GET /api/ideole/ideas/:ideaId/stats - Get Rating Stats', () => {
    it('should return aggregated rating stats', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get(`/api/ideole/ideas/${scenario.idea.id}/stats`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.totalRatings).toBeGreaterThan(0);
      expect(response.body.data.averageOriginality).toBeDefined();
      expect(response.body.data.averageFeasibility).toBeDefined();
      expect(response.body.data.averageImpact).toBeDefined();
      expect(response.body.data.averageOverall).toBeDefined();
    });

    it('should return zero stats for idea with no ratings', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const response = await request(app)
        .get(`/api/ideole/ideas/${idea.id}/stats`);

      expect(response.status).toBe(200);
      expect(response.body.data.totalRatings).toBe(0);
    });
  });

  describe('GET /api/ideole/ideas/:ideaId/ratings - Get All Ratings', () => {
    it('should return all ratings for an idea', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const response = await request(app)
        .get(`/api/ideole/ideas/${scenario.idea.id}/ratings`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data.length).toBeGreaterThan(0);
    });
  });
});
