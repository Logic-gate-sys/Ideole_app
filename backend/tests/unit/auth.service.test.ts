import { describe, it, expect } from 'vitest';
import { AuthService } from '../../src/services/auth.service.ts';

describe('AuthService', () => {
  it('should register and return user', async () => {
    const result = await AuthService.registerUser({
      username: 'user1',
      firstName: 'Test',
      lastName: 'One',
      email: 'user1@example.com',
      password: 'Password123!',
    });
    expect(result.email).toBe('user1@example.com');
    expect(result.username).toBe('user1');
    expect(result.id).toBeDefined();
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

  it('should login and return user', async () => {
    const registered = await AuthService.registerUser({
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
    expect(result.email).toBe('login@example.com');
    expect(result.id).toBe(registered.id);
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
    await expect(
      AuthService.loginUser({
        email: 'notfound@example.com',
        password: 'Password123!',
      }),
    ).rejects.toThrow();
  });

  it('should refresh and return user', async () => {
    const user = await AuthService.registerUser({
      username: 'refreshuser',
      firstName: 'Refresh',
      lastName: 'User',
      email: 'refresh@example.com',
      password: 'Password123!',
    });
    const result = await AuthService.refreshAccessToken(user.id);
    expect(result.id).toBe(user.id);
    expect(result.email).toBe('refresh@example.com');
  });

  it('should reject invalid user on refresh', async () => {
    await expect(
      AuthService.refreshAccessToken('invalid-id'),
    ).rejects.toThrow();
  });

  it('should getMe return user profile', async () => {
    const user = await AuthService.registerUser({
      username: 'meuser',
      firstName: 'Me',
      lastName: 'User',
      email: 'me@example.com',
      password: 'Password123!',
    });
    const result = await AuthService.getMe(user.id);
    expect(result.email).toBe('me@example.com');
    expect(result.username).toBe('meuser');
    expect(result.firstName).toBe('Me');
  });

  it('should logout successfully', async () => {
    const result = await AuthService.logout();
    expect(result.message).toBeDefined();
  });
});
