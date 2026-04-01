import { hash, compare } from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Hash a plaintext password using bcrypt
 * @param password - The plaintext password to hash
 * @returns The hashed password
 */
export async function hashPassword(password: string): Promise<string> {
  return hash(password, SALT_ROUNDS);
}

/**
 * Verify a plaintext password against a bcrypt hash
 * @param password - The plaintext password to verify
 * @param passwordHash - The hashed password to compare against
 * @returns true if password matches, false otherwise
 */
export async function verifyPassword(password: string, passwordHash: string): Promise<boolean> {
  return compare(password, passwordHash);
}
