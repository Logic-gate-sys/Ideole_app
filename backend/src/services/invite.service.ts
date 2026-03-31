import { prisma } from "../lib/prisma.ts";

export interface CreateInviteInput {
  ideaId: string;
  reviewerId: string;
  creatorId: string;
}

export const InviteService = {
  /**
   * Create an invitation for a reviewer
   * @throws Error if already invited or invalid inputs
   */
  async sendInvite(input: CreateInviteInput) {
    const idea = await prisma.idea.findUnique({
      where: { id: input.ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.creatorId !== input.creatorId) {
      throw new Error('Only the creator can invite reviewers');
    }

    if (idea.creatorId === input.reviewerId) {
      throw new Error('Cannot invite yourself');
    }

    const reviewer = await prisma.user.findUnique({
      where: { id: input.reviewerId },
    });

    if (!reviewer) {
      throw new Error('Reviewer not found');
    }

    // Check if already invited
    const existingInvite = await prisma.ideaInvite.findFirst({
      where: {
        ideaId: input.ideaId,
        reviewerId: input.reviewerId,
      },
    });

    if (existingInvite) {
      throw new Error('User has already been invited for this idea');
    }

    return prisma.ideaInvite.create({
      data: {
        ideaId: input.ideaId,
        reviewerId: input.reviewerId,
      },
      include: {
        reviewer: { select: { id: true, name: true, email: true } },
        idea: { select: { id: true, title: true } },
      },
    });
  },

  /**
   * Accept an invitation
   */
  async acceptInvite(inviteId: string, userId: string) {
    const invite = await prisma.ideaInvite.findUnique({
      where: { id: inviteId },
    });

    if (!invite) {
      throw new Error('Invite not found');
    }

    if (invite.reviewerId !== userId) {
      throw new Error('Cannot accept invite for another user');
    }

    return prisma.ideaInvite.update({
      where: { id: inviteId },
      data: { status: 'ACCEPTED' },
      include: {
        idea: { select: { id: true, title: true } },
        reviewer: { select: { id: true, name: true } },
      },
    });
  },

  /**
   * Get all invites for an idea
   */
  async getIdeaInvites(ideaId: string, creatorId: string) {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    if (idea.creatorId !== creatorId) {
      throw new Error('Only the creator can view invites');
    }

    return prisma.ideaInvite.findMany({
      where: { ideaId },
      include: {
        reviewer: { select: { id: true, name: true, email: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },

  /**
   * Get invites received by a user
   */
  async getUserInvites(userId: string) {
    return prisma.ideaInvite.findMany({
      where: { reviewerId: userId },
      include: {
        idea: { select: { id: true, title: true, creator: { select: { id: true, name: true } } } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },

  /**
   * Get pending invites for a user
   */
  async getPendingInvites(userId: string) {
    return prisma.ideaInvite.findMany({
      where: {
        reviewerId: userId,
        status: 'PENDING',
      },
      include: {
        idea: { select: { id: true, title: true, creator: { select: { name: true } } } },
      },
      orderBy: { createdAt: 'desc' },
    });
  },
};
