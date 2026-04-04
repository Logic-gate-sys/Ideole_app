import { prisma } from '../lib/prisma.ts';
import type { CreateOrganisationInput, UpdateOrganisationInput } from '../schema/organisation.schema.ts';

export const OrganisationService = {
  async createOrganisation(input: CreateOrganisationInput, ownerId: string) {
    const org = await prisma.organisation.create({
      data: {
        name: input.name,
        tier: input.tier || 'starter',
        ownerId,
      },
    });

    return org;
  },

  async getOrganisation(organisationId: string) {
    const org = await prisma.organisation.findUnique({
      where: { id: organisationId },
      include: {
        communities: true,
      },
    });

    if (!org) {
      throw new Error('Organisation not found');
    }

    return org;
  },

  async listOrganisations(ownerId: string) {
    const orgs = await prisma.organisation.findMany({
      where: { ownerId },
      include: {
        communities: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    return orgs;
  },

  async updateOrganisation(organisationId: string, ownerId: string, input: UpdateOrganisationInput) {
    const org = await prisma.organisation.findUnique({
      where: { id: organisationId },
    });

    if (!org) {
      throw new Error('Organisation not found');
    }

    if (org.ownerId !== ownerId) {
      throw new Error('Unauthorized: You do not own this organisation');
    }

    const updated = await prisma.organisation.update({
      where: { id: organisationId },
      data: {
        ...(input.name && { name: input.name }),
        ...(input.tier && { tier: input.tier }),
        ...(input.maxCommunities && { maxCommunities: input.maxCommunities }),
      },
    });

    return updated;
  },

  async deleteOrganisation(organisationId: string, ownerId: string) {
    const org = await prisma.organisation.findUnique({
      where: { id: organisationId },
    });

    if (!org) {
      throw new Error('Organisation not found');
    }

    if (org.ownerId !== ownerId) {
      throw new Error('Unauthorized: You do not own this organisation');
    }

    await prisma.organisation.delete({
      where: { id: organisationId },
    });

    return { success: true };
  },
};
