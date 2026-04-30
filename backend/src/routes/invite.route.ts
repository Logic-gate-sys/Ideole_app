import type { Router } from 'express';
import { InviteControllers } from '../controllers/invite.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { sendInviteSchema, respondInviteSchema } from '../schema/invite.schema.ts';

export function setupInviteRoutes(router: Router) {
  router.post(
    '/ideas/:ideaId/invite',
    authenticate,
    authorise('idea:invite:reviewer'),
    Validator.validateBody(sendInviteSchema),
    InviteControllers.sendInvite
  );

  router.patch(
    '/ideas/:ideaId/invite/:inviteId',
    authenticate,
    Validator.validateBody(respondInviteSchema),
    InviteControllers.respondToInvite
  );

  router.get(
    '/ideas/:ideaId/invites',
    authenticate,
    authorise('idea:invite:reviewer'),
    InviteControllers.getIdeaInvites
  );

  router.get('/user/invites/pending', authenticate, InviteControllers.getPendingInvites);
  router.get('/user/invites', authenticate, InviteControllers.getUserInvites);

  // Alias endpoints that follow the same pattern as other user-scoped routes.
  router.get('/users/me/invites/pending', authenticate, InviteControllers.getPendingInvites);
  router.get('/users/me/invites', authenticate, InviteControllers.getUserInvites);
}
