import type { Router } from 'express';
import { NotificationControllers } from '../controllers/notification.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';

export function setupNotificationRoutes(router: Router) {
  router.get(
    '/users/me/notifications',
    authenticate,
    authorise('user:read:own'),
    NotificationControllers.getUserNotifications
  );

  router.get(
    '/notifications',
    authenticate,
    authorise('user:read:own'),
    NotificationControllers.getUserNotifications
  );
}
