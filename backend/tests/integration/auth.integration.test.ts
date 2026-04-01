import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { testUser, anotherTestUser, getAuthTokens } from '../helpers/testHelpers.ts';

describe('Auth Integration Tests', () => {
  describe('POST /api/auth/register', () => {
    it('should register a new user', async () => {
      const response = await request(app).post('/api/auth/register').send(testUser);
      expect(response.status).toBe(201);
      expect(response.body.data.user.email).toBe(testUser.email);
      expect(response.body.data.accessToken).toBeDefined();
      expect(response.body.data.refreshToken).toBeDefined();
    });

    it('should reject duplicate email', async () => {
      await request(app).post('/api/auth/register').send(testUser);
      const response = await request(app).post('/api/auth/register').send(testUser);
      expect(response.status).toBe(400);
      expect(response.body.error).toContain('already registered');
    });
  });

  describe('POST /api/auth/login', () => {
    it('should login with valid credentials', async () => {
      await request(app).post('/api/auth/register').send(anotherTestUser);
      const response = await request(app)
        .post('/api/auth/login')
        .send({ email: anotherTestUser.email, password: anotherTestUser.password });
      expect(response.status).toBe(200);
      expect(response.body.data.accessToken).toBeDefined();
    });

    it('should reject invalid credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ email: 'notfound@example.com', password: 'wrongpass' });
      expect(response.status).toBe(401);
    });
  });

  describe('POST /api/auth/refresh', () => {
    it('should refresh access token', async () => {
      const { refreshToken } = await getAuthTokens(app);
      const response = await request(app)
        .post('/api/auth/refresh')
        .send({ refreshToken });
      expect(response.status).toBe(200);
      expect(response.body.data.accessToken).toBeDefined();
    });

    it('should reject invalid refresh token', async () => {
      const response = await request(app)
        .post('/api/auth/refresh')
        .send({ refreshToken: 'invalid.token' });
      expect(response.status).toBe(401);
    });
  });

  describe('POST /api/auth/logout', () => {
    it('should logout', async () => {
      const response = await request(app).post('/api/auth/logout');
      expect(response.status).toBe(200);
    });
  });

  describe('GET /api/auth/me', () => {
    it('should return authenticated user', async () => {
      const { accessToken } = await getAuthTokens(app);
      const response = await request(app)
        .get('/api/auth/me')
        .set('Authorization', `Bearer ${accessToken}`);
      expect(response.status).toBe(200);
      expect(response.body.data.email).toBe(testUser.email);
    });

    it('should reject without token', async () => {
      const response = await request(app).get('/api/auth/me');
      expect(response.status).toBe(401);
    });
  });
});