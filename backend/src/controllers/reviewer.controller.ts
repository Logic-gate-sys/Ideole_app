import type { Request, Response } from 'express';
import { ReviewerService } from '../services/reviewer.service.ts';

export const ReviewerControllers = {
  /**
   * GET /ideas/:ideaId/reviewers
   * Get all reviewers for an idea
   */
  async getIdeaReviewers(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;

      if (!ideaId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID is required',
        });
      }

      const reviewers = await ReviewerService.getIdeaReviewers(ideaId);

      return res.status(200).json({
        success: true,
        data: reviewers,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  /**
   * DELETE /ideas/:ideaId/reviewers/:reviewerId
   * Remove a reviewer from an idea
   */
  async removeReviewer(req: Request, res: Response) {
    try {
      const { ideaId, reviewerId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      // Check authorization
      const canManage = await ReviewerService.canManageReviewers(ideaId, userId);
      if (!canManage) {
        return res.status(403).json({
          message: 'error',
          details: 'You do not have permission to manage reviewers for this idea',
        });
      }

      await ReviewerService.removeReviewer(ideaId, reviewerId);

      return res.status(200).json({
        success: true,
        message: 'Reviewer removed successfully',
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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

  /**
   * POST /ideas/:ideaId/reviewers/:reviewerId/resend-invite
   * Resend invitation to a pending reviewer
   */
  async resendInvitation(req: Request, res: Response) {
    try {
      const { ideaId, reviewerId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      // Check authorization
      const canManage = await ReviewerService.canManageReviewers(ideaId, userId);
      if (!canManage) {
        return res.status(403).json({
          message: 'error',
          details: 'You do not have permission to manage reviewers for this idea',
        });
      }

      await ReviewerService.resendInvitation(ideaId, reviewerId);

      return res.status(200).json({
        success: true,
        message: 'Invitation resent successfully',
      });
    } catch (err: any) {
      if (err.message.includes('not found') || err.message.includes('pending')) {
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

  /**
   * DELETE /ideas/:ideaId/reviewers/:reviewerId/invite
   * Cancel a pending invitation
   */
  async cancelInvitation(req: Request, res: Response) {
    try {
      const { ideaId, reviewerId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      // Check authorization
      const canManage = await ReviewerService.canManageReviewers(ideaId, userId);
      if (!canManage) {
        return res.status(403).json({
          message: 'error',
          details: 'You do not have permission to manage reviewers for this idea',
        });
      }

      await ReviewerService.cancelInvitation(ideaId, reviewerId);

      return res.status(200).json({
        success: true,
        message: 'Invitation cancelled successfully',
      });
    } catch (err: any) {
      if (err.message.includes('not found') || err.message.includes('pending')) {
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

  /**
   * POST /ideas/:ideaId/reviewers
   * Invite a reviewer to an idea
   */
  async inviteReviewer(req: Request, res: Response) {
    try {
      const { ideaId } = req.params;
      const { reviewerId } = req.body;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      // Check authorization
      const canManage = await ReviewerService.canManageReviewers(ideaId, userId);
      if (!canManage) {
        return res.status(403).json({
          message: 'error',
          details: 'You do not have permission to manage reviewers for this idea',
        });
      }

      const invite = await ReviewerService.inviteReviewer(ideaId, reviewerId);

      return res.status(201).json({
        success: true,
        data: invite,
        message: 'Reviewer invited successfully',
      });
    } catch (err: any) {
      if (err.message.includes('already invited') || err.message.includes('not found')) {
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

  /**
   * POST /ideas/:ideaId/reviewers/:reviewerId/accept
   * Accept a reviewer invitation (reviewer endpoint)
   */
  async acceptInvitation(req: Request, res: Response) {
    try {
      const { ideaId, reviewerId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      // Ensure reviewer is accepting their own invitation
      if (userId !== reviewerId) {
        return res.status(403).json({
          message: 'error',
          details: 'You can only accept your own invitations',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      await ReviewerService.acceptInvitation(ideaId, reviewerId);

      return res.status(200).json({
        success: true,
        message: 'Invitation accepted successfully',
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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

  /**
   * POST /ideas/:ideaId/reviewers/:reviewerId/decline
   * Decline a reviewer invitation (reviewer endpoint)
   */
  async declineInvitation(req: Request, res: Response) {
    try {
      const { ideaId, reviewerId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      // Ensure reviewer is declining their own invitation
      if (userId !== reviewerId) {
        return res.status(403).json({
          message: 'error',
          details: 'You can only decline your own invitations',
        });
      }

      if (!ideaId || !reviewerId) {
        return res.status(400).json({
          message: 'error',
          details: 'Idea ID and Reviewer ID are required',
        });
      }

      await ReviewerService.declineInvitation(ideaId, reviewerId);

      return res.status(200).json({
        success: true,
        message: 'Invitation declined successfully',
      });
    } catch (err: any) {
      if (err.message.includes('not found')) {
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
};
