import { prisma } from '../lib/prisma.ts';

type NotificationItem = {
  id: string;
  type: 'INVITE' | 'COMMENT' | 'RATING';
  title: string;
  message: string;
  createdAt: Date;
  metadata: Record<string, unknown>;
};

function mapInviteStatus(status: string): string {
  switch (status) {
    case 'ACTIVE':
      return 'accepted';
    case 'BANNED':
      return 'declined';
    case 'DORMANT':
      return 'cancelled';
    case 'PENDING':
    default:
      return 'pending';
  }
}

export const NotificationService = {
  async getUserNotifications(userId: string, limit = 50) {
    const sanitizedLimit = Math.min(Math.max(limit, 1), 100);

    const [invites, comments, ratings] = await Promise.all([
      prisma.ideaInvite.findMany({
        where: {
          reviewerId: userId,
        },
        include: {
          idea: {
            select: {
              id: true,
              title: true,
            },
          },
        },
        orderBy: {
          createdAt: 'desc',
        },
        take: sanitizedLimit,
      }),
      prisma.ideaComment.findMany({
        where: {
          idea: {
            ownerId: userId,
          },
          userId: {
            not: userId,
          },
        },
        include: {
          idea: {
            select: {
              id: true,
              title: true,
            },
          },
          user: {
            select: {
              id: true,
              username: true,
            },
          },
        },
        orderBy: {
          createdAt: 'desc',
        },
        take: sanitizedLimit,
      }),
      prisma.ideaRating.findMany({
        where: {
          idea: {
            ownerId: userId,
          },
          authorId: {
            not: userId,
          },
          isLatest: true,
        },
        include: {
          idea: {
            select: {
              id: true,
              title: true,
            },
          },
          author: {
            select: {
              id: true,
              username: true,
            },
          },
        },
        orderBy: {
          createdAt: 'desc',
        },
        take: sanitizedLimit,
      }),
    ]);

    const notifications: NotificationItem[] = [];

    for (const invite of invites) {
      notifications.push({
        id: `invite-${invite.id}`,
        type: 'INVITE',
        title: 'Collaboration Invite',
        message: `Invite for "${invite.idea.title}" is ${mapInviteStatus(invite.status)}.`,
        createdAt: invite.createdAt,
        metadata: {
          inviteId: invite.id,
          ideaId: invite.ideaId,
          status: invite.status,
        },
      });
    }

    for (const comment of comments) {
      notifications.push({
        id: `comment-${comment.id}`,
        type: 'COMMENT',
        title: 'New Comment',
        message: `${comment.user.username} commented on "${comment.idea.title}".`,
        createdAt: comment.createdAt,
        metadata: {
          commentId: comment.id,
          ideaId: comment.idea.id,
          commenterId: comment.user.id,
        },
      });
    }

    for (const rating of ratings) {
      notifications.push({
        id: `rating-${rating.id}`,
        type: 'RATING',
        title: 'New Rating',
        message: `${rating.author.username} rated "${rating.idea.title}".`,
        createdAt: rating.createdAt,
        metadata: {
          ratingId: rating.id,
          ideaId: rating.idea.id,
          reviewerId: rating.author.id,
        },
      });
    }

    notifications.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
    return notifications.slice(0, sanitizedLimit);
  },
};
