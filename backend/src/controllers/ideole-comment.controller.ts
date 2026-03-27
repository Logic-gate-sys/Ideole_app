import { Request, Response } from 'express';
import { CommentService } from '../services/comment.service.ts';

export const CommentController = {
  /**
   * POST /ideas/:ideaId/comments - Create a comment
   */
  async createComment(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;
      const { content } = req.body;

      const comment = await CommentService.createComment({
        content,
        ideaId,
        userId,
      });

      return res.status(201).json({ success: true, data: comment });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message.includes('permission')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to create comment',
      });
    }
  },

  /**
   * GET /ideas/:ideaId/comments - Get all comments for an idea
   */
  async getComments(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const { page, limit } = (req as any).validatedQuery || { page: 1, limit: 20 };

      const result = await CommentService.getIdeaComments(ideaId, page, limit);

      return res.status(200).json({ success: true, data: result });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch comments',
      });
    }
  },

  /**
   * DELETE /ideas/:ideaId/comments/:commentId - Delete a comment
   */
  async deleteComment(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { commentId } = req.params;

      await CommentService.deleteComment(commentId, userId);

      return res.status(200).json({ success: true, message: 'Comment deleted' });
    } catch (error: any) {
      if (error.message === 'Comment not found') {
        return res.status(404).json({ success: false, error: 'Comment not found' });
      }
      if (error.message.includes('permission')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to delete comment',
      });
    }
  },
};
