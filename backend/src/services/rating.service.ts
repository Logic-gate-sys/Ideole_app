import { prisma } from '../lib/prisma.ts';
import { getAccessibleIdea } from './idea-access.service.ts';

type RatingInput = {
  originality: number;
  feasibility: number;
  impact: number;
};

type RatingRecord = {
  id: string;
  ideaId: string;
  authorId: string;
  scores: unknown;
  createdAt: Date;
};

function normalizeScores(scores: unknown): Record<string, number> {
  if (!scores || typeof scores !== 'object' || Array.isArray(scores)) {
    return {};
  }

  const normalized: Record<string, number> = {};
  for (const [key, value] of Object.entries(scores as Record<string, unknown>)) {
    const numericValue = typeof value === 'number' ? value : Number(value);
    if (Number.isFinite(numericValue)) {
      normalized[key] = numericValue;
    }
  }

  return normalized;
}

function roundTo2(value: number): number {
  return Math.round(value * 100) / 100;
}

function mapRating(record: RatingRecord) {
  return {
    id: record.id,
    ideaId: record.ideaId,
    reviewerId: record.authorId,
    scores: normalizeScores(record.scores),
    createdAt: record.createdAt,
  };
}

export const RatingService = {
  async createRating(ideaId: string, userId: string, payload: RatingInput) {
    const idea = await getAccessibleIdea(ideaId, userId);

    if (idea.ownerId === userId) {
      throw new Error('Unauthorized: Idea owners cannot rate their own idea');
    }

    const scores = {
      originality: payload.originality,
      feasibility: payload.feasibility,
      impact: payload.impact,
    };

    const createdRating = await prisma.$transaction(async (tx) => {
      await tx.ideaRating.updateMany({
        where: {
          ideaId,
          authorId: userId,
          isLatest: true,
        },
        data: {
          isLatest: false,
        },
      });

      return tx.ideaRating.create({
        data: {
          ideaId,
          authorId: userId,
          scores,
          isLatest: true,
        },
      });
    });

    return mapRating(createdRating);
  },

  async getIdeaRatings(ideaId: string, userId?: string) {
    await getAccessibleIdea(ideaId, userId);

    const ratings = await prisma.ideaRating.findMany({
      where: {
        ideaId,
        isLatest: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    return ratings.map(mapRating);
  },

  async getIdeaRatingStats(ideaId: string, userId?: string) {
    await getAccessibleIdea(ideaId, userId);

    const ratings = await prisma.ideaRating.findMany({
      where: {
        ideaId,
        isLatest: true,
      },
      select: {
        scores: true,
      },
    });

    if (ratings.length === 0) {
      return {
        ideaId,
        totalRatings: 0,
        averageScores: {},
        averageOverall: 0,
      };
    }

    const metricTotals: Record<string, { sum: number; count: number }> = {};
    let overallSum = 0;
    let overallCount = 0;

    for (const rating of ratings) {
      const normalizedScores = normalizeScores(rating.scores);
      for (const [metric, value] of Object.entries(normalizedScores)) {
        if (!metricTotals[metric]) {
          metricTotals[metric] = { sum: 0, count: 0 };
        }

        metricTotals[metric].sum += value;
        metricTotals[metric].count += 1;
        overallSum += value;
        overallCount += 1;
      }
    }

    const averageScores: Record<string, number> = {};
    for (const [metric, totals] of Object.entries(metricTotals)) {
      averageScores[metric] = roundTo2(totals.sum / totals.count);
    }

    return {
      ideaId,
      totalRatings: ratings.length,
      averageScores,
      averageOverall: overallCount > 0 ? roundTo2(overallSum / overallCount) : 0,
    };
  },
};
