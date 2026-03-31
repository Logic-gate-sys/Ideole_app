import { prisma } from "../lib/prisma.ts";

export interface CreateRatingInput {
  originality: number;
  feasibility: number;
  impact: number;
  ideaId: string;
  reviewerId: string;
}

export const RatingService = {
  /**
   * Create a new rating
   * @throws Error if user hasn't been invited and idea is not public
   */
  async createRating(input: CreateRatingInput) {
    const idea = await prisma.idea.findUnique({
      where: { id: input.ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    // Check if reviewer is the creator
    if (idea.creatorId === input.reviewerId) {
      throw new Error('Cannot rate your own idea');
    }

    // Check if reviewer has access (public or invited)
    if (!idea.isPublic) {
      const invite = await prisma.ideaInvite.findFirst({
        where: {
          ideaId: input.ideaId,
          reviewerId: input.reviewerId,
        },
      });

      if (!invite) {
        throw new Error('You do not have permission to rate this idea');
      }
    }

    // Check if user already rated
    const existingRating = await prisma.ideaRating.findFirst({
      where: {
        ideaId: input.ideaId,
        reviewerId: input.reviewerId,
      },
    });

    if (existingRating) {
      throw new Error('You have already rated this idea');
    }

    return prisma.ideaRating.create({
      data: {
        ideaId: input.ideaId,
        reviewerId: input.reviewerId,
        originality: input.originality,
        feasibility: input.feasibility,
        impact: input.impact,
      },
      include: {
        reviewer: { select: { id: true, name: true } },
      },
    });
  },

  /**
   * Get aggregated ratings for an idea
   */
  async getIdeaStats(ideaId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    const ratings = await prisma.ideaRating.findMany({
      where: { ideaId },
    });

    if (ratings.length === 0) {
      return {
        ideaId,
        totalRatings: 0,
        averageOriginality: 0,
        averageFeasibility: 0,
        averageImpact: 0,
        averageOverall: 0,
      };
    }

    const avgOriginality =
      ratings.reduce((sum, r) => sum + r.originality, 0) / ratings.length;
    const avgFeasibility =
      ratings.reduce((sum, r) => sum + r.feasibility, 0) / ratings.length;
    const avgImpact = ratings.reduce((sum, r) => sum + r.impact, 0) / ratings.length;
    const avgOverall = (avgOriginality + avgFeasibility + avgImpact) / 3;

    return {
      ideaId,
      totalRatings: ratings.length,
      averageOriginality: Math.round(avgOriginality * 100) / 100,
      averageFeasibility: Math.round(avgFeasibility * 100) / 100,
      averageImpact: Math.round(avgImpact * 100) / 100,
      averageOverall: Math.round(avgOverall * 100) / 100,
    };
  },

  /**
   * Get all ratings for an idea
   */
  async getIdeaRatings(ideaId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    return prisma.ideaRating.findMany({
      where: { ideaId },
      include: {
        reviewer: { select: { id: true, name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },

  /**
   * Get user's given ratings
   */
  async getUserRatings(userId: string) {
    return prisma.ideaRating.findMany({
      where: { reviewerId: userId },
      include: {
        idea: { select: { id: true, title: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },
};
