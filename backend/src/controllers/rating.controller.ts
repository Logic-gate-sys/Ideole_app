import { Request, Response } from 'express';
import { RatingService } from '../services/rating.service.ts';

export const RatingController = {
  /**
   * POST /ideas/:ideaId/rate - Submit a rating
   */
  async createRating(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;
      const { originality, feasibility, impact } = req.body;

      const rating = await RatingService.createRating({
        originality,
        feasibility,
        impact,
        ideaId,
        reviewerId: userId,
      });

      return res.status(201).json({ success: true, data: rating });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message.includes('Cannot rate') || error.message.includes('do not have permission') || error.message.includes('already rated')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to create rating',
      });
    }
  },

  /**
   * GET /ideas/:ideaId/stats - Get aggregated rating stats
   */
  async getStats(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;

      const stats = await RatingService.getIdeaStats(ideaId);

      return res.status(200).json({ success: true, data: stats });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch stats',
      });
    }
  },

  /**
   * GET /ideas/:ideaId/ratings - Get all ratings for an idea
   */
  async getIdeaRatings(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;

      const ratings = await RatingService.getIdeaRatings(ideaId);

      return res.status(200).json({ success: true, data: ratings || [] });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch ratings',
      });
    }
  },
};
