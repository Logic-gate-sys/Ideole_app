import { execSync } from 'node:child_process';
import { prisma } from '../../src/lib/prisma.ts';

export async function setup() {
  try {
    // Test database connection
    await prisma.$connect();
    console.log('Database connected');

    // Reset database using Prisma
    execSync('NODE_ENV=test npx prisma migrate reset --force', {
      cwd: process.cwd(),
      stdio: 'inherit',
    });

    // generate client
    execSync('NODE_ENV=test npx prisma generate ', {
      cwd: process.cwd(),
      stdio: 'inherit',
    });

    console.log('Database reset');
  } catch (error) {
    console.error('Global setup failed:', error);
    process.exit(1);
  }
}

export async function teardown() {
  try {
    // Reset database for clean state
    execSync('NODE_ENV=test npx prisma migrate reset --force', {
      cwd: process.cwd(),
      stdio: 'inherit',
    });

    await prisma.$disconnect();
    console.log('Database cleaned and disconnected');
  } catch (error) {
    console.error('Global teardown failed:', error);
  }
}
