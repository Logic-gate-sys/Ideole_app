import { beforeEach } from 'vitest';
import { prisma } from '../../src/lib/prisma.ts';

// Run before each test
beforeEach(async () => {
  // Clear all tables before each test with CASCADE
  await prisma.$executeRawUnsafe(`TRUNCATE "User", "Organisation", "Community", "Membership", "Idea", "EvaluationCriteria", "IdeaRating", "IdeaComment", "IdeaInvite", "Conversation", "Message" CASCADE`);
});
