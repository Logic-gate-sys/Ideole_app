import type { Request, Response } from 'express';
import { RatingService } from '../services/rating.service.ts';

export const RatingControllers = {
  async createRating(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;
      const originality = Number(req.body.originality);
      const feasibility = Number(req.body.feasibility);
      const impact = Number(req.body.impact);

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const rating = await RatingService.createRating(ideaId, userId, {
        originality,
        feasibility,
        impact,
      });

      return res.status(201).json({
        success: true,
        data: rating,
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

  async getIdeaRatingStats(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;

      const stats = await RatingService.getIdeaRatingStats(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: stats,
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

  async getIdeaRatings(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;

      const ratings = await RatingService.getIdeaRatings(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: ratings,
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
};
