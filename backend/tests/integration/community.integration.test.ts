import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('Community Integration Tests', () => {
  let user: any;
  let organisation: any;

  beforeEach(async () => {
    user = await createTestUser({}, 'access');
    organisation = await prisma.organisation.create({
      data: {
        name: 'Test Org',
        ownerId: user.id,
      },
    });
  });

  describe('POST /api/organisations/:organisationId/communities', () => {
    it('should create community', async () => {
      const response = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          name: 'My Community',
          description: 'A community',
          visibility: 'PUBLIC',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('My Community');
      expect(response.body.data.visibility).toBe('PUBLIC');
    });
  });

  describe('GET /api/organisations/:organisationId/communities/:communityId', () => {
    it('should retrieve community', async () => {
      const createRes = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Test Community' });

      const communityId = createRes.body.data.id;

      const response = await request(app)
        .get(`/api/organisations/${organisation.id}/communities/${communityId}`)
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('Test Community');
    });
  });

  describe('GET /api/organisations/:organisationId/communities', () => {
    it('should list communities', async () => {
      await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Community 1' });

      await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Community 2' });

      const response = await request(app)
        .get(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(2);
    });
  });

  describe('PUT /api/organisations/:organisationId/communities/:communityId', () => {
    it('should update community', async () => {
      const createRes = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Original Name' });

      const communityId = createRes.body.data.id;

      const response = await request(app)
        .put(`/api/organisations/${organisation.id}/communities/${communityId}`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Updated Name', visibility: 'PUBLIC' });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('Updated Name');
      expect(response.body.data.visibility).toBe('PUBLIC');
    });

    it('should prevent non-admin from updating', async () => {
      const user2 = await createTestUser({ username: 'user99', email: 'user99@test.com' }, 'access');

      const createRes = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Admin Community' });

      const communityId = createRes.body.data.id;

      const response = await request(app)
        .put(`/api/organisations/${organisation.id}/communities/${communityId}`)
        .set('Authorization', `Bearer ${user2.token}`)
        .send({ name: 'Hacked' });

      expect(response.status).toBe(403);
    });
  });

  describe('DELETE /api/organisations/:organisationId/communities/:communityId', () => {
    it('should delete community', async () => {
      const createRes = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'To Delete' });

      const communityId = createRes.body.data.id;

      const response = await request(app)
        .delete(`/api/organisations/${organisation.id}/communities/${communityId}`)
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    it('should prevent non-admin from deleting', async () => {
      const user2 = await createTestUser({ username: 'user98', email: 'user98@test.com' }, 'access');

      const createRes = await request(app)
        .post(`/api/organisations/${organisation.id}/communities`)
        .set('Authorization', `Bearer ${user.token}`)
        .send({ name: 'Admin Community' });

      const communityId = createRes.body.data.id;

      const response = await request(app)
        .delete(`/api/organisations/${organisation.id}/communities/${communityId}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });
  });
});
