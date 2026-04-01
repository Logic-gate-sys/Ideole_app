import { beforeEach } from 'vitest';
import {prisma} from '../../src/lib/prisma.ts'
// Run before each test file
beforeEach(async () => {
  // Clear all tables before each test
  await prisma.$executeRawUnsafe(`TRUNCATE "User" CASCADE`);
});
