import type { Request, Response } from 'express';
import { CommunityService } from '../services/community.service.ts';

export const CommunityControllers = {
  async create(req: Request, res: Response) {
    try {
      const { organisationId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const community = await CommunityService.createCommunity(req.body, organisationId, userId);

      return res.status(201).json({
        success: true,
        data: community,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getById(req: Request, res: Response) {
    try {
      const { communityId } = req.params;

      const community = await CommunityService.getCommunity(communityId);

      return res.status(200).json({
        success: true,
        data: community,
      });
    } catch (err: any) {
      if (err.message === 'Community not found') {
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

  async list(req: Request, res: Response) {
    try {
      const { organisationId } = req.params;

      const communities = await CommunityService.listCommunities(organisationId);

      return res.status(200).json({
        success: true,
        data: communities,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async update(req: Request, res: Response) {
    try {
      const { communityId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const community = await CommunityService.updateCommunity(communityId, userId, req.body);

      return res.status(200).json({
        success: true,
        data: community,
      });
    } catch (err: any) {
      if (err.message === 'Community not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message === 'Only admin can update community') {
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

  async delete(req: Request, res: Response) {
    try {
      const { communityId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      await CommunityService.deleteCommunity(communityId, userId);

      return res.status(200).json({
        success: true,
      });
    } catch (err: any) {
      if (err.message === 'Community not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message === 'Only admin can delete community') {
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
