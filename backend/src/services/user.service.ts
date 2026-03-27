import { prisma } from '@/lib/prisma';
import { Visibility } from '../types/index.ts';

export interface CreateUserInput {
  name: string;
  email: string;
  passwordHash: string;
}

export interface UpdateUserInput {
  name?: string;
  skills?: string[];
}

export const UserService = {
  /**
   * Create a new user
   * @throws Error if user already exists
   */
  async createUser(input: CreateUserInput) {
    const existingUser = await prisma.user.findUnique({
      where: { email: input.email },
    });

    if (existingUser) {
      throw new Error('User with this email already exists');
    }

    return prisma.user.create({
      data: {
        name: input.name,
        email: input.email,
        passwordHash: input.passwordHash,
      },
      select: {
        id: true,
        name: true,
        email: true,
        createdAt: true,
      },
    });
  },

  /**
   * Get user by email
   */
  async getUserByEmail(email: string) {
    return prisma.user.findUnique({
      where: { email },
      select: {
        id: true,
        name: true,
        email: true,
        passwordHash: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  },

  /**
   * Get user by ID
   */
  async getUserById(userId: string) {
    return prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        name: true,
        email: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  },

  /**
   * Update user profile
   */
  async updateUserProfile(userId: string, input: UpdateUserInput) {
    const updateData: any = {};
    if (input.name) updateData.name = input.name;

    return prisma.user.update({
      where: { id: userId },
      data: updateData,
      select: {
        id: true,
        name: true,
        email: true,
        updatedAt: true,
      },
    });
  },

  /**
   * Get user with stats (ideas count, ratings given, etc.)
   */
  async getUserWithStats(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        name: true,
        email: true,
        createdAt: true,
        updatedAt: true,
        ideas: true,
        ratings: true,
        comments: true,
      },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return {
      ...user,
      stats: {
        ideasCount: user.ideas.length,
        ratingsCount: user.ratings.length,
        commentsCount: user.comments.length,
      },
    };
  },
};
