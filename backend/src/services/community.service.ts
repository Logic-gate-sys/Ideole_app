import { prisma } from '../lib/prisma.ts';
import type { CreateCommunityInput, UpdateCommunityInput } from '../schema/community.schema.ts';

export const CommunityService = {
  async createCommunity(
    input: CreateCommunityInput,
    organisationId: string,
    adminId: string
  ) {
    const community = await prisma.community.create({
      data: {
        name: input.name,
        description: input.description || '',
        visibility: input.visibility || 'PRIVATE',
        organisationId,
        adminId,
      },
    });

    return community;
  },

  async getCommunity(communityId: string) {
    const community = await prisma.community.findUnique({
      where: { id: communityId },
      include: {
        admin: {
          select: { id: true, username: true, email: true },
        },
        memberships: {
          select: { userId: true, role: true, status: true },
        },
      },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    return community;
  },

  async listCommunities(organisationId: string) {
    const communities = await prisma.community.findMany({
      where: { organisationId },
      include: {
        admin: {
          select: { id: true, username: true, email: true },
        },
        memberships: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    return communities;
  },

  async updateCommunity(communityId: string, adminId: string, input: UpdateCommunityInput) {
    const community = await prisma.community.findUnique({
      where: { id: communityId },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    if (community.adminId !== adminId) {
      throw new Error('Only admin can update community');
    }

    const updated = await prisma.community.update({
      where: { id: communityId },
      data: {
        name: input.name || community.name,
        description: input.description !== undefined ? input.description : community.description,
        visibility: input.visibility || community.visibility,
      },
    });

    return updated;
  },

  async deleteCommunity(communityId: string, adminId: string) {
    const community = await prisma.community.findUnique({
      where: { id: communityId },
    });

    if (!community) {
      throw new Error('Community not found');
    }

    if (community.adminId !== adminId) {
      throw new Error('Only admin can delete community');
    }

    await prisma.community.delete({
      where: { id: communityId },
    });
  },
};
