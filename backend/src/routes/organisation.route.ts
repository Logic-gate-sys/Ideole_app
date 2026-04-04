import type { Router } from 'express';
import { OrganisationControllers } from '../controllers/organisation.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createOrganisationSchema, updateOrganisationSchema } from '../schema/organisation.schema.ts';

export function setupOrganisationRoutes(router: Router) {
  // Create organisation
  router.post(
    '/organisations',
    authenticate,
    authorise('organisation:create'),
    Validator.validateBody(createOrganisationSchema),
    OrganisationControllers.create
  );

  // Get organisation by id
  router.get(
    '/organisations/:id',
    authenticate,
    authorise('organisation:read:own'),
    OrganisationControllers.getById
  );

  // List user's organisations
  router.get(
    '/organisations',
    authenticate,
    authorise('organisation:read:own'),
    OrganisationControllers.list
  );

  // Update organisation
  router.put(
    '/organisations/:id',
    authenticate,
    authorise('organisation:update:own'),
    Validator.validateBody(updateOrganisationSchema),
    OrganisationControllers.update
  );

  // Delete organisation
  router.delete(
    '/organisations/:id',
    authenticate,
    authorise('organisation:delete:own'),
    OrganisationControllers.delete
  );
}
