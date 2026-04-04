import { describe, it, expect, beforeEach } from 'vitest';
import { prisma } from '../../src/lib/prisma.ts';
import { createTestUser } from '../helpers/testHelpers.ts';

describe('Organisation Service', () => {
  let testOrgData: any;
  let user: any;

  beforeEach(async () => {
    user = await createTestUser();
    testOrgData = {
      name: 'Test Org',
      tier: 'starter',
      ownerId: user.id,
    };
  });

  describe('createOrganisation', () => {
    it('should create a new organisation', async () => {
      const org = await prisma.organisation.create({
        data: testOrgData,
      });

      expect(org).toBeDefined();
      expect(org.name).toBe(testOrgData.name);
      expect(org.ownerId).toBe(user.id);
      expect(org.tier).toBe('starter');
      expect(org.maxCommunities).toBe(5);
    });

    it('should assign default tier when not provided', async () => {
      const org = await prisma.organisation.create({
        data: {
          name: 'Another Org',
          ownerId: user.id,
        },
      });

      expect(org.tier).toBe('starter');
      expect(org.maxCommunities).toBe(5);
    });
  });

  describe('getOrganisation', () => {
    it('should retrieve organisation by id', async () => {
      const created = await prisma.organisation.create({
        data: testOrgData,
      });

      const retrieved = await prisma.organisation.findUnique({
        where: { id: created.id },
      });

      expect(retrieved).toBeDefined();
      expect(retrieved?.id).toBe(created.id);
      expect(retrieved?.name).toBe(testOrgData.name);
    });

    it('should return null if organisation does not exist', async () => {
      const retrieved = await prisma.organisation.findUnique({
        where: { id: 'nonexistent' },
      });

      expect(retrieved).toBeNull();
    });
  });

  describe('listOrganisations', () => {
    it('should list all organisations owned by user', async () => {
      await prisma.organisation.create({
        data: { ...testOrgData, name: 'Org 1' },
      });
      await prisma.organisation.create({
        data: { ...testOrgData, name: 'Org 2' },
      });

      const orgs = await prisma.organisation.findMany({
        where: { ownerId: user.id },
      });

      expect(orgs).toHaveLength(2);
      expect(orgs.map(o => o.name)).toContain('Org 1');
      expect(orgs.map(o => o.name)).toContain('Org 2');
    });

    it('should only return user\'s own organisations', async () => {
      const otherUser = await createTestUser({ username: 'other', email: 'other@test.com' });

      await prisma.organisation.create({
        data: { ...testOrgData, name: 'User Org' },
      });
      await prisma.organisation.create({
        data: { ...testOrgData, name: 'Other Org', ownerId: otherUser.id },
      });

      const userOrgs = await prisma.organisation.findMany({
        where: { ownerId: user.id },
      });

      expect(userOrgs).toHaveLength(1);
      expect(userOrgs[0].name).toBe('User Org');
    });
  });

  describe('updateOrganisation', () => {
    it('should update organisation', async () => {
      const created = await prisma.organisation.create({
        data: testOrgData,
      });

      const updated = await prisma.organisation.update({
        where: { id: created.id },
        data: { name: 'Updated Org', tier: 'premium' },
      });

      expect(updated.name).toBe('Updated Org');
      expect(updated.tier).toBe('premium');
      expect(updated.ownerId).toBe(user.id);
    });
  });

  describe('deleteOrganisation', () => {
    it('should delete organisation', async () => {
      const created = await prisma.organisation.create({
        data: testOrgData,
      });

      const deleted = await prisma.organisation.delete({
        where: { id: created.id },
      });

      expect(deleted.id).toBe(created.id);

      const retrieved = await prisma.organisation.findUnique({
        where: { id: created.id },
      });

      expect(retrieved).toBeNull();
    });
  });
});
