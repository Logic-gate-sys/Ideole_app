import { prisma } from '../lib/prisma.ts';
import { getAccessibleIdea } from './idea-access.service.ts';

type CommentRecord = {
  id: string;
  ideaId: string;
  userId: string;
  content: string;
  createdAt: Date;
  user: {
    id: string;
    username: string;
    profileUrl: string;
  };
};

function mapComment(comment: CommentRecord) {
  return {
    id: comment.id,
    ideaId: comment.ideaId,
    userId: comment.userId,
    userName: comment.user.username,
    content: comment.content,
    createdAt: comment.createdAt,
    user: {
      id: comment.user.id,
      name: comment.user.username,
      username: comment.user.username,
      profileUrl: comment.user.profileUrl,
    },
  };
}

export const CommentService = {
  async createComment(ideaId: string, userId: string, content: string) {
    await getAccessibleIdea(ideaId, userId);

    const comment = await prisma.ideaComment.create({
      data: {
        ideaId,
        userId,
        content,
      },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
      },
    });

    return mapComment(comment);
  },

  async getIdeaComments(
    ideaId: string,
    userId?: string,
    page = 1,
    limit = 20
  ) {
    await getAccessibleIdea(ideaId, userId);

    const sanitizedLimit = Math.min(Math.max(limit, 1), 50);
    const sanitizedPage = Math.max(page, 1);
    const skip = (sanitizedPage - 1) * sanitizedLimit;

    const comments = await prisma.ideaComment.findMany({
      where: {
        ideaId,
      },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
      take: sanitizedLimit,
      skip,
    });

    return comments.map(mapComment);
  },

  async deleteComment(
    ideaId: string,
    commentId: string,
    requestingUserId: string,
    requestingRole?: string
  ) {
    const comment = await prisma.ideaComment.findUnique({
      where: { id: commentId },
      select: {
        id: true,
        ideaId: true,
        userId: true,
      },
    });

    if (!comment || comment.ideaId !== ideaId) {
      throw new Error('Comment not found');
    }

    if (comment.userId !== requestingUserId && requestingRole !== 'ADMIN') {
      throw new Error('Unauthorized: Only comment owner can delete this comment');
    }

    await prisma.ideaComment.delete({
      where: { id: commentId },
    });

    return { success: true };
  },
};
