import type { Request, Response } from 'express';
import { MembershipService } from '../services/membership.service.ts';

export const MembershipControllers = {
  async requestToJoin(req: Request, res: Response) {
    try {
      const { communityId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const membership = await MembershipService.requestToJoinCommunity(userId, communityId);

      return res.status(201).json({
        success: true,
        data: membership,
      });
    } catch (err: any) {
      if (err.message === 'Community not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('already a member')) {
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

  async getPendingRequests(req: Request, res: Response) {
    try {
      const { communityId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const pendingMembers = await MembershipService.getPendingMembershipRequests(communityId, userId);

      return res.status(200).json({
        success: true,
        data: pendingMembers,
      });
    } catch (err: any) {
      if (err.message === 'Community not found') {
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

  async approveMembershipRequest(req: Request, res: Response) {
    try {
      const { communityId, membershipId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const membership = await MembershipService.approveMembershipRequest(
        communityId,
        membershipId,
        userId
      );

      return res.status(200).json({
        success: true,
        data: membership,
      });
    } catch (err: any) {
      if (err.message === 'Membership request not found') {
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

  async rejectMembershipRequest(req: Request, res: Response) {
    try {
      const { communityId, membershipId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await MembershipService.rejectMembershipRequest(
        communityId,
        membershipId,
        userId
      );

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      if (err.message === 'Membership request not found') {
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

  async removeMember(req: Request, res: Response) {
    try {
      const { communityId, membershipId } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const result = await MembershipService.removeMemberFromCommunity(
        communityId,
        membershipId,
        userId
      );

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      if (err.message === 'Membership not found') {
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

  async getCommunityMembers(req: Request, res: Response) {
    try {
      const { communityId } = req.params;

      const members = await MembershipService.getCommunityMembers(communityId);

      return res.status(200).json({
        success: true,
        data: members,
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
};
