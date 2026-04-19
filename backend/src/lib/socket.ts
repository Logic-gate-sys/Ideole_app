import type { Server as HttpServer } from 'http';
import { Server, type Socket } from 'socket.io';

import { verifyToken } from './jwt.ts';
import { getAccessibleIdea } from '../services/idea-access.service.ts';
import { prisma } from './prisma.ts';

type SocketEventPayload = Record<string, unknown>;

type SocketState = {
  userId?: string;
  userRole?: string;
  authenticated?: boolean;
};

type AuthenticatedSocket = Socket;

const COMMENT_ROOM_PREFIX = 'idea-comments:';
const CONVERSATION_ROOM_PREFIX = 'conversation:';

let ioInstance: Server | null = null;

function commentRoomId(ideaId: string): string {
  return `${COMMENT_ROOM_PREFIX}${ideaId}`;
}

function conversationRoomId(conversationId: string): string {
  return `${CONVERSATION_ROOM_PREFIX}${conversationId}`;
}

function normalizePayload(payload: unknown): SocketEventPayload {
  if (payload && typeof payload === 'object') {
    return payload as SocketEventPayload;
  }

  return {};
}

function getSocketState(socket: AuthenticatedSocket): SocketState {
  return socket.data as SocketState;
}

async function handleSocketAuth(socket: AuthenticatedSocket, payload: unknown) {
  const state = getSocketState(socket);
  const data = normalizePayload(payload);
  const tokenValue = data.token;
  const token = typeof tokenValue === 'string' ? tokenValue : null;

  if (!token) {
    socket.emit('auth.error', { message: 'Token is required' });
    return;
  }

  const jwtPayload = await verifyToken(token);
  if (!jwtPayload || jwtPayload.type !== 'access') {
    socket.emit('auth.error', { message: 'Invalid token' });
    return;
  }

  state.userId = jwtPayload.userId;
  state.userRole = jwtPayload.role;
  state.authenticated = true;

  socket.emit('auth.success', {
    userId: jwtPayload.userId,
    role: jwtPayload.role,
  });
}

async function subscribeToComments(
  socket: AuthenticatedSocket,
  ideaId: string,
): Promise<void> {
  const userId = getSocketState(socket).userId;
  await getAccessibleIdea(ideaId, userId);

  const room = commentRoomId(ideaId);
  await socket.join(room);
  socket.emit('subscribed', { channel: 'idea.comments', room, ideaId });
}

async function subscribeToConversation(
  socket: AuthenticatedSocket,
  conversationId: string,
): Promise<void> {
  const userId = getSocketState(socket).userId;
  if (!userId) {
    throw new Error('Unauthorized: Must authenticate before subscribing');
  }

  const conversation = await prisma.conversation.findUnique({
    where: { id: conversationId },
    select: { id: true, ideaId: true },
  });

  if (!conversation) {
    throw new Error('Conversation not found');
  }

  if (conversation.ideaId) {
    await getAccessibleIdea(conversation.ideaId, userId);
  }

  const room = conversationRoomId(conversationId);
  await socket.join(room);
  socket.emit('subscribed', {
    channel: 'idea.conversation',
    room,
    conversationId,
  });
}

async function handleSocketSubscribe(
  socket: AuthenticatedSocket,
  payload: unknown,
) {
  const data = normalizePayload(payload);
  const channel = typeof data.channel === 'string' ? data.channel : null;

  if (!channel) {
    socket.emit('subscription.error', {
      message: 'Subscription channel is required',
    });
    return;
  }

  if (!getSocketState(socket).authenticated) {
    socket.emit('subscription.error', {
      channel,
      message: 'Authenticate first',
    });
    return;
  }

  try {
    if (channel == 'idea.comments') {
      const ideaId = typeof data.ideaId === 'string' ? data.ideaId : null;
      if (!ideaId) {
        throw new Error('ideaId is required for idea.comments channel');
      }

      await subscribeToComments(socket, ideaId);
      return;
    }

    if (channel == 'idea.conversation') {
      const conversationId =
        typeof data.conversationId === 'string' ? data.conversationId : null;
      if (!conversationId) {
        throw new Error(
          'conversationId is required for idea.conversation channel',
        );
      }

      await subscribeToConversation(socket, conversationId);
      return;
    }

    throw new Error(`Unsupported channel: ${channel}`);
  } catch (error) {
    const message =
      error instanceof Error ? error.message : 'Subscription failed';

    socket.emit('subscription.error', {
      channel,
      message,
    });
  }
}

function wireSocketHandlers(rawSocket: Socket) {
  const socket = rawSocket as AuthenticatedSocket;

  socket.emit('connection.ready', {
    socketId: socket.id,
  });

  socket.on('auth', (payload) => {
    void handleSocketAuth(socket, payload).catch(() => {
      socket.emit('auth.error', { message: 'Authentication failed' });
    });
  });

  socket.on('subscribe', (payload) => {
    void handleSocketSubscribe(socket, payload);
  });

  socket.on('disconnect', () => {
    const state = getSocketState(socket);
    state.authenticated = false;
  });
}

export function initializeSocketServer(httpServer: HttpServer): Server {
  if (ioInstance) {
    return ioInstance;
  }

  ioInstance = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
    path: '/socket.io',
  });

  ioInstance.on('connection', wireSocketHandlers);

  return ioInstance;
}

export function getSocketServer(): Server | null {
  return ioInstance;
}

export function emitCommentCreated(ideaId: string, comment: unknown): void {
  ioInstance?.to(commentRoomId(ideaId)).emit('comment.created', comment);
}

export function emitCommentDeleted(ideaId: string, commentId: string): void {
  ioInstance?.to(commentRoomId(ideaId)).emit('comment.deleted', {
    ideaId,
    commentId,
  });
}

export function emitConversationMessageCreated(
  conversationId: string,
  message: unknown,
): void {
  ioInstance
    ?.to(conversationRoomId(conversationId))
    .emit('message.created', message);
}
