import { describe, it, expect } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';

describe('Auth Integration Tests', () => {
  describe('POST /api/auth/register', () => {
    const userData = {
      username: 'custom',
      firstName: 'Custom',
      lastName: 'User',
      email: 'custom@test.com',
       password: 'Password123!'
     }
    it('should register a new user', async () => {
      const response = await request(app)
       .post('/api/auth/register')
       .send(userData);
      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBe(userData.email);
      expect(response.body.data.username).toBe(userData.username);
      expect(response.body.token).toBeDefined();
      expect(response.headers['set-cookie']).toBeDefined();
    });

    it('should reject duplicate email', async () => {
      const testUser = await createTestUser();
      const response = await request(app)
      .post('/api/auth/register')
      .send({...testUser, password:'someotherpassword'});

      expect(response.status).toBe(500);
      expect(response.body.message).toBe('error');
    });
  });

  describe('POST /api/auth/login', () => {
    it('should login with valid credentials', async () => {
      const {email, rawPassword} = await createTestUser();

      const response = await request(app)
        .post('/api/auth/login')
        .send({ email: email, password: rawPassword})

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBe(email);
      expect(response.body.token).toBeDefined();
      expect(response.headers['set-cookie']).toBeDefined();
    });

    it('should reject invalid credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({ email: 'notfound@example.com', password: 'wrongpass' });
      expect(response.status).toBe(401);
      expect(response.body.message).toBe('error');
    });
  });

  describe('POST /api/auth/refresh', () => {
    it('should refresh access token', async () => {
      const { token: refreshToken } = await createTestUser({}, 'refresh');
      const response = await request(app)
        .post('/api/auth/refresh')
        .send({ refreshToken });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.token).toBeDefined();
    });

    it('should reject invalid refresh token', async () => {
      const response = await request(app)
        .post('/api/auth/refresh')
        .send({ refreshToken: 'invalid.token' });
      expect(response.status).toBe(401);
      expect(response.body.message).toBe('error');
    });
  });

  describe('POST /api/auth/logout', () => {
    it('should logout successfully', async () => {
      const response = await request(app).post('/api/auth/logout');
      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.headers['set-cookie']).toBeDefined();
    });
  });

  describe('GET /api/auth/me', () => {
    it('should return authenticated user', async () => {
      const { token } = await createTestUser({}, 'access');
      const response = await request(app)
        .get('/api/auth/me')
        .set('Authorization', `Bearer ${token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBeDefined();
      expect(response.body.data.username).toBeDefined();
    });

    it('should reject without token', async () => {
      const response = await request(app).get('/api/auth/me');
      expect(response.status).toBe(401);
    });
  });
});