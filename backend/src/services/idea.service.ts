import { prisma } from '../lib/prisma.ts';
import type { Visibility, Stage } from '../../prisma/generated/client.ts';

export const IdeaService = {
  async createIdea(
    userId: string,
    data: {
      title: string;
      description: string;
      visibility: Visibility;
      communityId?: string;
      organisationId?: string;
      criteria?: Array<{ name: string; description: string }>;
    }
  ) {
    // If communityId provided, verify user is a member
    if (data.communityId) {
      const membership = await prisma.membership.findUnique({
        where: {
          userId_communityId: {
            userId,
            communityId: data.communityId,
          },
        },
      });

      if (!membership || membership.status !== 'ACTIVE') {
        throw new Error('User must be an active member of the community');
      }
    }

    // Create the idea
    const idea = await prisma.idea.create({
      data: {
        title: data.title,
        description: data.description,
        visibility: data.visibility,
        stage: 'INCEPTION',
        ownerId: userId,
        communityId: data.communityId,
        organisationId: data.organisationId,
      },
      include: {
        criteria: {
          select: {
            id: true,
            name: true,
            description: true,
            order: true,
          },
        },
      },
    });

    // Create evaluation criteria if provided
    if (data.criteria && data.criteria.length > 0) {
      await Promise.all(
        data.criteria.map((c, index) =>
          prisma.evaluationCriteria.create({
            data: {
              name: c.name,
              description: c.description,
              ideaId: idea.id,
              order: index,
            },
          })
        )
      );

      // Refetch idea with criteria
      return prisma.idea.findUnique({
        where: { id: idea.id },
        include: {
          criteria: {
            select: {
              id: true,
              name: true,
              description: true,
              order: true,
            },
          },
        },
      });
    }

    return idea;
  },

  async getIdeaById(ideaId: string, userId?: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
        criteria: {
          select: {
            id: true,
            name: true,
            description: true,
            order: true,
          },
          orderBy: { order: 'asc' },
        },
      },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    console.log('DEBUG getIdeaById:', {
      visibility: idea.visibility,
      ownerId: idea.ownerId,
      userId,
      communityId: idea.communityId,
    });

    // Check visibility permissions
    if (idea.visibility === 'PRIVATE' && idea.ownerId !== userId) {
      throw new Error('Unauthorized: Cannot access private idea');
    }

    if (idea.visibility === 'PROTECTED') {
      // PROTECTED ideas are only accessible to community members
      if (idea.communityId) {
        if (!userId) {
          throw new Error('Unauthorized: Must be authenticated to access protected idea');
        }

        const membership = await prisma.membership.findUnique({
          where: {
            userId_communityId: {
              userId,
              communityId: idea.communityId,
            },
          },
        });

        if (!membership) {
          throw new Error('Unauthorized: Must be community member to access protected idea');
        }
      }
    }

    // Get rating counts and comment count
    const [ratingCount, commentCount] = await Promise.all([
      prisma.ideaRating.count({
        where: { ideaId },
      }),
      prisma.ideaComment.count({
        where: { ideaId },
      }),
    ]);

    return { ...idea, ratingCount, commentCount };
  },

  async getAllIdeas(
    filters?: {
      visibility?: Visibility;
      communityId?: string;
      organisationId?: string;
      stage?: Stage;
      sortBy?: 'recent' | 'popular';
      limit?: number;
      offset?: number;
    },
    userId?: string
  ) {
    const limit = filters?.limit || 10;
    const offset = filters?.offset || 0;

    const where: any = {};

    if (filters?.visibility) {
      where.visibility = filters.visibility;
    } else {
      // Default: only show PUBLIC ideas to non-authenticated, PUBLIC+PROTECTED for authenticated
      where.visibility = userId ? { in: ['PUBLIC', 'PROTECTED'] } : 'PUBLIC';
    }

    if (filters?.communityId) {
      where.communityId = filters.communityId;
    }
    if (filters?.organisationId) {
      where.organisationId = filters.organisationId;
    }
    if (filters?.stage) {
      where.stage = filters.stage;
    }

    const orderBy: any = {};
    if (filters?.sortBy === 'popular') {
      // Sort by rating count (would need a separate count, so use createdAt for now)
      orderBy.createdAt = 'desc';
    } else {
      orderBy.createdAt = 'desc';
    }

    const [ideas, total] = await Promise.all([
      prisma.idea.findMany({
        where,
        include: {
          owner: {
            select: {
              id: true,
              username: true,
              profileUrl: true,
            },
          },
          criteria: {
            select: {
              id: true,
              name: true,
            },
          },
        },
        orderBy,
        take: limit,
        skip: offset,
      }),
      prisma.idea.count({ where }),
    ]);

    return {
      ideas,
      total,
      page: Math.floor(offset / limit) + 1,
    };
  },

  async updateIdea(
    ideaId: string,
    userId: string,
    data: {
      title?: string;
      description?: string;
      visibility?: Visibility;
      stage?: Stage;
    }
  ) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only idea owner can update');
    }

    return prisma.idea.update({
      where: { id: ideaId },
      data,
      include: {
        owner: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
        criteria: {
          select: {
            id: true,
            name: true,
            description: true,
            order: true,
          },
          orderBy: { order: 'asc' },
        },
      },
    });
  },

  async deleteIdea(ideaId: string, userId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only idea owner can delete');
    }

    await prisma.idea.delete({
      where: { id: ideaId },
    });

    return { success: true };
  },

  // Evaluation Criteria Management
  async getIdeaCriteria(ideaId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    return prisma.evaluationCriteria.findMany({
      where: { ideaId },
      orderBy: { order: 'asc' },
    });
  },

  async createCriteria(
    ideaId: string,
    userId: string,
    data: {
      name: string;
      description: string;
    }
  ) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only idea owner can create criteria');
    }

    if (idea.stage !== 'INCEPTION') {
      throw new Error('Cannot add criteria after INCEPTION stage');
    }

    // Get current max order
    const maxOrder = await prisma.evaluationCriteria.findFirst({
      where: { ideaId },
      orderBy: { order: 'desc' },
      select: { order: true },
    });

    return prisma.evaluationCriteria.create({
      data: {
        name: data.name,
        description: data.description,
        ideaId,
        order: (maxOrder?.order || -1) + 1,
      },
    });
  },

  async updateCriteria(
    ideaId: string,
    criteriaId: string,
    userId: string,
    data: {
      name?: string;
      description?: string;
      order?: number;
    }
  ) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only idea owner can update criteria');
    }

    if (idea.stage !== 'INCEPTION') {
      throw new Error('Cannot update criteria after INCEPTION stage');
    }

    const criteria = await prisma.evaluationCriteria.findUnique({
      where: { id: criteriaId },
    });

    if (!criteria || criteria.ideaId !== ideaId) {
      throw new Error('Criteria not found');
    }

    return prisma.evaluationCriteria.update({
      where: { id: criteriaId },
      data,
    });
  },

  async deleteCriteria(ideaId: string, criteriaId: string, userId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only idea owner can delete criteria');
    }

    if (idea.stage !== 'INCEPTION') {
      throw new Error('Cannot delete criteria after INCEPTION stage');
    }

    const criteria = await prisma.evaluationCriteria.findUnique({
      where: { id: criteriaId },
    });

    if (!criteria || criteria.ideaId !== ideaId) {
      throw new Error('Criteria not found');
    }

    // Check if any ratings exist for this criteria
    const ratings = await prisma.ideaRating.count({
      where: { ideaId },
    });

    if (ratings > 0) {
      throw new Error('Cannot delete criteria when ratings exist');
    }

    await prisma.evaluationCriteria.delete({
      where: { id: criteriaId },
    });

    return { success: true };
  },
};
