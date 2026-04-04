import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('User Integration Tests', () => {
  let user: any;
  let testUser2: any;

  beforeEach(async () => {
    user = await createTestUser({}, 'access');
    testUser2 = await createTestUser({ username: 'user2', email: 'user2@test.com' }, 'access');
  });

  describe('GET /api/users/:userId', () => {
    it('should get user profile by id', async () => {
      const response = await request(app)
        .get(`/api/users/${user.id}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.id).toBe(user.id);
      expect(response.body.data.username).toBe(user.username);
      expect(response.body.data.email).toBe(user.email);
      expect(response.body.data.profileUrl).toBeDefined();
    });

    it('should return 404 for non-existent user', async () => {
      const response = await request(app)
        .get('/api/users/nonexistent');

      expect(response.status).toBe(404);
      expect(response.body.details).toContain('not found');
    });
  });

  describe('PUT /api/users/me', () => {
    it('should update user profile', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          username: 'newusername',
          email: 'newemail@test.com',
          profileUrl: 'https://example.com/profile.jpg',
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.username).toBe('newusername');
      expect(response.body.data.email).toBe('newemail@test.com');
      expect(response.body.data.profileUrl).toBe('https://example.com/profile.jpg');
    });

    it('should reject duplicate email', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          email: testUser2.email,
        });

      expect(response.status).toBe(400);
      expect(response.body.details).toContain('already in use');
    });

    it('should reject duplicate username', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          username: testUser2.username,
        });

      expect(response.status).toBe(400);
      expect(response.body.details).toContain('already taken');
    });

    it('should reject invalid email format', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          email: 'invalid-email',
        });

      expect(response.status).toBe(400);
    });

    it('should reject invalid URL for profileUrl', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .set('Authorization', `Bearer ${user.token}`)
        .send({
          profileUrl: 'not-a-url',
        });

      expect(response.status).toBe(400);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .put('/api/users/me')
        .send({
          username: 'newusername',
        });

      expect(response.status).toBe(401);
    });
  });

  describe('PATCH /api/users/me/active', () => {
    it('should update last active timestamp', async () => {
      const response = await request(app)
        .patch('/api/users/me/active')
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.lastActive).toBeDefined();
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .patch('/api/users/me/active');

      expect(response.status).toBe(401);
    });
  });

  describe('GET /api/users/me/memberships', () => {
    it('should return empty memberships for new user', async () => {
      const response = await request(app)
        .get('/api/users/me/memberships')
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(0);
    });

    it('should list user memberships', async () => {
      // Create community and add membership
      const org = await prisma.organisation.create({
        data: {
          name: 'Test Org',
          ownerId: user.id,
        },
      });

      const community = await prisma.community.create({
        data: {
          name: 'Test Community',
          adminId: user.id,
          organisationId: org.id,
        },
      });

      await prisma.membership.create({
        data: {
          userId: user.id,
          communityId: community.id,
          organisationId: org.id,
        },
      });

      const response = await request(app)
        .get('/api/users/me/memberships')
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].communityId).toBe(community.id);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .get('/api/users/me/memberships');

      expect(response.status).toBe(401);
    });
  });

  describe('GET /api/users/me/ideas', () => {
    it('should return empty ideas for new user', async () => {
      const response = await request(app)
        .get('/api/users/me/ideas')
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(0);
    });

    it('should list user ideas', async () => {
      // Create ideas
      const idea1 = await prisma.idea.create({
        data: {
          title: 'Idea 1',
          description: 'Description 1',
          ownerId: user.id,
        },
      });

      const idea2 = await prisma.idea.create({
        data: {
          title: 'Idea 2',
          description: 'Description 2',
          ownerId: user.id,
        },
      });

      const response = await request(app)
        .get('/api/users/me/ideas')
        .set('Authorization', `Bearer ${user.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.data.map((idea: any) => idea.id)).toContain(idea1.id);
      expect(response.body.data.map((idea: any) => idea.id)).toContain(idea2.id);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .get('/api/users/me/ideas');

      expect(response.status).toBe(401);
    });
  });
});
