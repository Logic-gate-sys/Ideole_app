import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('Reviewer Routes', () => {
  let owner: any;
  let reviewer: any;
  let idea: any;

  beforeEach(async () => {
    owner = await createTestUser({}, 'access');
    reviewer = await createTestUser({ username: 'reviewer', email: 'reviewer@test.com' }, 'access');

    // Create test idea
    idea = await prisma.idea.create({
      data: {
        title: 'Test Idea',
        description: 'Test description',
        visibility: 'PUBLIC',
        stage: 'INCEPTION',
        createdById: owner.id,
      },
    });
  });

  describe('GET /api/ideas/:ideaId/reviewers', () => {
    it('should return empty reviewers list', async () => {
      const res = await request(app)
        .get(`/api/ideas/${idea.id}/reviewers`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toEqual([]);
    });

    it('should return 401 without token', async () => {
      const res = await request(app)
        .get(`/api/ideas/${idea.id}/reviewers`);

      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/ideas/:ideaId/reviewers', () => {
    it('should invite reviewer', async () => {
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ reviewerId: reviewer.id });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data.status).toBe('PENDING');
    });

    it('should prevent duplicate invites', async () => {
      // First invite
      await request(app)
        .post(`/api/ideas/${idea.id}/reviewers`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ reviewerId: reviewer.id });

      // Second invite should fail
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ reviewerId: reviewer.id });

      expect(res.status).toBe(400);
      expect(res.body.details).toContain('already invited');
    });

    it('should prevent non-owner from inviting', async () => {
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers`)
        .set('Authorization', `Bearer ${reviewer.token}`)
        .send({ reviewerId: reviewer.id });

      expect(res.status).toBe(403);
    });
  });

  describe('DELETE /api/ideas/:ideaId/reviewers/:reviewerId', () => {
    it('should remove reviewer', async () => {
      // Create invite
      await prisma.ideaInvite.create({
        data: {
          ideaId: idea.id,
          reviewerId: reviewer.id,
          status: 'ACCEPTED',
        },
      });

      const res = await request(app)
        .delete(`/api/ideas/${idea.id}/reviewers/${reviewer.id}`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);

      // Verify removed
      const invite = await prisma.ideaInvite.findUnique({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
      });
      expect(invite).toBeNull();
    });

    it('should return 404 if reviewer not found', async () => {
      const fakeId = 'nonexistent';
      const res = await request(app)
        .delete(`/api/ideas/${idea.id}/reviewers/${fakeId}`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(404);
    });
  });

  describe('POST /api/ideas/:ideaId/reviewers/:reviewerId/resend-invite', () => {
    beforeEach(async () => {
      // Create pending invite
      await prisma.ideaInvite.create({
        data: {
          ideaId: idea.id,
          reviewerId: reviewer.id,
          status: 'PENDING',
        },
      });
    });

    it('should resend invitation', async () => {
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/resend-invite`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('should fail if invite not pending', async () => {
      // Accept invite first
      await prisma.ideaInvite.update({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
        data: { status: 'ACCEPTED' },
      });

      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/resend-invite`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(400);
      expect(res.body.details).toContain('pending');
    });
  });

  describe('DELETE /api/ideas/:ideaId/reviewers/:reviewerId/invite', () => {
    beforeEach(async () => {
      await prisma.ideaInvite.create({
        data: {
          ideaId: idea.id,
          reviewerId: reviewer.id,
          status: 'PENDING',
        },
      });
    });

    it('should cancel pending invitation', async () => {
      const res = await request(app)
        .delete(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/invite`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('should fail if invitation not pending', async () => {
      await prisma.ideaInvite.update({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
        data: { status: 'ACCEPTED' },
      });

      const res = await request(app)
        .delete(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/invite`)
        .set('Authorization', `Bearer ${owner.token}`);

      expect(res.status).toBe(400);
    });
  });

  describe('POST /api/ideas/:ideaId/reviewers/:reviewerId/accept', () => {
    beforeEach(async () => {
      await prisma.ideaInvite.create({
        data: {
          ideaId: idea.id,
          reviewerId: reviewer.id,
          status: 'PENDING',
        },
      });
    });

    it('should accept own invitation', async () => {
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/accept`)
        .set('Authorization', `Bearer ${reviewer.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);

      const invite = await prisma.ideaInvite.findUnique({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
      });
      expect(invite?.status).toBe('ACCEPTED');
    });

    it('should prevent accepting others\' invitations', async () => {
      const other = await createTestUser({ username: 'other', email: 'other@test.com' }, 'access');

      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/accept`)
        .set('Authorization', `Bearer ${other.token}`);

      expect(res.status).toBe(403);
    });
  });

  describe('POST /api/ideas/:ideaId/reviewers/:reviewerId/decline', () => {
    beforeEach(async () => {
      await prisma.ideaInvite.create({
        data: {
          ideaId: idea.id,
          reviewerId: reviewer.id,
          status: 'PENDING',
        },
      });
    });

    it('should decline own invitation', async () => {
      const res = await request(app)
        .post(`/api/ideas/${idea.id}/reviewers/${reviewer.id}/decline`)
        .set('Authorization', `Bearer ${reviewer.token}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);

      const invite = await prisma.ideaInvite.findUnique({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
      });
      expect(invite?.status).toBe('DECLINED');
    });
  });
});
