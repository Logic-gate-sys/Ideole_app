import { describe, it, expect, beforeEach } from 'vitest';
import { prisma } from '../../src/lib/prisma.ts';
import { createTestUser } from '../helpers/testHelpers.ts';

describe('Community Service', () => {
  let user: any;
  let organisation: any;

  beforeEach(async () => {
    user = await createTestUser();
    organisation = await prisma.organisation.create({
      data: {
        name: 'Test Org',
        ownerId: user.id,
      },
    });
  });

  describe('createCommunity', () => {
    it('should create a new community', async () => {
      const community = await prisma.community.create({
        data: {
          name: 'Test Community',
          description: 'A test community',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });

      expect(community).toBeDefined();
      expect(community.name).toBe('Test Community');
      expect(community.visibility).toBe('PRIVATE');
      expect(community.status).toBe('ACTIVE');
      expect(community.adminId).toBe(user.id);
    });
  });

  describe('getCommunity', () => {
    it('should retrieve community by id', async () => {
      const created = await prisma.community.create({
        data: {
          name: 'Test Community',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });

      const retrieved = await prisma.community.findUnique({
        where: { id: created.id },
      });

      expect(retrieved).toBeDefined();
      expect(retrieved?.id).toBe(created.id);
      expect(retrieved?.name).toBe('Test Community');
    });

    it('should return null if community does not exist', async () => {
      const retrieved = await prisma.community.findUnique({
        where: { id: 'nonexistent' },
      });

      expect(retrieved).toBeNull();
    });
  });

  describe('listCommunities', () => {
    it('should list all communities in an organisation', async () => {
      await prisma.community.create({
        data: {
          name: 'Community 1',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });
      await prisma.community.create({
        data: {
          name: 'Community 2',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });

      const communities = await prisma.community.findMany({
        where: { organisationId: organisation.id },
      });

      expect(communities).toHaveLength(2);
    });

    it('should return empty array if no communities exist', async () => {
      const communities = await prisma.community.findMany({
        where: { organisationId: organisation.id },
      });

      expect(communities).toHaveLength(0);
    });
  });

  describe('updateCommunity', () => {
    it('should update community', async () => {
      const created = await prisma.community.create({
        data: {
          name: 'Original Name',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });

      const updated = await prisma.community.update({
        where: { id: created.id },
        data: {
          name: 'Updated Name',
          visibility: 'PUBLIC',
        },
      });

      expect(updated.name).toBe('Updated Name');
      expect(updated.visibility).toBe('PUBLIC');
    });
  });

  describe('deleteCommunity', () => {
    it('should delete community', async () => {
      const created = await prisma.community.create({
        data: {
          name: 'To Delete',
          organisationId: organisation.id,
          adminId: user.id,
        },
      });

      await prisma.community.delete({
        where: { id: created.id },
      });

      const result = await prisma.community.findUnique({
        where: { id: created.id },
      });

      expect(result).toBeNull();
    });
  });
});
