import { Router } from 'express';
import { InviteController } from '../controllers/ideole-invite.controller.ts';
import { validateBody, validateParams } from '../middlewares/validate.middleware.ts';
import {
  createInviteSchema,
  inviteIdParamSchema,
  getInvitesParamSchema,
} from '../schema/invite.schema.ts';

const inviteRouter = Router();

// POST /api/ideole/ideas/:ideaId/invite - Send invitation
inviteRouter.post(
  '/ideas/:ideaId/invite',
  validateParams(getInvitesParamSchema),
  validateBody(createInviteSchema),
  InviteController.sendInvite
);

// PATCH /api/ideole/ideas/:ideaId/invite/:inviteId - Accept invitation
inviteRouter.patch(
  '/ideas/:ideaId/invite/:inviteId',
  validateParams(inviteIdParamSchema),
  InviteController.acceptInvite
);

// GET /api/ideole/ideas/:ideaId/invites - Get all invites for an idea
inviteRouter.get(
  '/ideas/:ideaId/invites',
  validateParams(getInvitesParamSchema),
  InviteController.getIdeaInvites
);

// GET /api/ideole/user/invites - Get user's received invites
inviteRouter.get(
  '/user/invites',
  InviteController.getUserInvites
);

// GET /api/ideole/user/invites/pending - Get pending invites
inviteRouter.get(
  '/user/invites/pending',
  InviteController.getPendingInvites
);

export default inviteRouter;
