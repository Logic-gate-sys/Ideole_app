import { prisma } from '@/lib/prisma';
import { Visibility } from '../types/index.ts';

export interface CreateIdeaInput {
  title: string;
  problemText: string;
  solutionText: string;
  category: string;
  visibility: Visibility;
  creatorId: string;
}

export interface UpdateIdeaInput {
  title?: string;
  problemText?: string;
  solutionText?: string;
  category?: string;
  visibility?: Visibility;
}

export const IdeaService = {
  /**
   * Create a new idea
   */
  async createIdea(input: CreateIdeaInput) {
    return prisma.idea.create({
      data: {
        title: input.title,
        problemText: input.problemText,
        solutionText: input.solutionText,
        category: input.category,
        visibility: input.visibility,
        isPublic: input.visibility === 'PUBLIC',
        creatorId: input.creatorId,
      },
      include: {
        creator: {
          select: { id: true, name: true, email: true },
        },
      },
    });
  },

  /**
   * Get idea by ID with full details
   */
  async getIdeaById(ideaId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      include: {
        creator: { select: { id: true, name: true, email: true } },
        ratings: true,
        comments: { include: { user: { select: { id: true, name: true } } } },
        invites: { include: { reviewer: { select: { id: true, name: true } } } },
      },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    return idea;
  },

  /**
   * Get all ideas visible to a user (public + their own + invited to)
   */
  async getVisibleIdeasForUser(userId: string, page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;

    const [ideas, total] = await Promise.all([
      prisma.idea.findMany({
        where: {
          OR: [
            { visibility: 'PUBLIC' },
            { creatorId: userId },
            {
              invites: {
                some: { reviewerId: userId },
              },
            },
          ],
        },
        include: {
          creator: { select: { id: true, name: true } },
          _count: {
            select: { ratings: true, comments: true, invites: true },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.idea.count({
        where: {
          OR: [
            { visibility: 'PUBLIC' },
            { creatorId: userId },
            {
              invites: {
                some: { reviewerId: userId },
              },
            },
          ],
        },
      }),
    ]);

    return {
      ideas,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit),
      },
    };
  },

  /**
   * Update idea
   */
  async updateIdea(ideaId: string, input: UpdateIdeaInput, userId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      select: { creatorId: true },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.creatorId !== userId) {
      throw new Error('Only the creator can update this idea');
    }

    const updateData: any = {};
    if (input.title) updateData.title = input.title;
    if (input.problemText) updateData.problemText = input.problemText;
    if (input.solutionText) updateData.solutionText = input.solutionText;
    if (input.category) updateData.category = input.category;
    if (input.visibility) {
      updateData.visibility = input.visibility;
      updateData.isPublic = input.visibility === 'PUBLIC';
    }

    return prisma.idea.update({
      where: { id: ideaId },
      data: updateData,
      include: {
        creator: { select: { id: true, name: true } },
      },
    });
  },

  /**
   * Toggle idea visibility between private/public
   */
  async toggleIdeaPublic(ideaId: string, isPublic: boolean, userId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      select: { creatorId: true },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.creatorId !== userId) {
      throw new Error('Only the creator can change idea visibility');
    }

    return prisma.idea.update({
      where: { id: ideaId },
      data: {
        isPublic,
        visibility: isPublic ? 'PUBLIC' : 'PRIVATE',
      },
      include: { creator: { select: { id: true, name: true } } },
    });
  },

  /**
   * Get user's own ideas
   */
  async getUserIdeas(userId: string, page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;

    const [ideas, total] = await Promise.all([
      prisma.idea.findMany({
        where: { creatorId: userId },
        include: {
          _count: {
            select: { ratings: true, comments: true, invites: true },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.idea.count({
        where: { creatorId: userId },
      }),
    ]);

    return {
      ideas,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit),
      },
    };
  },
};
