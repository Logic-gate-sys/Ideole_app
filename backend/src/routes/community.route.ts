import type { Router } from 'express';
import { CommunityControllers } from '../controllers/community.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createCommunitySchema, updateCommunitySchema } from '../schema/community.schema.ts';

export function setupCommunityRoutes(router: Router) {
  // Create community
  router.post(
    '/organisations/:organisationId/communities',
    authenticate,
    authorise('community:create'),
    Validator.validateBody(createCommunitySchema),
    CommunityControllers.create
  );

  // Get community by id
  router.get(
    '/organisations/:organisationId/communities/:communityId',
    authenticate,
    authorise('community:read:all'),
    CommunityControllers.getById
  );

  // List communities in organisation
  router.get(
    '/organisations/:organisationId/communities',
    authenticate,
    authorise('community:read:all'),
    CommunityControllers.list
  );

  // Update community (admin only)
  router.put(
    '/organisations/:organisationId/communities/:communityId',
    authenticate,
    authorise('community:update:own'),
    Validator.validateBody(updateCommunitySchema),
    CommunityControllers.update
  );

  // Delete community (admin only)
  router.delete(
    '/organisations/:organisationId/communities/:communityId',
    authenticate,
    authorise('community:delete:own'),
    CommunityControllers.delete
  );
}
