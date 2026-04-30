import { prisma } from '../lib/prisma.ts';
import type { UpdateUserInput } from '../schema/user.schema.ts';

export const UserService = {
  async getUserProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        username: true,
        email: true,
        firstName: true,
        lastName: true,
        profileUrl: true,
        role: true,
        createdAt: true,
        status: true,
      },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return user;
  },

  async searchUsers(options: {
    query: string;
    limit?: number;
    excludeUserId?: string;
  }) {
    const query = options.query.trim();
    if (query.length < 2) {
      return [];
    }

    const limit = Math.min(Math.max(options.limit ?? 8, 1), 20);

    const users = await prisma.user.findMany({
      where: {
        status: 'ACTIVE',
        ...(options.excludeUserId
            ? { id: { not: options.excludeUserId } }
            : {}),
        OR: [
          {
            username: {
              contains: query,
              mode: 'insensitive',
            },
          },
          {
            email: {
              contains: query,
              mode: 'insensitive',
            },
          },
          {
            firstName: {
              contains: query,
              mode: 'insensitive',
            },
          },
          {
            lastName: {
              contains: query,
              mode: 'insensitive',
            },
          },
        ],
      },
      select: {
        id: true,
        username: true,
        firstName: true,
        lastName: true,
        email: true,
        profileUrl: true,
        status: true,
      },
      orderBy: {
        username: 'asc',
      },
      take: limit,
    });

    return users;
  },

  async updateUserProfile(userId: string, input: UpdateUserInput) {
    // Check if email already exists (if updating email)
    if (input.email) {
      const existing = await prisma.user.findUnique({
        where: { email: input.email },
      });

      if (existing && existing.id !== userId) {
        throw new Error('Email already in use');
      }
    }

    // Check if username already exists (if updating username)
    if (input.username) {
      const existing = await prisma.user.findUnique({
        where: { username: input.username },
      });

      if (existing && existing.id !== userId) {
        throw new Error('Username already taken');
      }
    }

    const updated = await prisma.user.update({
      where: { id: userId },
      data: {
        ...(input.username && { username: input.username }),
        ...(input.email && { email: input.email }),
        ...(input.profileUrl && { profileUrl: input.profileUrl }),
      },
      select: {
        id: true,
        username: true,
        email: true,
        firstName: true,
        lastName: true,
        profileUrl: true,
        role: true,
        createdAt: true,
        status: true,
      },
    });

    return updated;
  },

  async updateLastActive(userId: string) {
    const updated = await prisma.user.update({
      where: { id: userId },
      data: { lastActive: new Date() },
      select: {
        id: true,
        lastActive: true,
      },
    });

    return updated;
  },

  async getUserMemberships(userId: string) {
    const memberships = await prisma.membership.findMany({
      where: { userId },
      include: {
        community: {
          include: {
            organisation: true,
          },
        },
      },
      orderBy: { joinedAt: 'desc' },
    });

    return memberships;
  },

  async getUserIdeas(userId: string) {
    const ideas = await prisma.idea.findMany({
      where: { ownerId: userId },
      include: {
        criteria: true,
        _count: {
          select: {
            ratings: true,
            comments: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return ideas;
  },
};
