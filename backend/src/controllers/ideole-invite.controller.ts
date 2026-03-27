import { Request, Response } from 'express';
import { InviteService } from '../services/invite.service.ts';

export const InviteController = {
  /**
   * POST /ideas/:ideaId/invite - Send invitation
   */
  async sendInvite(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;
      const { reviewerId } = req.body;

      const invite = await InviteService.sendInvite({
        ideaId,
        reviewerId,
        creatorId: userId,
      });

      return res.status(201).json({ success: true, data: invite });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message === 'Reviewer not found') {
        return res.status(404).json({ success: false, error: 'Reviewer not found' });
      }
      if (error.message.includes('creator') || error.message.includes('permission')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      if (error.message.includes('already')) {
        return res.status(409).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to send invite',
      });
    }
  },

  /**
   * PATCH /ideas/:ideaId/invite/:inviteId - Accept invitation
   */
  async acceptInvite(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { inviteId } = req.params;

      const invite = await InviteService.acceptInvite(inviteId, userId);

      return res.status(200).json({ success: true, data: invite });
    } catch (error: any) {
      if (error.message === 'Invite not found') {
        return res.status(404).json({ success: false, error: 'Invite not found' });
      }
      if (error.message.includes('permission')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to accept invite',
      });
    }
  },

  /**
   * GET /ideas/:ideaId/invites - Get all invites for an idea
   */
  async getIdeaInvites(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const { ideaId } = req.params;

      const invites = await InviteService.getIdeaInvites(ideaId, userId);

      return res.status(200).json({ success: true, data: invites });
    } catch (error: any) {
      if (error.message === 'Idea not found') {
        return res.status(404).json({ success: false, error: 'Idea not found' });
      }
      if (error.message.includes('creator')) {
        return res.status(403).json({ success: false, error: error.message });
      }
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch invites',
      });
    }
  },

  /**
   * GET /user/invites - Get user's received invites
   */
  async getUserInvites(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const invites = await InviteService.getUserInvites(userId);

      return res.status(200).json({ success: true, data: invites });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch invites',
      });
    }
  },

  /**
   * GET /user/invites/pending - Get pending invites
   */
  async getPendingInvites(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.id;
      if (!userId) {
        return res.status(401).json({ success: false, error: 'Unauthorized' });
      }

      const invites = await InviteService.getPendingInvites(userId);

      return res.status(200).json({ success: true, data: invites });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        error: error.message || 'Failed to fetch pending invites',
      });
    }
  },
};
