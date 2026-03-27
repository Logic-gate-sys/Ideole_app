import { Server } from 'socket.io';
import type { Server as HttpServer } from 'http';

let io: Server;

export const initSocket = (server: HttpServer) => {
  io = new Server(server, {
    cors: { origin: '*' },
    transports: ['polling', 'websocket'],
  });

  io.on('connection', (socket) => {
    // Join idea room for real-time updates (comments, ratings, invites)
    socket.on('join_idea', (ideaId: string) => {
      socket.join(`idea:${ideaId}`);
    });

    // Leave idea room
    socket.on('leave_idea', (ideaId: string) => {
      socket.leave(`idea:${ideaId}`);
    });

    // Join user room for personal notifications
    socket.on('join_user', (userId: string) => {
      socket.join(`user:${userId}`);
    });

    socket.on('disconnect', () => {
      // Clean up on disconnect
    });
  });
};

/**
 * Emit updates to specific rooms
 * @param room Room identifier (e.g., 'idea:123' or 'user:456')
 * @param event Event name (e.g., 'comment_added', 'rating_submitted')
 * @param data Event data to emit
 */
export const emitUpdate = (room: string, event: string, data: any) => {
  if (io) {
    io.to(room).emit(event, data);
  }
};

/**
 * Emit comment notifications to idea room
 */
export const notifyNewComment = (ideaId: string, commentData: any) => {
  emitUpdate(`idea:${ideaId}`, 'comment_added', commentData);
};

/**
 * Emit rating notifications to idea room
 */
export const notifyNewRating = (ideaId: string, ratingStats: any) => {
  emitUpdate(`idea:${ideaId}`, 'rating_submitted', ratingStats);
};

/**
 * Emit invite notifications to user room
 */
export const notifyNewInvite = (userId: string, inviteData: any) => {
  emitUpdate(`user:${userId}`, 'invite_received', inviteData);
};

