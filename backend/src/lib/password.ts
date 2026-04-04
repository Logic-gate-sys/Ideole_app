import { hash, compare } from 'bcrypt';
import {env} from '../../env.ts'


export async function hashPassword(password: string): Promise<string> {
  return hash(password, env.BCRYPT_ROUNDS);
}

export async function verifyPassword(password: string, passwordHash: string): Promise<boolean> {
  return compare(password, passwordHash);
}
