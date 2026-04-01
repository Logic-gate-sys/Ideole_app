import {prisma} from '../../src/lib/prisma.ts'

export async function setup() {
  try {
    // Test database connection
    await prisma.$connect();
    console.log('✓ Database connected');

    // Reset database - clear all data
    await prisma.$executeRawUnsafe(`TRUNCATE "User" CASCADE`);
    console.log('✓ Database reset');
  } catch (error) {
    console.error('✗ Global setup failed:', error);
    process.exit(1);
  }
}

export async function teardown() {
  try {
    // Clean up before test suite ends
    await prisma.$executeRawUnsafe(`TRUNCATE "User" CASCADE`);
    await prisma.$disconnect();
    console.log('✓ Database cleaned and disconnected');
  } catch (error) {
    console.error('✗ Global teardown failed:', error);
  }
}
