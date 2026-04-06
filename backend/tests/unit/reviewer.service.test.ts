import { describe, it, expect, beforeEach } from 'vitest';
import { ReviewerService } from '../../src/services/reviewer.service.ts';
import { prisma } from '../../src/lib/prisma.ts';
import { createTestUser } from '../helpers/testHelpers.ts';

describe('ReviewerService', () => {
  let owner: any;
  let reviewer: any;
  let idea: any;

  beforeEach(async () => {
    owner = await createTestUser({}, 'access');
    reviewer = await createTestUser({ username: 'reviewer', email: 'reviewer@test.com' }, 'access');

    idea = await prisma.idea.create({
      data: {
        title: 'Test Idea',
        description: 'Test',
        visibility: 'PUBLIC',
        stage: 'INCEPTION',
        createdById: owner.id,
      },
    });
  });

  describe('canManageReviewers', () => {
    it('should allow idea owner', async () => {
      const result = await ReviewerService.canManageReviewers(idea.id, owner.id);
      expect(result).toBe(true);
    });

    it('should deny non-owner', async () => {
      const result = await ReviewerService.canManageReviewers(idea.id, reviewer.id);
      expect(result).toBe(false);
    });
  });

  describe('inviteReviewer', () => {
    it('should create invitation', async () => {
      const invite = await ReviewerService.inviteReviewer(idea.id, reviewer.id);
      expect(invite.status).toBe('PENDING');
      expect(invite.reviewerId).toBe(reviewer.id);
    });

    it('should throw if already invited', async () => {
      await ReviewerService.inviteReviewer(idea.id, reviewer.id);
      
      await expect(
        ReviewerService.inviteReviewer(idea.id, reviewer.id)
      ).rejects.toThrow('already invited');
    });
  });

  describe('getIdeaReviewers', () => {
    beforeEach(async () => {
      await ReviewerService.inviteReviewer(idea.id, reviewer.id);
    });

    it('should return reviewer list', async () => {
      const reviewers = await ReviewerService.getIdeaReviewers(idea.id);
      expect(reviewers).toHaveLength(1);
      expect(reviewers[0].status).toBe('pending');
    });
  });

  describe('removeReviewer', () => {
    beforeEach(async () => {
      await ReviewerService.inviteReviewer(idea.id, reviewer.id);
    });

    it('should delete invitation', async () => {
      await ReviewerService.removeReviewer(idea.id, reviewer.id);
      const invites = await ReviewerService.getIdeaReviewers(idea.id);
      expect(invites).toHaveLength(0);
    });
  });

  describe('acceptInvitation', () => {
    beforeEach(async () => {
      await ReviewerService.inviteReviewer(idea.id, reviewer.id);
    });

    it('should update status to ACCEPTED', async () => {
      await ReviewerService.acceptInvitation(idea.id, reviewer.id);
      const invite = await prisma.ideaInvite.findUnique({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
      });
      expect(invite?.status).toBe('ACCEPTED');
    });
  });

  describe('declineInvitation', () => {
    beforeEach(async () => {
      await ReviewerService.inviteReviewer(idea.id, reviewer.id);
    });

    it('should update status to DECLINED', async () => {
      await ReviewerService.declineInvitation(idea.id, reviewer.id);
      const invite = await prisma.ideaInvite.findUnique({
        where: { ideaId_reviewerId: { ideaId: idea.id, reviewerId: reviewer.id } },
      });
      expect(invite?.status).toBe('DECLINED');
    });
  });
});
