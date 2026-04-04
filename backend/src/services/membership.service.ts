import { prisma } from '../lib/prisma.ts';

export const MembershipService = {
  async requestToJoinCommunity(userId: string, communityId: string) {
    // Check if community exists
    const community = await prisma.community.findUnique({
      where: { id: communityId },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    // Check if user is already a member
    const existingMembership = await prisma.membership.findUnique({
      where: {
        userId_communityId: {
          userId,
          communityId,
        },
      },
    });

    if (existingMembership) {
      throw new Error('User is already a member of this community');
    }

    // Create membership request with PENDING status
    const membership = await prisma.membership.create({
      data: {
        userId,
        communityId,
        organisationId: community.organisationId,
        status: 'PENDING',
        role: 'member',
      },
      include: {
        community: true,
      },
    });

    return membership;
  },

  async getPendingMembershipRequests(communityId: string, userId: string) {
    // Check if community exists
    const community = await prisma.community.findUnique({
      where: { id: communityId },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    // Check if user is admin of this community
    if (community.adminId !== userId) {
      throw new Error('Unauthorized: Only community admin can view pending requests');
    }

    const pendingMembers = await prisma.membership.findMany({
      where: {
        communityId,
        status: 'PENDING',
      },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            email: true,
            firstName: true,
            lastName: true,
            profileUrl: true,
          },
        },
      },
      orderBy: { joinedAt: 'asc' },
    });

    return pendingMembers;
  },

  async approveMembershipRequest(communityId: string, membershipId: string, userId: string) {
    // Get membership and check permissions
    const membership = await prisma.membership.findUnique({
      where: { id: membershipId },
      include: { community: true },
    });

    if (!membership) {
      throw new Error('Membership request not found');
    }

    if (membership.communityId !== communityId) {
      throw new Error('Membership does not belong to this community');
    }

    if (membership.community.adminId !== userId) {
      throw new Error('Unauthorized: Only community admin can approve requests');
    }

    // Update status to ACTIVE
    const updated = await prisma.membership.update({
      where: { id: membershipId },
      data: { status: 'ACTIVE' },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            email: true,
          },
        },
        community: true,
      },
    });

    return updated;
  },

  async rejectMembershipRequest(communityId: string, membershipId: string, userId: string) {
    // Get membership and check permissions
    const membership = await prisma.membership.findUnique({
      where: { id: membershipId },
      include: { community: true },
    });

    if (!membership) {
      throw new Error('Membership request not found');
    }

    if (membership.communityId !== communityId) {
      throw new Error('Membership does not belong to this community');
    }

    if (membership.community.adminId !== userId) {
      throw new Error('Unauthorized: Only community admin can reject requests');
    }

    // Delete the membership request
    await prisma.membership.delete({
      where: { id: membershipId },
    });

    return { success: true };
  },

  async removeMemberFromCommunity(communityId: string, membershipId: string, requestingUserId: string) {
    // Get membership and check permissions
    const membership = await prisma.membership.findUnique({
      where: { id: membershipId },
      include: { community: true },
    });

    if (!membership) {
      throw new Error('Membership not found');
    }

    if (membership.communityId !== communityId) {
      throw new Error('Membership does not belong to this community');
    }

    // Check if requestingUser is admin or the member themselves
    if (membership.community.adminId !== requestingUserId && membership.userId !== requestingUserId) {
      throw new Error('Unauthorized: Only admin or member can remove');
    }

    // Delete membership
    await prisma.membership.delete({
      where: { id: membershipId },
    });

    return { success: true };
  },

  async getCommunityMembers(communityId: string) {
    // Check if community exists
    const community = await prisma.community.findUnique({
      where: { id: communityId },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    const members = await prisma.membership.findMany({
      where: {
        communityId,
        status: 'ACTIVE',
      },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            email: true,
            firstName: true,
            lastName: true,
            profileUrl: true,
          },
        },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return members;
  },
};
