import type { Router } from 'express';
import { AuthControllers } from 'controllers/auth.controller.ts';
import { registerSchema, loginSchema, refreshTokenSchema } from 'schema/auth.schema.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from 'middlewares/validate.middleware.ts';

export function setupAuthRoutes(router: Router) {
  // Public routes
  router.post('/auth/register',Validator.validateBody(registerSchema),  AuthControllers.register);
  router.post('/auth/login',Validator.validateBody(loginSchema), AuthControllers.login);
  router.post('/auth/refresh',Validator.validateBody(refreshTokenSchema), AuthControllers.refresh);
  router.post('/auth/logout', AuthControllers.logout);

  // Protected routes - require authentication only
  router.get('/auth/me',authenticate, authorise('user:read:own'), AuthControllers.getMe);
}
