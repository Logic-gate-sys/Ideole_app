import { prisma } from '../lib/prisma.ts';
import { generateAccessToken, generateRefreshToken } from '../lib/jwt.ts';
import { hashPassword, verifyPassword } from '../lib/password.ts';
import type { RegisterInput, LoginInput } from '../schema/auth.schema.ts';


export const AuthService = {
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
    const user = await prisma.user.create({
      data: {
        username: input.username,
        firstName: input.firstName,
        lastName: input.lastName,
        email: input.email,
        passwordHash,
      },
    });

    // Generate tokens
    const accessToken = await generateAccessToken(user);
    const refreshToken = await generateRefreshToken(user);

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
      accessToken,
      refreshToken,
    };
  },


  async loginUser(input: LoginInput){
    // Find user by email
    const user = await prisma.user.findUnique({
      where: { email: input.email },
    });

    if (!user) {
      throw new Error('Invalid email or password');
    }

    // Verify password
    const passwordMatch = await verifyPassword(input.password, user.passwordHash);

    if (!passwordMatch) {
      throw new Error('Invalid email or password');
    }

    // Update lastActive
    await prisma.user.update({
      where: { id: user.id },
      data: { lastActive: new Date() },
    });

    // Generate tokens
    const accessToken = await generateAccessToken(user);
    const refreshToken = await generateRefreshToken(user);

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
      accessToken,
      refreshToken,
    };
  },

  async refreshAccessToken(refreshToken: string){
    const { verifyToken } = await import('../lib/jwt.ts');

    const payload = await verifyToken(refreshToken);

    if (!payload || payload.type !== 'refresh') {
      throw new Error('Invalid refresh token');
    }

    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const accessToken = await generateAccessToken(user);

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
      accessToken,
    };
  },
};
