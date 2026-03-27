import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { TestHelpers } from '../helpers/test-helpers.ts';
import { RatingService } from '../../src/services/rating.service.ts';

describe('RatingService - Unit Tests', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('createRating', () => {
    it('should create a rating for public idea', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const result = await RatingService.createRating({
        ideaId: idea.id,
        reviewerId: reviewer.id,
        originality: 8,
        feasibility: 7,
        impact: 9,
      });

      expect(result).toBeDefined();
      expect(result.originality).toBe(8);
      expect(result.feasibility).toBe(7);
      expect(result.impact).toBe(9);
    });

    it('should create rating if user is invited', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });
      await TestHelpers.createInvite(idea.id, reviewer.id);

      const result = await RatingService.createRating({
        ideaId: idea.id,
        reviewerId: reviewer.id,
        originality: 8,
        feasibility: 7,
        impact: 9,
      });

      expect(result).toBeDefined();
      expect(result.reviewerId).toBe(reviewer.id);
    });

    it('should throw error if idea doesn\'t exist', async () => {
      const reviewer = await TestHelpers.createUser();

      await expect(
        RatingService.createRating({
          ideaId: 'nonexistent-id',
          reviewerId: reviewer.id,
          originality: 8,
          feasibility: 7,
          impact: 9,
        })
      ).rejects.toThrow('Idea not found');
    });

    it('should throw error if creator tries to rate own idea', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      await expect(
        RatingService.createRating({
          ideaId: idea.id,
          reviewerId: creator.id,
          originality: 8,
          feasibility: 7,
          impact: 9,
        })
      ).rejects.toThrow('Cannot rate your own idea');
    });

    it('should throw error if user has no access to private idea', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      await expect(
        RatingService.createRating({
          ideaId: idea.id,
          reviewerId: reviewer.id,
          originality: 8,
          feasibility: 7,
          impact: 9,
        })
      ).rejects.toThrow('You do not have permission to rate this idea');
    });

    it('should throw error if user already rated', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      // Create first rating
      await RatingService.createRating({
        ideaId: idea.id,
        reviewerId: reviewer.id,
        originality: 8,
        feasibility: 7,
        impact: 9,
      });

      // Try to create another
      await expect(
        RatingService.createRating({
          ideaId: idea.id,
          reviewerId: reviewer.id,
          originality: 7,
          feasibility: 6,
          impact: 8,
        })
      ).rejects.toThrow('You have already rated this idea');
    });
  });

  describe('getIdeaStats', () => {
    it('should return zero stats for idea with no ratings', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const stats = await RatingService.getIdeaStats(idea.id);

      expect(stats.totalRatings).toBe(0);
      expect(stats.averageOriginality).toBe(0);
      expect(stats.averageFeasibility).toBe(0);
      expect(stats.averageImpact).toBe(0);
      expect(stats.averageOverall).toBe(0);
    });

    it('should calculate correct average ratings', async () => {
      const creator = await TestHelpers.createUser();
      const reviewers = await TestHelpers.createMultipleUsers(2);
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      await RatingService.createRating({
        ideaId: idea.id,
        reviewerId: reviewers[0].id,
        originality: 10,
        feasibility: 8,
        impact: 9,
      });

      await RatingService.createRating({
        ideaId: idea.id,
        reviewerId: reviewers[1].id,
        originality: 8,
        feasibility: 10,
        impact: 7,
      });

      const stats = await RatingService.getIdeaStats(idea.id);

      expect(stats.totalRatings).toBe(2);
      expect(stats.averageOriginality).toBe(9);
      expect(stats.averageFeasibility).toBe(9);
      expect(stats.averageImpact).toBe(8);
    });

    it('should throw error if idea not found', async () => {
      await expect(
        RatingService.getIdeaStats('nonexistent-id')
      ).rejects.toThrow('Idea not found');
    });
  });

  describe('getIdeaRatings', () => {
    it('should return all ratings for an idea', async () => {
      const creator = await TestHelpers.createUser();
      const reviewers = await TestHelpers.createMultipleUsers(3);
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      await TestHelpers.createMultipleRatings(idea.id, reviewers.map(r => r.id));

      const ratings = await RatingService.getIdeaRatings(idea.id);

      expect(ratings.length).toBe(3);
    });
  });
});
