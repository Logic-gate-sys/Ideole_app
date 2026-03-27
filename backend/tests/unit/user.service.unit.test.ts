import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { TestHelpers } from '../helpers/test-helpers.ts';
import { UserService } from '../../src/services/user.service.ts';
import { prisma } from '../../src/lib/prisma.ts';
import bcrypt from 'bcrypt';

describe('UserService - Unit Tests', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('createUser', () => {
    it('should create a new user successfully', async () => {
      const hashedPassword = await bcrypt.hash('TestPassword123', 10);

      const result = await UserService.createUser({
        name: 'John Doe',
        email: 'john@example.com',
        passwordHash: hashedPassword,
      });

      expect(result).toBeDefined();
      expect(result.name).toBe('John Doe');
      expect(result.email).toBe('john@example.com');
      expect(result.id).toBeDefined();
    });

    it('should throw error if email already exists', async () => {
      const email = 'john@example.com';
      const hashedPassword = await bcrypt.hash('TestPassword123', 10);

      // Create first user
      await UserService.createUser({
        name: 'John Doe',
        email,
        passwordHash: hashedPassword,
      });

      // Try to create another with same email
      await expect(
        UserService.createUser({
          name: 'Jane Doe',
          email,
          passwordHash: hashedPassword,
        })
      ).rejects.toThrow('User with this email already exists');
    });
  });

  describe('getUserByEmail', () => {
    it('should retrieve user by email', async () => {
      const user = await TestHelpers.createUser({
        email: 'test@example.com',
        name: 'Test User',
      });

      const result = await UserService.getUserByEmail('test@example.com');

      expect(result).toBeDefined();
      expect(result?.email).toBe('test@example.com');
      expect(result?.name).toBe('Test User');
    });

    it('should return null when user not found', async () => {
      const result = await UserService.getUserByEmail('nonexistent@example.com');
      expect(result).toBeNull();
    });
  });

  describe('getUserById', () => {
    it('should retrieve user by ID', async () => {
      const user = await TestHelpers.createUser();

      const result = await UserService.getUserById(user.id);

      expect(result).toBeDefined();
      expect(result?.id).toBe(user.id);
      expect(result?.email).toBe(user.email);
    });

    it('should return null when user ID not found', async () => {
      const result = await UserService.getUserById('nonexistent-id');
      expect(result).toBeNull();
    });
  });

  describe('updateUserProfile', () => {
    it('should update user name', async () => {
      const user = await TestHelpers.createUser();

      const result = await UserService.updateUserProfile(user.id, {
        name: 'Updated Name',
      });

      expect(result.name).toBe('Updated Name');
      expect(result.email).toBe(user.email); // Email should remain unchanged
    });

    it('should handle partial updates', async () => {
      const user = await TestHelpers.createUser({
        name: 'Original Name',
      });

      const result = await UserService.updateUserProfile(user.id, {
        name: 'New Name',
      });

      expect(result.name).toBe('New Name');
      expect(result.id).toBe(user.id);
    });
  });

  describe('getUserWithStats', () => {
    it('should return user with stats', async () => {
      const user = await TestHelpers.createUser();

      const result = await UserService.getUserWithStats(user.id);

      expect(result).toBeDefined();
      expect(result.id).toBe(user.id);
      expect(result.stats).toBeDefined();
      expect(result.stats.ideasCount).toBe(0);
      expect(result.stats.ratingsCount).toBe(0);
      expect(result.stats.commentsCount).toBe(0);
    });

    it('should calculate correct stats with ideas', async () => {
      const user = await TestHelpers.createUser();
      await TestHelpers.createMultipleIdeas(user.id, 3);

      const result = await UserService.getUserWithStats(user.id);

      expect(result.stats.ideasCount).toBe(3);
    });

    it('should throw error if user not found', async () => {
      await expect(
        UserService.getUserWithStats('nonexistent-id')
      ).rejects.toThrow('User not found');
    });
  });
});
