import type { Request, Response } from 'express';
import { InviteService } from '../services/invite.service.ts';

export const InviteControllers = {
  async sendInvite(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const invitedByUserId = req.user?.id;
      const invitedUserId = req.body.invitedUserId as string;

      if (!invitedByUserId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const invite = await InviteService.sendInvite(
        ideaId,
        invitedByUserId,
        invitedUserId
      );

      return res.status(201).json({
        success: true,
        data: invite,
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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

      if (
        err.message.includes('already exists') ||
        err.message.includes('Cannot invite')
      ) {
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

  async respondToInvite(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const inviteId = req.params.inviteId as string;
      const userId = req.user?.id;
      const status = req.body.status as 'ACCEPTED' | 'DECLINED' | 'CANCELLED';

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const invite = await InviteService.respondToInvite(ideaId, inviteId, userId, status);

      return res.status(200).json({
        success: true,
        data: invite,
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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

      if (err.message.includes('no longer pending')) {
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

  async getIdeaInvites(req: Request, res: Response) {
    try {
      const ideaId = req.params.ideaId as string;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const invites = await InviteService.getIdeaInvites(ideaId, userId);

      return res.status(200).json({
        success: true,
        data: invites,
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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

  async getUserInvites(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const invites = await InviteService.getUserInvites(userId);

      return res.status(200).json({
        success: true,
        data: invites,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getPendingInvites(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const invites = await InviteService.getPendingInvites(userId);

      return res.status(200).json({
        success: true,
        data: invites,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },
};
