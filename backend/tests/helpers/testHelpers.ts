import request from 'supertest';
import { Express } from 'express';
import { prisma } from '../../src/lib/prisma.ts';

export function createTestRequest(app: Express) {
  return request(app);
}

export async function getUserByEmail(email: string) {
  return prisma.user.findUnique({ where: { email } });
}

export async function getUserByUsername(username: string) {
  return prisma.user.findUnique({ where: { username } });
}

export const testUser = {
  username: 'testuser',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@example.com',
  password: 'Password123!',
};

export const anotherTestUser = {
  username: 'testuser2',
  firstName: 'Another',
  lastName: 'User',
  email: 'test2@example.com',
  password: 'Password123!',
};

export async function registerUser(app: Express, user = testUser) {
  const res = await request(app)
    .post('/api/auth/register')
    .send(user);
  return res;
}

export async function loginUser(app: Express, user = testUser) {
  const res = await request(app)
    .post('/api/auth/login')
    .send({
      email: user.email,
      password: user.password,
    });
  return res;
}

export async function getAuthTokens(app: Express, user = testUser) {
  const registerRes = await registerUser(app, user);
  return {
    accessToken: registerRes.body.data.accessToken,
    refreshToken: registerRes.body.data.refreshToken,
  };
}
