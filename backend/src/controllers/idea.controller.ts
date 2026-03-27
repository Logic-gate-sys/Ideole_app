import { Request, Response } from 'express';
import { IdeaService } from '../services/idea.service.ts';

export const IdeaController = {

  async createIdea(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { title, problemText, solutionText, category, visibility } = req.body;

      const idea = await IdeaService.createIdea({
        title,
        problemText,
        solutionText,
        category,
        visibility,
        creatorId: userId,
      });

      return res.status(201).json({ success: true, data: idea });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to create idea',
      });
    }
  },

  /**
   * GET /ideas - Get visible ideas for user
   */
  async getIdeas(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const page = parseInt((req.query.page as string) || '1');
      const limit = parseInt((req.query.limit as string) || '10');

      const result = await IdeaService.getVisibleIdeasForUser(userId, page, limit);

      return res.status(200).json({ success: true, data: result });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch ideas',
      });
    }
  },

 
  async getIdeaById(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;

      const idea = await IdeaService.getIdeaById(ideaId);

      return res.status(200).json({ success: true, data: idea });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch idea',
      });
    }
  },

  async updateIdea(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;
      const { title, problemText, solutionText, category, visibility } = req.body;

      const idea = await IdeaService.updateIdea(ideaId, {
        title,
        problemText,
        solutionText,
        category,
        visibility,
      }, userId);

      return res.status(200).json({ success: true, data: idea });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message.includes('creator')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to update idea',
      });
    }
  },


  async togglePublic(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;
      const { isPublic } = req.body;

      const idea = await IdeaService.toggleIdeaPublic(ideaId, isPublic, userId);

      return res.status(200).json({ success: true, data: idea });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message.includes('creator')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to toggle visibility',
      });
    }
  },


  async getUserIdeas(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const page = parseInt((req.query.page as string) || '1');
      const limit = parseInt((req.query.limit as string) || '10');

      const result = await IdeaService.getUserIdeas(userId, page, limit);

      return res.status(200).json({ success: true, data: result });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch user ideas',
      });
    }
  },
};
