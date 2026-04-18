import type { Idea } from '../../prisma/generated/client.ts';
import { prisma } from '../lib/prisma.ts';

export async function getAccessibleIdea(
  ideaId: string,
  userId?: string
): Promise<Idea> {
  const idea = await prisma.idea.findUnique({
    where: { id: ideaId },
  });

  if (!idea) {
    throw new Error('Idea not found');
  }

  if (idea.visibility === 'PRIVATE' && idea.ownerId !== userId) {
    throw new Error('Unauthorized: Cannot access private idea');
  }

  if (idea.visibility === 'PROTECTED') {
    if (!userId) {
      throw new Error(
        'Unauthorized: Must be authenticated to access protected idea'
      );
    }

    if (idea.communityId) {
      const membership = await prisma.membership.findUnique({
        where: {
          userId_communityId: {
            userId,
            communityId: idea.communityId,
          },
        },
      });

      if (!membership || membership.status !== 'ACTIVE') {
        throw new Error(
          'Unauthorized: Must be active community member to access protected idea'
        );
      }
    }
  }

  return idea;
}
