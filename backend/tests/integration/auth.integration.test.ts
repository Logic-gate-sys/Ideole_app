import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { app, server } from '../../src/app.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('Auth Endpoints', () => {
  const testUser = {
    name: 'John Doe',
    email: 'john@example.com',
    password: 'SecurePassword123',
  };

  const testUserAlt = {
    name: 'Jane Doe',
    email: 'jane@example.com',
    password: 'AnotherSecure456',
  };

  beforeAll(async () => {
    // Clean up test users before running tests
    await prisma.user.deleteMany({
      where: {
        email: {
          in: [testUser.email, testUserAlt.email],
        },
      },
    });
  });

  afterAll(async () => {
    // Clean up after tests
    await prisma.user.deleteMany({
      where: {
        email: {
          in: [testUser.email, testUserAlt.email],
        },
      },
    });
    await prisma.$disconnect();
    server.close();
  });

  describe('POST /api/auth/signup', () => {
    it('should successfully create a new user', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send(testUser);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('token');
      expect(response.body.data.name).toBe(testUser.name);
      expect(response.body.data.email).toBe(testUser.email);
    });

    it('should reject duplicate email', async () => {
      // First signup
      await request(app)
        .post('/api/auth/signup')
        .send(testUserAlt);

      // Try duplicate signup
      const response = await request(app)
        .post('/api/auth/signup')
        .send(testUserAlt);

      expect(response.status).toBe(409);
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('already exists');
    });

    it('should reject invalid email', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          email: 'invalid-email',
          password: 'SecurePassword123',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject short name', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'A',
          email: 'test@example.com',
          password: 'SecurePassword123',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject weak password (too short)', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          email: 'test@example.com',
          password: 'weak',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject password without uppercase', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          email: 'test@example.com',
          password: 'lowercase123456',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject password without lowercase', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          email: 'test@example.com',
          password: 'UPPERCASE123456',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject password without number', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          email: 'test@example.com',
          password: 'NoNumberHere',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject missing required fields', async () => {
      const response = await request(app)
        .post('/api/auth/signup')
        .send({
          name: 'Test User',
          // missing email and password
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });
  });

  describe('POST /api/auth/login', () => {
    beforeAll(async () => {
      // Create a test user for login tests
      await request(app)
        .post('/api/auth/signup')
        .send(testUser);
    });

    it('should successfully login with correct credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password,
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data).toHaveProperty('token');
      expect(response.body.data.email).toBe(testUser.email);
      expect(response.body.data.name).toBe(testUser.name);
    });

    it('should reject login with wrong password', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          password: 'WrongPassword123',
        });

      expect(response.status).toBe(401);
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('Invalid');
    });

    it('should reject login with non-existent email', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: 'nonexistent@example.com',
          password: 'SomePassword123',
        });

      expect(response.status).toBe(401);
      expect(response.body.success).toBe(false);
    });

    it('should reject invalid email format', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: 'invalid-email',
          password: 'SomePassword123',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject short password', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          password: 'short',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('should reject missing credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          // missing password
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });
  });

  describe('Auth Integration', () => {
    it('should allow signup and immediate login', async () => {
      const newUser = {
        name: 'Integration Test User',
        email: 'integration@example.com',
        password: 'IntegrationTest123',
      };

      // Signup
      const signupRes = await request(app)
        .post('/api/auth/signup')
        .send(newUser);

      expect(signupRes.status).toBe(201);
      expect(signupRes.body.data).toHaveProperty('token');

      // Login immediately after
      const loginRes = await request(app)
        .post('/api/auth/login')
        .send({
          email: newUser.email,
          password: newUser.password,
        });

      expect(loginRes.status).toBe(200);
      expect(loginRes.body.data.id).toBe(signupRes.body.data.id);

      // Cleanup
      await prisma.user.delete({
        where: { email: newUser.email },
      });
    });

    it('should return consistent user ID in signup and login', async () => {
      const user = {
        name: 'Consistency Test User',
        email: 'consistency@example.com',
        password: 'ConsistencyTest123',
      };

      const signupRes = await request(app)
        .post('/api/auth/signup')
        .send(user);

      const loginRes = await request(app)
        .post('/api/auth/login')
        .send({
          email: user.email,
          password: user.password,
        });

      expect(signupRes.body.data.id).toBe(loginRes.body.data.id);

      // Cleanup
      await prisma.user.delete({
        where: { email: user.email },
      });
    });
  });
});
