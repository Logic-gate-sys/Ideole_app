import { describe, it, expect } from 'vitest';
import { AuthService } from '../../src/services/auth.service.ts';

describe('AuthService', () => {
  it('should register and return tokens', async () => {
    const result = await AuthService.registerUser({
      username: 'user1',
      firstName: 'Test',
      lastName: 'One',
      email: 'user1@example.com',
      password: 'Password123!',
    });
    expect(result.user.email).toBe('user1@example.com');
    expect(result.accessToken).toBeDefined();
    expect(result.refreshToken).toBeDefined();
  });

  it('should reject duplicate email', async () => {
    await AuthService.registerUser({
      username: 'user1',
      firstName: 'Test',
      lastName: 'One',
      email: 'same@example.com',
      password: 'Password123!',
    });
    expect(
      AuthService.registerUser({
        username: 'user2',
        firstName: 'Test',
        lastName: 'Two',
        email: 'same@example.com',
        password: 'Password123!',
      }),
    ).rejects.toThrow();
  });

  it('should reject duplicate username', async () => {
    await AuthService.registerUser({
      username: 'same',
      firstName: 'Test',
      lastName: 'One',
      email: 'email1@example.com',
      password: 'Password123!',
    });
    expect(
      AuthService.registerUser({
        username: 'same',
        firstName: 'Test',
        lastName: 'Two',
        email: 'email2@example.com',
        password: 'Password123!',
      }),
    ).rejects.toThrow();
  });

  it('should login and return tokens', async () => {
    await AuthService.registerUser({
      username: 'loginuser',
      firstName: 'Login',
      lastName: 'User',
      email: 'login@example.com',
      password: 'Password123!',
    });
    const result = await AuthService.loginUser({
      email: 'login@example.com',
      password: 'Password123!',
    });
    expect(result.accessToken).toBeDefined();
    expect(result.refreshToken).toBeDefined();
  });

  it('should reject wrong password', async () => {
    await AuthService.registerUser({
      username: 'user',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      password: 'Password123!',
    });
    expect(
      AuthService.loginUser({
        email: 'test@example.com',
        password: 'WrongPassword!',
      }),
    ).rejects.toThrow();
  });

  it('should reject non-existent user', async () => {
    expect(
      AuthService.loginUser({
        email: 'notfound@example.com',
        password: 'Password123!',
      }),
    ).rejects.toThrow();
  });

  it('should refresh access token', async () => {
    const user = await AuthService.registerUser({
      username: 'refreshuser',
      firstName: 'Refresh',
      lastName: 'User',
      email: 'refresh@example.com',
      password: 'Password123!',
    });
    const result = await AuthService.refreshAccessToken(user.refreshToken!);
    expect(result.accessToken).toBeDefined();
  });

  it('should reject invalid refresh token', async () => {
    expect(
      AuthService.refreshAccessToken('invalid.token'),
    ).rejects.toThrow();
  });
});
