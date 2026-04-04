import type { Request, Response } from 'express';
import { UserService } from '../services/user.service.ts';

export const UserControllers = {
  async getUserById(req: Request, res: Response) {
    try {
      const { userId } = req.params;

      const user = await UserService.getUserProfile(userId);

      return res.status(200).json({
        success: true,
        data: user,
      });
    } catch (err: any) {
      if (err.message === 'User not found') {
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

  async updateProfile(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      const body = req.body;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const user = await UserService.updateUserProfile(userId, body);

      return res.status(200).json({
        success: true,
        data: user,
      });
    } catch (err: any) {
      if (err.message === 'Email already in use' || err.message === 'Username already taken') {
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

  async updateLastActive(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await UserService.updateLastActive(userId);

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getMemberships(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const memberships = await UserService.getUserMemberships(userId);

      return res.status(200).json({
        success: true,
        data: memberships,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getIdeas(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const ideas = await UserService.getUserIdeas(userId);

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
};
