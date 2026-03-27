import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { TestHelpers } from '../helpers/test-helpers.ts';
import { InviteService } from '../../src/services/invite.service.ts';

describe('InviteService - Unit Tests', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('sendInvite', () => {
    it('should send invite successfully', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const result = await InviteService.sendInvite({
        ideaId: idea.id,
        reviewerId: reviewer.id,
        creatorId: creator.id,
      });

      expect(result).toBeDefined();
      expect(result.reviewerId).toBe(reviewer.id);
      expect(result.ideaId).toBe(idea.id);
      expect(result.status).toBe('PENDING');
    });

    it('should throw error if idea not found', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();

      await expect(
        InviteService.sendInvite({
          ideaId: 'nonexistent-id',
          reviewerId: reviewer.id,
          creatorId: creator.id,
        })
      ).rejects.toThrow('Idea not found');
    });

    it('should throw error if user is not the creator', async () => {
      const creator = await TestHelpers.createUser();
      const otherUser = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await expect(
        InviteService.sendInvite({
          ideaId: idea.id,
          reviewerId: reviewer.id,
          creatorId: otherUser.id,
        })
      ).rejects.toThrow('Only the creator can invite reviewers');
    });

    it('should throw error if trying to invite yourself', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await expect(
        InviteService.sendInvite({
          ideaId: idea.id,
          reviewerId: creator.id,
          creatorId: creator.id,
        })
      ).rejects.toThrow('Cannot invite yourself');
    });

    it('should throw error if reviewer does not exist', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await expect(
        InviteService.sendInvite({
          ideaId: idea.id,
          reviewerId: 'nonexistent-reviewer',
          creatorId: creator.id,
        })
      ).rejects.toThrow('Reviewer not found');
    });

    it('should throw error if already invited', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await InviteService.sendInvite({
        ideaId: idea.id,
        reviewerId: reviewer.id,
        creatorId: creator.id,
      });

      await expect(
        InviteService.sendInvite({
          ideaId: idea.id,
          reviewerId: reviewer.id,
          creatorId: creator.id,
        })
      ).rejects.toThrow('User has already been invited for this idea');
    });
  });

  describe('acceptInvite', () => {
    it('should accept invite successfully', async () => {
      const scenario = await TestHelpers.createCompleteScenario();
      const invite = scenario.invites[2]; // Pending invite

      const result = await InviteService.acceptInvite(invite.id, scenario.reviewers[2].id);

      expect(result.status).toBe('ACCEPTED');
    });

    it('should throw error if invite not found', async () => {
      const user = await TestHelpers.createUser();

      await expect(
        InviteService.acceptInvite('nonexistent-invite', user.id)
      ).rejects.toThrow('Invite not found');
    });

    it('should throw error if user is not the reviewer', async () => {
      const scenario = await TestHelpers.createCompleteScenario();
      const otherUser = await TestHelpers.createUser();
      const invite = scenario.invites[2];

      await expect(
        InviteService.acceptInvite(invite.id, otherUser.id)
      ).rejects.toThrow('Cannot accept invite for another user');
    });
  });

  describe('getIdeaInvites', () => {
    it('should retrieve all invites for an idea', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const result = await InviteService.getIdeaInvites(scenario.idea.id, scenario.creator.id);

      expect(result.length).toBe(3);
    });

    it('should throw error if user is not creator', async () => {
      const scenario = await TestHelpers.createCompleteScenario();
      const otherUser = await TestHelpers.createUser();

      await expect(
        InviteService.getIdeaInvites(scenario.idea.id, otherUser.id)
      ).rejects.toThrow('Only the creator can view invites');
    });
  });

  describe('getUserInvites', () => {
    it('should retrieve all invites for a user', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const result = await InviteService.getUserInvites(scenario.reviewers[0].id);

      expect(result.length).toBeGreaterThan(0);
    });

    it('should return invites in correct order', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const result = await InviteService.getUserInvites(scenario.reviewers[0].id);

      expect(result[0].status).toBeDefined();
    });
  });

  describe('getPendingInvites', () => {
    it('should return only pending invites', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const result = await InviteService.getPendingInvites(scenario.reviewers[0].id);

      expect(result.length).toBe(0); // All first two are accepted in scenario
      for (const invite of result) {
        expect(invite.status).toBe('PENDING');
      }
    });
  });
});
