import { prisma } from '../lib/prisma.ts';
import { hashPassword, verifyPassword } from '../lib/password.ts';
import type { RegisterInput, LoginInput } from '../schema/auth.schema.ts';


export const AuthService = {
  // register 
  async registerUser(input: RegisterInput) {
    const existing = await prisma.user.findUnique({
      where: { email: input.email },
    });

    if (existing) {
      throw new Error('Email already registered');
    }

    // Check if username is taken
    const usernameExists = await prisma.user.findUnique({
      where: { username: input.username },
    });

    if (usernameExists) {
      throw new Error('Username already taken');
    }

    // Hash password
    const passwordHash = await hashPassword(input.password);
    // Create user
    return  await prisma.user.create({
      data: {
        username: input.username,
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email,
        passwordHash:passwordHash,
      },
    });
  },

  //login
  async loginUser(input: LoginInput){
    const user = await prisma.user.findUnique({
      where: { email: input.email },
    });

    if (!user) {
      throw new Error('Invalid email or password');
    }
    const passwordMatch = await verifyPassword(input.password, user.passwordHash);
    if (!passwordMatch) {
      throw new Error('Invalid email or password');
    }
    // return updated user
    return await prisma.user.update({
      where: { id: user.id },
      data: { lastActive: new Date() },
    });
  },

  // refresh token
  async refreshAccessToken(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return user;
  },

  // logout
  async logout() {
    return { message: 'Logged out successfully' };
  },

  // get current user
  async getMe(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        username: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
        profileUrl: true,
        createdAt: true,
      },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return user;
  }
};
