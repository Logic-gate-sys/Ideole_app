import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';

describe('Organisation Integration Tests', () => {
  describe('POST /api/organisations', () => {
    it('should create organisation as authenticated user', async () => {
      const { token: accessToken } = await createTestUser({}, 'access');

      const response = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'My Organisation',
          tier: 'starter',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('My Organisation');
      expect(response.body.data.ownerId).toBeDefined();
      expect(response.body.data.tier).toBe('starter');
      expect(response.body.data.maxCommunities).toBe(5);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .post('/api/organisations')
        .send({
          name: 'My Organisation',
          tier: 'starter',
        });

      expect(response.status).toBe(401);
    });

    it('should reject without required fields', async () => {
      const { token: accessToken } = await createTestUser({ username: 'user1', email: 'user1@test.com' }, 'access');

      const response = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          tier: 'starter',
        });

      expect(response.status).toBe(400);
    });
  });

  describe('GET /api/organisations/:id', () => {
    it('should retrieve organisation by id', async () => {
      const { token: accessToken } = await createTestUser({}, 'access');

      // Create org first
      const createRes = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Test Org' });

      const orgId = createRes.body.data.id;

      // Get org
      const response = await request(app)
        .get(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.id).toBe(orgId);
      expect(response.body.data.name).toBe('Test Org');
    });

    it('should return 404 if organisation does not exist', async () => {
      const { token: accessToken } = await createTestUser({ username: 'user2', email: 'user2@test.com' }, 'access');

      const response = await request(app)
        .get('/api/organisations/nonexistent')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(404);
    });
  });

  describe('GET /api/organisations', () => {
    it('should list user\'s organisations', async () => {
      const { token: accessToken } = await createTestUser({}, 'access');

      // Create multiple orgs
      await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Org 1' });

      await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Org 2' });

      const response = await request(app)
        .get('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.data.map((o: any) => o.name)).toContain('Org 1');
      expect(response.body.data.map((o: any) => o.name)).toContain('Org 2');
    });

    it('should reject without authentication', async () => {
      const response = await request(app).get('/api/organisations');

      expect(response.status).toBe(401);
    });
  });

  describe('PUT /api/organisations/:id', () => {
    it('should update organisation', async () => {
      const { token: accessToken } = await createTestUser({ username: 'user3', email: 'user3@test.com' }, 'access');

      // Create org
      const createRes = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Original Name' });

      const orgId = createRes.body.data.id;

      // Update org
      const response = await request(app)
        .put(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Updated Name', tier: 'professional' });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('Updated Name');
      expect(response.body.data.tier).toBe('professional');
    });

    it('should prevent updating other user\'s organisation', async () => {
      const user1 = await createTestUser({ username: 'user4', email: 'user4@test.com' }, 'access');
      const user2 = await createTestUser({ username: 'user5', email: 'user5@test.com' }, 'access');

      // User 1 creates org
      const createRes = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({ name: 'User 1 Org' });

      const orgId = createRes.body.data.id;

      // User 2 tries to update
      const response = await request(app)
        .put(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${user2.token}`)
        .send({ name: 'Hacked' });

      expect(response.status).toBe(403);
    });
  });

  describe('DELETE /api/organisations/:id', () => {
    it('should delete organisation', async () => {
      const { token: accessToken } = await createTestUser({ username: 'user6', email: 'user6@test.com' }, 'access');

      // Create org
      const createRes = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'To Delete' });

      const orgId = createRes.body.data.id;

      // Delete org
      const response = await request(app)
        .delete(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);

      // Verify deleted
      const getRes = await request(app)
        .get(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(getRes.status).toBe(404);
    });

    it('should prevent deleting other user\'s organisation', async () => {
      const user1 = await createTestUser({ username: 'user7', email: 'user7@test.com' }, 'access');
      const user2 = await createTestUser({ username: 'user8', email: 'user8@test.com' }, 'access');

      // User 1 creates org
      const createRes = await request(app)
        .post('/api/organisations')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({ name: 'User 1 Org' });

      const orgId = createRes.body.data.id;

      // User 2 tries to delete
      const response = await request(app)
        .delete(`/api/organisations/${orgId}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });
  });
});
