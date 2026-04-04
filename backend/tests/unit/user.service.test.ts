import { describe, it, expect, beforeEach } from 'vitest';
import { UserService } from '../../src/services/user.service.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('User Service', () => {
  let user: any;
  let testUser2: any;

  beforeEach(async () => {
    user = await createTestUser({}, 'access');
    testUser2 = await createTestUser({ username: 'user2', email: 'user2@test.com' }, 'access');
  });

  describe('getUserProfile', () => {
    it('should get user profile by id', async () => {
      const profile = await UserService.getUserProfile(user.id);

      expect(profile.id).toBe(user.id);
      expect(profile.username).toBe(user.username);
      expect(profile.email).toBe(user.email);
    });

    it('should throw error for non-existent user', async () => {
      await expect(
        UserService.getUserProfile('nonexistent')
      ).rejects.toThrow('User not found');
    });
  });

  describe('updateUserProfile', () => {
    it('should update username', async () => {
      const updated = await UserService.updateUserProfile(user.id, {
        username: 'newusername',
      });

      expect(updated.username).toBe('newusername');
    });

    it('should update email', async () => {
      const updated = await UserService.updateUserProfile(user.id, {
        email: 'newemail@test.com',
      });

      expect(updated.email).toBe('newemail@test.com');
    });

    it('should update profileUrl', async () => {
      const updated = await UserService.updateUserProfile(user.id, {
        profileUrl: 'https://example.com/profile.jpg',
      });

      expect(updated.profileUrl).toBe('https://example.com/profile.jpg');
    });

    it('should reject duplicate email', async () => {
      await expect(
        UserService.updateUserProfile(user.id, {
          email: testUser2.email,
        })
      ).rejects.toThrow('Email already in use');
    });

    it('should reject duplicate username', async () => {
      await expect(
        UserService.updateUserProfile(user.id, {
          username: testUser2.username,
        })
      ).rejects.toThrow('Username already taken');
    });

    it('should allow user to update their own email', async () => {
      const updated = await UserService.updateUserProfile(user.id, {
        email: user.email, // Same email
      });

      expect(updated.email).toBe(user.email);
    });

    it('should update multiple fields at once', async () => {
      const updated = await UserService.updateUserProfile(user.id, {
        username: 'newusername',
        email: 'newemail@test.com',
        profileUrl: 'https://example.com/profile.jpg',
      });

      expect(updated.username).toBe('newusername');
      expect(updated.email).toBe('newemail@test.com');
      expect(updated.profileUrl).toBe('https://example.com/profile.jpg');
    });
  });

  describe('updateLastActive', () => {
    it('should update last active timestamp', async () => {
      const before = new Date();
      const result = await UserService.updateLastActive(user.id);
      const after = new Date();

      expect(result.lastActive).toBeDefined();
      expect(result.lastActive.getTime()).toBeGreaterThanOrEqual(before.getTime());
      expect(result.lastActive.getTime()).toBeLessThanOrEqual(after.getTime());
    });
  });

  describe('getUserMemberships', () => {
    it('should return empty memberships for new user', async () => {
      const memberships = await UserService.getUserMemberships(user.id);

      expect(Array.isArray(memberships)).toBe(true);
      expect(memberships).toHaveLength(0);
    });

    it('should return user memberships', async () => {
      // Create organisation and community
      const org = await prisma.organisation.create({
        data: {
          name: 'Test Org',
          ownerId: user.id,
        },
      });

      const community = await prisma.community.create({
        data: {
          name: 'Test Community',
          adminId: user.id,
          organisationId: org.id,
        },
      });

      // Add membership
      await prisma.membership.create({
        data: {
          userId: user.id,
          communityId: community.id,
          organisationId: org.id,
        },
      });

      const memberships = await UserService.getUserMemberships(user.id);

      expect(memberships).toHaveLength(1);
      expect(memberships[0].communityId).toBe(community.id);
      expect(memberships[0].community.organisationId).toBe(org.id);
    });

    it('should return memberships sorted by join date desc', async () => {
      const org = await prisma.organisation.create({
        data: {
          name: 'Test Org',
          ownerId: user.id,
        },
      });

      const community1 = await prisma.community.create({
        data: {
          name: 'Community 1',
          adminId: user.id,
          organisationId: org.id,
        },
      });

      const community2 = await prisma.community.create({
        data: {
          name: 'Community 2',
          adminId: user.id,
          organisationId: org.id,
        },
      });

      await prisma.membership.create({
        data: {
          userId: user.id,
          communityId: community1.id,
          organisationId: org.id,
        },
      });

      // Wait a bit to ensure different timestamps
      await new Promise(resolve => setTimeout(resolve, 100));

      await prisma.membership.create({
        data: {
          userId: user.id,
          communityId: community2.id,
          organisationId: org.id,
        },
      });

      const memberships = await UserService.getUserMemberships(user.id);

      expect(memberships).toHaveLength(2);
      expect(memberships[0].communityId).toBe(community2.id); // Most recent first
      expect(memberships[1].communityId).toBe(community1.id);
    });
  });

  describe('getUserIdeas', () => {
    it('should return empty ideas for new user', async () => {
      const ideas = await UserService.getUserIdeas(user.id);

      expect(Array.isArray(ideas)).toBe(true);
      expect(ideas).toHaveLength(0);
    });

    it('should return user ideas', async () => {
      const idea1 = await prisma.idea.create({
        data: {
          title: 'Idea 1',
          description: 'Description 1',
          ownerId: user.id,
        },
      });

      const idea2 = await prisma.idea.create({
        data: {
          title: 'Idea 2',
          description: 'Description 2',
          ownerId: user.id,
        },
      });

      const ideas = await UserService.getUserIdeas(user.id);

      expect(ideas).toHaveLength(2);
      expect(ideas.map((i) => i.id)).toContain(idea1.id);
      expect(ideas.map((i) => i.id)).toContain(idea2.id);
    });

    it('should only return user own ideas', async () => {
      const userIdea = await prisma.idea.create({
        data: {
          title: 'User Idea',
          description: 'Description',
          ownerId: user.id,
        },
      });

      await prisma.idea.create({
        data: {
          title: 'Other Idea',
          description: 'Description',
          ownerId: testUser2.id,
        },
      });

      const ideas = await UserService.getUserIdeas(user.id);

      expect(ideas).toHaveLength(1);
      expect(ideas[0].id).toBe(userIdea.id);
    });

    it('should return ideas sorted by creation date desc', async () => {
      const idea1 = await prisma.idea.create({
        data: {
          title: 'Idea 1',
          description: 'Description 1',
          ownerId: user.id,
        },
      });

      // Wait a bit to ensure different timestamps
      await new Promise(resolve => setTimeout(resolve, 100));

      const idea2 = await prisma.idea.create({
        data: {
          title: 'Idea 2',
          description: 'Description 2',
          ownerId: user.id,
        },
      });

      const ideas = await UserService.getUserIdeas(user.id);

      expect(ideas).toHaveLength(2);
      expect(ideas[0].id).toBe(idea2.id); // Most recent first
      expect(ideas[1].id).toBe(idea1.id);
    });

    it('should include criteria in ideas', async () => {
      const idea = await prisma.idea.create({
        data: {
          title: 'Idea with criteria',
          description: 'Description',
          ownerId: user.id,
          criteria: {
            create: [
              { name: 'Criterion 1', description: 'Desc 1', order: 1 },
              { name: 'Criterion 2', description: 'Desc 2', order: 2 },
            ],
          },
        },
      });

      const ideas = await UserService.getUserIdeas(user.id);

      expect(ideas[0].criteria).toHaveLength(2);
      expect(ideas[0].criteria.map((c) => c.name)).toContain('Criterion 1');
      expect(ideas[0].criteria.map((c) => c.name)).toContain('Criterion 2');
    });
  });
});
