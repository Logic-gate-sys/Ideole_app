import type { Router } from 'express';
import { UserControllers } from '../controllers/user.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { updateUserSchema } from '../schema/user.schema.ts';

export function setupUserRoutes(router: Router) {
  // Get user by ID (public profile)
  router.get(
    '/users/:userId',
    UserControllers.getUserById
  );

  // Update user profile (authenticated)
  router.put(
    '/users/me',
    authenticate,
    authorise('user:update:own'),
    Validator.validateBody(updateUserSchema),
    UserControllers.updateProfile
  );

  // Update last active timestamp
  router.patch(
    '/users/me/active',
    authenticate,
    authorise('user:update:own'),
    UserControllers.updateLastActive
  );

  // Get user's memberships
  router.get(
    '/users/me/memberships',
    authenticate,
    authorise('user:read:own'),
    UserControllers.getMemberships
  );

  // Get user's ideas
  router.get(
    '/users/me/ideas',
    authenticate,
    authorise('user:read:own'),
    UserControllers.getIdeas
  );
}
