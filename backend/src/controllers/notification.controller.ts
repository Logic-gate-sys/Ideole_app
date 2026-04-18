import type { Request, Response } from 'express';
import { NotificationService } from '../services/notification.service.ts';

export const NotificationControllers = {
  async getUserNotifications(req: Request, res: Response) {
    try {
      const userId = req.user?.id;
      const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : 50;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const notifications = await NotificationService.getUserNotifications(userId, limit);

      return res.status(200).json({
        success: true,
        data: notifications,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },
};
