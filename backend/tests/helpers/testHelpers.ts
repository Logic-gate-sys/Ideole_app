import { prisma } from '../../src/lib/prisma.ts';
import { hashPassword } from '../../src/lib/password.ts';
import { generateAccessToken, generateRefreshToken } from '../../src/lib/jwt.ts';

export const testUser = {
  username: 'testuser',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@example.com',
  password: 'Password123!',
};

export async function createTestUser(userOverrides = {}, tokenType='access') {
  const userData = { ...testUser, ...userOverrides };
  const passwordHash = await hashPassword(userData.password);
  
  const user = await prisma.user.create({
    data: {
      username: userData.username,
      firstName: userData.firstName,
      lastName: userData.lastName,
      email: userData.email,
      passwordHash,
    },
    select: {
        id: true,
        username:true,
        firstName:true,
        lastName:true,
        email: true,
        role: true
    }
  });
  const testPayload = {
    userId: user.id,
    email: user.email,
    role: user.role,
  }
  const token = tokenType==='refresh'? await generateRefreshToken({...testPayload, type:'refresh'}): await generateAccessToken({...testPayload, type:'access'});
  
  return {...user, rawPassword: userData.password, token:token};
}
