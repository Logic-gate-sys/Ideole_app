import { prisma } from "../lib/prisma.ts";


export interface CreateCommentInput {
  content: string;
  ideaId: string;
  userId: string;
}

export const CommentService = {
  /**
   * Create a new comment
   * @throws Error if user doesn't have access to the idea
   */
  async createComment(input: CreateCommentInput) {
    const idea = await prisma.idea.findUnique({
      where: { id: input.ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    // Check if user has access (is creator, invited, or idea is public)
    if (!idea.isPublic && idea.creatorId !== input.userId) {
      const invite = await prisma.ideaInvite.findFirst({
        where: {
          ideaId: input.ideaId,
          reviewerId: input.userId,
        },
      });

      if (!invite) {
        throw new Error('You do not have permission to comment on this idea');
      }
    }

    return prisma.ideaComment.create({
      data: {
        content: input.content,
        ideaId: input.ideaId,
        userId: input.userId,
      },
      include: {
        user: { select: { id: true, name: true } },
      },
    });
  },

  /**
   * Get all comments for an idea
   */
  async getIdeaComments(ideaId: string, page: number = 1, limit: number = 20) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    const skip = (page - 1) * limit;

    const [comments, total] = await Promise.all([
      prisma.ideaComment.findMany({
        where: { ideaId },
        include: {
          user: { select: { id: true, name: true } },
        },
        orderBy: { createdAt: 'asc' },
        skip,
        take: limit,
      }),
      prisma.ideaComment.count({
        where: { ideaId },
      }),
    ]);

    return {
      comments,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit),
      },
    };
  },

  /**
   * Get user's comments
   */
  async getUserComments(userId: string) {
    return prisma.ideaComment.findMany({
      where: { userId },
      include: {
        idea: { select: { id: true, title: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },

  /**
   * Delete a comment (only creator or idea creator can delete)
   */
  async deleteComment(commentId: string, userId: string) {
    const comment = await prisma.ideaComment.findUnique({
      where: { id: commentId },
      include: { idea: true },
    });

    if (!comment) {
      throw new Error('Comment not found');
    }

    if (comment.userId !== userId && comment.idea.creatorId !== userId) {
      throw new Error('You do not have permission to delete this comment');
    }

    return prisma.ideaComment.delete({
      where: { id: commentId },
    });
  },
};
