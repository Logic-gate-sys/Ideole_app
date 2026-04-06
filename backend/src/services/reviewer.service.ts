import { prisma } from '../lib/prisma.ts';
import type { User, IdeaInvite } from '@prisma/client';

export const ReviewerService = {
  /**
   * Get all reviewers for an idea (both active and pending)
   */
  async getIdeaReviewers(ideaId: string) {
    // Get all invites for this idea (active = joined, pending = pending)
    const invites = await prisma.ideaInvite.findMany({
      where: { ideaId },
      include: {
        reviewer: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    // Transform to match mobile app expectations
    return invites.map((invite) => ({
      id: invite.reviewer.id,
      name: invite.reviewer.name,
      email: invite.reviewer.email,
      role: 'Reviewer', // TODO: Add role field to IdeaInvite model if needed
      expertise: 'Expert', // TODO: Add expertise field to User profile
      status: invite.status.toLowerCase(),
      joinedDate: invite.status === 'ACCEPTED' ? invite.createdAt : null,
      invitedDate: invite.status === 'PENDING' ? invite.createdAt : null,
    }));
  },

  /**
   * Get a specific reviewer invite
   */
  async getReviewerInvite(ideaId: string, reviewerId: string) {
    return await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
      include: {
        reviewer: true,
      },
    });
  },

  /**
   * Check if user has access to manage reviewers (idea owner or organisation admin)
   */
  async canManageReviewers(ideaId: string, userId: string): Promise<boolean> {
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
      select: {
        createdById: true,
        organisationId: true,
      },
    });

    if (!idea) {
      return false;
    }

    // Check if user is idea owner
    if (idea.createdById === userId) {
      return true;
    }

    // Check if user is organisation admin (if applicable)
    if (idea.organisationId) {
      const member = await prisma.membership.findUnique({
        where: {
          userId_organisationId: {
            userId,
            organisationId: idea.organisationId,
          },
        },
      });

      return member?.role === 'ADMIN';
    }

    return false;
  },

  /**
   * Remove a reviewer from an idea
   */
  async removeReviewer(ideaId: string, reviewerId: string) {
    const result = await prisma.ideaInvite.delete({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    return result;
  },

  /**
   * Resend invitation to a pending reviewer
   */
  async resendInvitation(ideaId: string, reviewerId: string) {
    // Verify the invite exists and is pending
    const invite = await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    if (!invite) {
      throw new Error('Reviewer invitation not found');
    }

    if (invite.status !== 'PENDING') {
      throw new Error('Can only resend pending invitations');
    }

    // Update the createdAt timestamp to mark as recently resent
    // In a real app, you'd send an email notification here
    const updated = await prisma.ideaInvite.update({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
      data: {
        createdAt: new Date(), // Mark as recently updated
      },
    });

    return updated;
  },

  /**
   * Cancel a pending invitation
   */
  async cancelInvitation(ideaId: string, reviewerId: string) {
    const invite = await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    if (!invite) {
      throw new Error('Reviewer invitation not found');
    }

    if (invite.status !== 'PENDING') {
      throw new Error('Can only cancel pending invitations');
    }

    return await prisma.ideaInvite.delete({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });
  },

  /**
   * Create a new reviewer invitation
   */
  async inviteReviewer(ideaId: string, reviewerId: string) {
    // Check if invite already exists
    const existing = await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    if (existing) {
      throw new Error('This user is already invited or reviewing this idea');
    }

    // Verify idea exists
    const idea = await prisma.idea.findUnique({
      where: { id: ideaId },
    });

    if (!idea) {
      throw new Error('Idea not found');
    }

    // Verify reviewer exists
    const reviewer = await prisma.user.findUnique({
      where: { id: reviewerId },
    });

    if (!reviewer) {
      throw new Error('Reviewer not found');
    }

    // Create invitation
    return await prisma.ideaInvite.create({
      data: {
        ideaId,
        reviewerId,
        status: 'PENDING',
      },
      include: {
        reviewer: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
    });
  },

  /**
   * Accept reviewer invitation
   */
  async acceptInvitation(ideaId: string, reviewerId: string) {
    const invite = await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    if (!invite) {
      throw new Error('Reviewer invitation not found');
    }

    return await prisma.ideaInvite.update({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
      data: {
        status: 'ACCEPTED',
      },
    });
  },

  /**
   * Decline reviewer invitation
   */
  async declineInvitation(ideaId: string, reviewerId: string) {
    const invite = await prisma.ideaInvite.findUnique({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
    });

    if (!invite) {
      throw new Error('Reviewer invitation not found');
    }

    return await prisma.ideaInvite.update({
      where: {
        ideaId_reviewerId: { ideaId, reviewerId },
      },
      data: {
        status: 'DECLINED',
      },
    });
  }
};
