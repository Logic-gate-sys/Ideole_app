import {jwtVerify,  SignJWT} from 'jose';
import { jwtVerify } from 'jose';
import type { User } from '../../prisma/generated/client.ts';
import { sign } from 'node:crypto';

const secret = new TextEncoder().encode(process.env.JWT_SECRET || 'your-secret-key');

export type JWTPayload= {
  userId: string;
  email: string;
  role: string;
  type: 'access' | 'refresh';
};

export async function generateAccessToken(user: User): Promise<string> {
  const token = await SignJWT({
    userId: user.id,
    email: user.email,
    role: user.role,
    type: 'access',
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('15m')
    .sign(secret);

  return token;
}


export async function generateRefreshToken(user: User): Promise<string> {
  const token = await new jose.SignJWT({
    userId: user.id,
    email: user.email,
    role: user.role,
    type: 'refresh',
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('7d')
    .sign(secret);

  return token;
}


export async function verifyToken(token: string): Promise<JWTPayload | null> {
  try {
    const verified = await jose.jwtVerify(token, secret);
    return verified.payload as JWTPayload;
  } catch {
    return null;
  }
}
