import type { Status } from '../../prisma/generated/client.ts';
import { prisma } from '../lib/prisma.ts';

type InviteResponseStatus = 'PENDING' | 'ACCEPTED' | 'DECLINED' | 'CANCELLED';

type InviteWithIdeaOwner = {
  id: string;
  ideaId: string;
  reviewerId: string;
  status: Status;
  createdAt: Date;
  idea: {
    ownerId: string;
  };
};

function toClientInviteStatus(status: Status): InviteResponseStatus {
  switch (status) {
    case 'ACTIVE':
      return 'ACCEPTED';
    case 'BANNED':
      return 'DECLINED';
    case 'DORMANT':
      return 'CANCELLED';
    case 'PENDING':
    default:
      return 'PENDING';
  }
}

function toDatabaseInviteStatus(status: 'ACCEPTED' | 'DECLINED' | 'CANCELLED'): Status {
  switch (status) {
    case 'ACCEPTED':
      return 'ACTIVE';
    case 'DECLINED':
      return 'BANNED';
    case 'CANCELLED':
      return 'DORMANT';
  }
}

function mapInvite(invite: InviteWithIdeaOwner, updatedAt?: Date) {
  return {
    id: invite.id,
    ideaId: invite.ideaId,
    invitedUserId: invite.reviewerId,
    invitedByUserId: invite.idea.ownerId,
    status: toClientInviteStatus(invite.status),
    createdAt: invite.createdAt,
    updatedAt: updatedAt ?? invite.createdAt,
  };
}

export const InviteService = {
  async sendInvite(ideaId: string, invitedByUserId: string, invitedUserId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      select: {
        id: true,
        ownerId: true,
      },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== invitedByUserId) {
      throw new Error('Unauthorized: Only the idea owner can send invites');
    }

    if (invitedUserId === invitedByUserId) {
      throw new Error('Cannot invite yourself to your own idea');
    }

    const invitedUser = await prisma.user.findUnique({
      where: { id: invitedUserId },
      select: { id: true },
    });

    if (!invitedUser) {
      throw new Error('Invited user not found');
    }

    const duplicateStatuses: Status[] = ['PENDING', 'ACTIVE'];
    const existingInvite = await prisma.ideaInvite.findFirst({
      where: {
        ideaId,
        reviewerId: invitedUserId,
        status: {
          in: duplicateStatuses,
        },
      },
    });

    if (existingInvite) {
      throw new Error('A pending or accepted invite already exists for this user');
    }

    const invite = await prisma.ideaInvite.create({
      data: {
        ideaId,
        reviewerId: invitedUserId,
        status: 'PENDING',
      },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
    });

    return mapInvite(invite);
  },

  async respondToInvite(
    ideaId: string,
    inviteId: string,
    userId: string,
    status: 'ACCEPTED' | 'DECLINED' | 'CANCELLED'
  ) {
    const invite = await prisma.ideaInvite.findUnique({
      where: { id: inviteId },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
    });

    if (!invite || invite.ideaId !== ideaId) {
      throw new Error('Invite not found');
    }

    if (invite.status !== 'PENDING') {
      throw new Error('Invite is no longer pending');
    }

    const inviteeResponding = invite.reviewerId === userId && status !== 'CANCELLED';
    const inviterCancelling = invite.idea.ownerId === userId && status === 'CANCELLED';

    if (!inviteeResponding && !inviterCancelling) {
      throw new Error('Unauthorized: You cannot update this invite');
    }

    const updatedInvite = await prisma.ideaInvite.update({
      where: { id: inviteId },
      data: {
        status: toDatabaseInviteStatus(status),
      },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
    });

    return mapInvite(updatedInvite, new Date());
  },

  async getIdeaInvites(ideaId: string, userId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      select: {
        id: true,
        ownerId: true,
      },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.ownerId !== userId) {
      throw new Error('Unauthorized: Only the idea owner can view invites');
    }

    const invites = await prisma.ideaInvite.findMany({
      where: { ideaId },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    return invites.map((invite) => mapInvite(invite));
  },

  async getUserInvites(userId: string) {
    const invites = await prisma.ideaInvite.findMany({
      where: {
        reviewerId: userId,
      },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    return invites.map((invite) => mapInvite(invite));
  },

  async getPendingInvites(userId: string) {
    const invites = await prisma.ideaInvite.findMany({
      where: {
        reviewerId: userId,
        status: 'PENDING',
      },
      include: {
        idea: {
          select: {
            ownerId: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    return invites.map((invite) => mapInvite(invite));
  },
};
