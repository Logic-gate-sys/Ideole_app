import type { Request, Response } from 'express';
import { ConversationService } from '../services/conversation.service.ts';

export const ConversationControllers = {
  async getIdeaConversation(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const conversation = await ConversationService.getIdeaConversation(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: conversation,
      });
    } catch (err: any) {
      if (err.message === 'Idea not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async createIdeaConversation(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const conversation = await ConversationService.getOrCreateIdeaConversation(
        ideaId,
        userId
      );

      return res.status(200).json({
        success: true,
        data: conversation,
      });
    } catch (err: any) {
      if (err.message === 'Idea not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getConversationMessages(req: Request, res: Response) {
    try {
      const conversationId = req.params.conversationId as string;
      const userId = req.user?.id;
      const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : 50;
      const offset = req.query.offset ? parseInt(req.query.offset as string, 10) : 0;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const messages = await ConversationService.getConversationMessages(
        conversationId,
        userId,
        limit,
        offset
      );

      return res.status(200).json({
        success: true,
        data: messages,
      });
    } catch (err: any) {
      if (err.message === 'Conversation not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async createMessage(req: Request, res: Response) {
    try {
      const conversationId = req.params.conversationId as string;
      const userId = req.user?.id;
      const content = req.body.content as string;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const message = await ConversationService.createMessage(
        conversationId,
        userId,
        content
      );

      return res.status(201).json({
        success: true,
        data: message,
      });
    } catch (err: any) {
      if (err.message === 'Conversation not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },
};
