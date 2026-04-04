import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('Membership Integration Tests', () => {
  let user1: any;
  let user2: any;
  let user3: any;
  let community: any;
  let organisation: any;

  beforeEach(async () => {
    user1 = await createTestUser({}, 'access');
    user2 = await createTestUser({ username: 'user2', email: 'user2@test.com' }, 'access');
    user3 = await createTestUser({ username: 'user3', email: 'user3@test.com' }, 'access');

    // Create organisation and community
    organisation = await prisma.organisation.create({
      data: {
        name: 'Test Org',
        ownerId: user1.id,
      },
    });

    community = await prisma.community.create({
      data: {
        name: 'Test Community',
        adminId: user1.id,
        organisationId: organisation.id,
      },
    });
  });

  describe('POST /api/communities/:communityId/memberships/request', () => {
    it('should request to join community', async () => {
      const response = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.userId).toBe(user2.id);
      expect(response.body.data.communityId).toBe(community.id);
      expect(response.body.data.status).toBe('PENDING');
    });

    it('should reject duplicate membership request', async () => {
      // First request
      await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      // Second request should fail
      const response = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(400);
      expect(response.body.details).toContain('already a member');
    });

    it('should return 404 for non-existent community', async () => {
      const response = await request(app)
        .post('/api/communities/nonexistent/memberships/request')
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(404);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`);

      expect(response.status).toBe(401);
    });
  });

  describe('GET /api/communities/:communityId/memberships/pending', () => {
    it('should list pending membership requests for admin', async () => {
      // Create membership requests
      await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user3.token}`);

      const response = await request(app)
        .get(`/api/communities/${community.id}/memberships/pending`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.data.map((m: any) => m.userId)).toContain(user2.id);
      expect(response.body.data.map((m: any) => m.userId)).toContain(user3.id);
    });

    it('should return empty list when no pending requests', async () => {
      const response = await request(app)
        .get(`/api/communities/${community.id}/memberships/pending`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(0);
    });

    it('should reject non-admin access', async () => {
      const response = await request(app)
        .get(`/api/communities/${community.id}/memberships/pending`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .get(`/api/communities/${community.id}/memberships/pending`);

      expect(response.status).toBe(401);
    });
  });

  describe('PATCH /api/communities/:communityId/memberships/:membershipId/approve', () => {
    it('should approve membership request', async () => {
      // Create request
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      // Approve
      const response = await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.status).toBe('ACTIVE');
      expect(response.body.data.userId).toBe(user2.id);
    });

    it('should reject non-admin approval', async () => {
      // Create request
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      // Try to approve as non-admin
      const response = await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/approve`)
        .set('Authorization', `Bearer ${user3.token}`);

      expect(response.status).toBe(403);
    });

    it('should return 404 for non-existent membership', async () => {
      const response = await request(app)
        .patch(`/api/communities/${community.id}/memberships/nonexistent/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(404);
    });
  });

  describe('PATCH /api/communities/:communityId/memberships/:membershipId/reject', () => {
    it('should reject membership request', async () => {
      // Create request
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      // Reject
      const response = await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/reject`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);

      // Verify membership is deleted
      const getRes = await request(app)
        .get(`/api/communities/${community.id}/memberships/pending`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(getRes.body.data).toHaveLength(0);
    });

    it('should reject non-admin rejection', async () => {
      // Create request
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      // Try to reject as non-admin
      const response = await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/reject`)
        .set('Authorization', `Bearer ${user3.token}`);

      expect(response.status).toBe(403);
    });
  });

  describe('DELETE /api/communities/:communityId/memberships/:membershipId', () => {
    it('should remove member from community by admin', async () => {
      // Create and approve membership
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      // Remove member
      const response = await request(app)
        .delete(`/api/communities/${community.id}/memberships/${membershipId}`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    it('should allow member to remove themselves', async () => {
      // Create and approve membership
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      // Member removes themselves
      const response = await request(app)
        .delete(`/api/communities/${community.id}/memberships/${membershipId}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    it('should reject non-admin/non-member removal', async () => {
      // Create and approve membership
      const reqRes = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const membershipId = reqRes.body.data.id;

      await request(app)
        .patch(`/api/communities/${community.id}/memberships/${membershipId}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      // Try to remove as unauthorized user
      const response = await request(app)
        .delete(`/api/communities/${community.id}/memberships/${membershipId}`)
        .set('Authorization', `Bearer ${user3.token}`);

      expect(response.status).toBe(403);
    });

    it('should return 404 for non-existent membership', async () => {
      const response = await request(app)
        .delete(`/api/communities/${community.id}/memberships/nonexistent`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(404);
    });
  });

  describe('GET /api/communities/:communityId/members', () => {
    it('should list active members', async () => {
      // Create and approve memberships
      const req1 = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      const req2 = await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user3.token}`);

      await request(app)
        .patch(`/api/communities/${community.id}/memberships/${req1.body.data.id}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      await request(app)
        .patch(`/api/communities/${community.id}/memberships/${req2.body.data.id}/approve`)
        .set('Authorization', `Bearer ${user1.token}`);

      const response = await request(app)
        .get(`/api/communities/${community.id}/members`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.data.map((m: any) => m.userId)).toContain(user2.id);
      expect(response.body.data.map((m: any) => m.userId)).toContain(user3.id);
    });

    it('should return empty list for community with no members', async () => {
      const response = await request(app)
        .get(`/api/communities/${community.id}/members`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(0);
    });

    it('should return 404 for non-existent community', async () => {
      const response = await request(app)
        .get('/api/communities/nonexistent/members');

      expect(response.status).toBe(404);
    });

    it('should only list ACTIVE members, not PENDING', async () => {
      // Create pending request
      await request(app)
        .post(`/api/communities/${community.id}/memberships/request`)
        .set('Authorization', `Bearer ${user2.token}`);

      // Get members
      const response = await request(app)
        .get(`/api/communities/${community.id}/members`);

      expect(response.status).toBe(200);
      expect(response.body.data).toHaveLength(0); // Pending request not included
    });
  });
});
