import type { Request, Response } from 'express';
import { IdeaService } from '../services/idea.service.ts';

export const IdeaControllers = {
  async createIdea(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      const { title, description, visibility, communityId, organisationId, criteria } = req.body;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const idea = await IdeaService.createIdea(userId, {
        title,
        description,
        visibility,
        communityId,
        organisationId,
        criteria,
      });

      return res.status(201).json({
        success: true,
        data: idea,
      });
    } catch (err: any) {
      if (err.message.includes('must be an active member')) {
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

  async getIdea(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const userId = req.user?.id;

      const idea = await IdeaService.getIdeaById(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: idea,
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

  async getAllIdeas(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      const { visibility, communityId, organisationId, stage, sortBy, limit, offset } = req.query;

      const ideas = await IdeaService.getAllIdeas(
        {
          visibility: visibility as any,
          communityId: communityId as string,
          organisationId: organisationId as string,
          stage: stage as any,
          sortBy: sortBy as any,
          limit: limit ? parseInt(limit as string) : undefined,
          offset: offset ? parseInt(offset as string) : undefined,
        },
        userId
      );

      return res.status(200).json({
        success: true,
        data: ideas,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async updateIdea(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const userId = req.user?.id;
      const { title, description, visibility, stage } = req.body;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const idea = await IdeaService.updateIdea(ideaId, userId, {
        title,
        description,
        visibility,
        stage,
      });

      return res.status(200).json({
        success: true,
        data: idea,
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

  async deleteIdea(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await IdeaService.deleteIdea(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: result,
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

  // Criteria Controllers
  async getIdeaCriteria(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;

      const criteria = await IdeaService.getIdeaCriteria(ideaId);

      return res.status(200).json({
        success: true,
        data: criteria,
      });
    } catch (err: any) {
      if (err.message === 'Idea not found') {
        return res.status(404).json({
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

  async createCriteria(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const userId = req.user?.id;
      const { name, description } = req.body;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const criteria = await IdeaService.createCriteria(ideaId, userId, {
        name,
        description,
      });

      return res.status(201).json({
        success: true,
        data: criteria,
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

      if (err.message.includes('Cannot add criteria')) {
        return res.status(400).json({
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

  async updateCriteria(req: Request, res: Response) {
    try {
      const { ideaId, criteriaId } = req.params;
      const userId = req.user?.id;
      const { name, description, order } = req.body;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const criteria = await IdeaService.updateCriteria(ideaId, criteriaId, userId, {
        name,
        description,
        order,
      });

      return res.status(200).json({
        success: true,
        data: criteria,
      });
    } catch (err: any) {
      if (err.message === 'Idea not found' || err.message === 'Criteria not found') {
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

      if (err.message.includes('Cannot update criteria')) {
        return res.status(400).json({
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

  async deleteCriteria(req: Request, res: Response) {
    try {
      const { ideaId, criteriaId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await IdeaService.deleteCriteria(ideaId, criteriaId, userId);

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      if (err.message === 'Idea not found' || err.message === 'Criteria not found') {
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

      if (err.message.includes('Cannot delete criteria')) {
        return res.status(400).json({
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
