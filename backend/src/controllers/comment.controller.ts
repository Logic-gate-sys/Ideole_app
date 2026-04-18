import type { Request, Response } from 'express';
import { CommentService } from '../services/comment.service.ts';

export const CommentControllers = {
  async createComment(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;
      const content = req.body.content as string;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const comment = await CommentService.createComment(ideaId, userId, content);

      return res.status(201).json({
        success: true,
        data: comment,
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

  async getIdeaComments(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;
      const page = req.query.page ? parseInt(req.query.page as string, 10) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : 20;

      const comments = await CommentService.getIdeaComments(ideaId, userId, page, limit);

      return res.status(200).json({
        success: true,
        data: comments,
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

  async deleteComment(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const commentId = req.params.commentId as string;
      const userId = req.user?.id;
      const userRole = req.user?.role;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await CommentService.deleteComment(
        ideaId,
        commentId,
        userId,
        userRole
      );

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      if (err.message === 'Comment not found') {
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
