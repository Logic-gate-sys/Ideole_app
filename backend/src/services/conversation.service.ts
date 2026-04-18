import { prisma } from '../lib/prisma.ts';
import { getAccessibleIdea } from './idea-access.service.ts';

type ConversationRecord = {
  id: string;
  contextId: string;
  contextType: string;
  ideaId: string | null;
  createdAt: Date;
  _count: {
    messages: number;
  };
};

type MessageRecord = {
  id: string;
  conversationId: string;
  senderId: string;
  content: string;
  sentAt: Date;
  sender: {
    id: string;
    username: string;
    profileUrl: string;
  };
};

function mapConversation(record: ConversationRecord) {
  return {
    id: record.id,
    contextId: record.contextId,
    contextType: record.contextType,
    ideaId: record.ideaId,
    createdAt: record.createdAt,
    messageCount: record._count.messages,
  };
}

function mapMessage(record: MessageRecord) {
  return {
    id: record.id,
    conversationId: record.conversationId,
    senderId: record.senderId,
    content: record.content,
    sentAt: record.sentAt,
    user: {
      id: record.sender.id,
      name: record.sender.username,
      username: record.sender.username,
      profileUrl: record.sender.profileUrl,
    },
  };
}

export const ConversationService = {
  async getIdeaConversation(ideaId: string, userId: string) {
    await getAccessibleIdea(ideaId, userId);

    const conversation = await prisma.conversation.findFirst({
      where: {
        ideaId,
        contextType: 'IDEA',
      },
      include: {
        _count: {
          select: {
            messages: true,
          },
        },
      },
    });

    if (!conversation) {
      return null;
    }

    return mapConversation(conversation);
  },

  async getOrCreateIdeaConversation(ideaId: string, userId: string) {
    await getAccessibleIdea(ideaId, userId);

    const existingConversation = await prisma.conversation.findFirst({
      where: {
        ideaId,
        contextType: 'IDEA',
      },
      include: {
        _count: {
          select: {
            messages: true,
          },
        },
      },
    });

    if (existingConversation) {
      return mapConversation(existingConversation);
    }

    const createdConversation = await prisma.conversation.create({
      data: {
        contextId: ideaId,
        contextType: 'IDEA',
        ideaId,
      },
      include: {
        _count: {
          select: {
            messages: true,
          },
        },
      },
    });

    return mapConversation(createdConversation);
  },

  async getConversationMessages(
    conversationId: string,
    userId: string,
    limit = 50,
    offset = 0
  ) {
    const conversation = await prisma.conversation.findUnique({
      where: {
        id: conversationId,
      },
      select: {
        id: true,
        ideaId: true,
      },
    });

    if (!conversation) {
      throw new Error('Conversation not found');
    }

    if (conversation.ideaId) {
      await getAccessibleIdea(conversation.ideaId, userId);
    }

    const sanitizedLimit = Math.min(Math.max(limit, 1), 100);
    const sanitizedOffset = Math.max(offset, 0);

    const messages = await prisma.message.findMany({
      where: {
        conversationId,
      },
      include: {
        sender: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
      },
      orderBy: {
        sentAt: 'asc',
      },
      take: sanitizedLimit,
      skip: sanitizedOffset,
    });

    return messages.map(mapMessage);
  },

  async createMessage(conversationId: string, userId: string, content: string) {
    const conversation = await prisma.conversation.findUnique({
      where: {
        id: conversationId,
      },
      select: {
        id: true,
        ideaId: true,
      },
    });

    if (!conversation) {
      throw new Error('Conversation not found');
    }

    if (conversation.ideaId) {
      await getAccessibleIdea(conversation.ideaId, userId);
    }

    const message = await prisma.message.create({
      data: {
        conversationId,
        senderId: userId,
        content,
      },
      include: {
        sender: {
          select: {
            id: true,
            username: true,
            profileUrl: true,
          },
        },
      },
    });

    return mapMessage(message);
  },
};
