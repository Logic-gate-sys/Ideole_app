import {JWTPayload, jwtVerify,  SignJWT} from 'jose';
import {env} from '../../env.ts';





const secret = new TextEncoder().encode(env.JWT_SECRET);
export interface CustomJWTPayload extends JWTPayload{
  userId: string;
  email: string;
  role: string;
  type: 'access' | 'refresh';
};

export async function generateAccessToken(user: CustomJWTPayload): Promise<string> {
  const token = await new SignJWT({
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


export async function generateRefreshToken(user: CustomJWTPayload): Promise<string> {
  const token = await new SignJWT({
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


export async function verifyToken(token: string): Promise<CustomJWTPayload | null> {
  try {
    const verified = await jwtVerify(token, secret);
    return verified.payload as CustomJWTPayload;
  } catch {
    return null;
  }
}
