import { Router } from 'express';
import { authMiddleware } from '../middlewares/auth.middleware.ts';
import { IdeaController } from '../controllers/idea.controller.ts';
import { RatingController } from '../controllers/rating.controller.ts';
import { InviteController } from '../controllers/ideole-invite.controller.ts';
import { CommentController } from '../controllers/ideole-comment.controller.ts';
import { validateBody, validateParams, validateQuery } from '../middlewares/validate.middleware.ts';
import {
  createIdeaSchema,
  updateIdeaSchema,
  togglePublicSchema,
  ideaIdParamSchema,
  getIdeasQuerySchema,
} from '../schema/idea.schema.ts';
import {
  createRatingSchema,
  ratingIdeaIdParamSchema,
} from '../schema/rating.schema.ts';
import {
  createInviteSchema,
  inviteIdParamSchema,
  getInvitesParamSchema,
} from '../schema/invite.schema.ts';
import {
  createCommentSchema,
  commentIdParamSchema,
  getCommentsParamSchema,
  commentPaginationQuerySchema,
} from '../schema/comment.schema.ts';

const ideaRouter = Router();

// Apply auth middleware to all routes
ideaRouter.use(authMiddleware);

// POST /api/ideole/ideas - Create new idea
ideaRouter.post(
  '/ideas',
  validateBody(createIdeaSchema),
  IdeaController.createIdea
);

// GET /api/ideole/ideas - Get visible ideas for user (public + own + invited)
ideaRouter.get(
  '/ideas',
  validateQuery(getIdeasQuerySchema),
  IdeaController.getIdeas
);

// GET /api/ideole/user/ideas - Get user's own ideas
ideaRouter.get(
  '/user/ideas',
  IdeaController.getUserIdeas
);

// GET /api/ideole/ideas/:ideaId - Get single idea details
ideaRouter.get(
  '/ideas/:ideaId',
  validateParams(ideaIdParamSchema),
  IdeaController.getIdeaById
);

// PATCH /api/ideole/ideas/:ideaId - Update idea
ideaRouter.patch(
  '/ideas/:ideaId',
  validateParams(ideaIdParamSchema),
  validateBody(updateIdeaSchema),
  IdeaController.updateIdea
);

// PATCH /api/ideole/ideas/:ideaId/public - Toggle public visibility
ideaRouter.patch(
  '/ideas/:ideaId/public',
  validateParams(ideaIdParamSchema),
  validateBody(togglePublicSchema),
  IdeaController.togglePublic
);

// ========== RATING ENDPOINTS ==========

// POST /api/ideole/ideas/:ideaId/rate - Submit a rating
ideaRouter.post(
  '/ideas/:ideaId/rate',
  validateParams(ratingIdeaIdParamSchema),
  validateBody(createRatingSchema),
  RatingController.createRating
);

// GET /api/ideole/ideas/:ideaId/stats - Get aggregated rating stats
ideaRouter.get(
  '/ideas/:ideaId/stats',
  validateParams(ratingIdeaIdParamSchema),
  RatingController.getStats
);

// GET /api/ideole/ideas/:ideaId/ratings - Get all ratings for an idea
ideaRouter.get(
  '/ideas/:ideaId/ratings',
  validateParams(ratingIdeaIdParamSchema),
  RatingController.getIdeaRatings
);

// ========== INVITE ENDPOINTS ==========

// POST /api/ideole/ideas/:ideaId/invite - Send invitation
ideaRouter.post(
  '/ideas/:ideaId/invite',
  validateParams(getInvitesParamSchema),
  validateBody(createInviteSchema),
  InviteController.sendInvite
);

// PATCH /api/ideole/ideas/:ideaId/invite/:inviteId - Accept invitation
ideaRouter.patch(
  '/ideas/:ideaId/invite/:inviteId',
  validateParams(inviteIdParamSchema),
  InviteController.acceptInvite
);

// GET /api/ideole/ideas/:ideaId/invites - Get all invites for an idea
ideaRouter.get(
  '/ideas/:ideaId/invites',
  validateParams(getInvitesParamSchema),
  InviteController.getIdeaInvites
);

// GET /api/ideole/user/invites - Get user's received invites
ideaRouter.get(
  '/user/invites',
  InviteController.getUserInvites
);

// GET /api/ideole/user/invites/pending - Get pending invites
ideaRouter.get(
  '/user/invites/pending',
  InviteController.getPendingInvites
);

// ========== COMMENT ENDPOINTS ==========

// POST /api/ideole/ideas/:ideaId/comments - Create a comment
ideaRouter.post(
  '/ideas/:ideaId/comments',
  validateParams(getCommentsParamSchema),
  validateBody(createCommentSchema),
  CommentController.createComment
);

// GET /api/ideole/ideas/:ideaId/comments - Get all comments for an idea
ideaRouter.get(
  '/ideas/:ideaId/comments',
  validateParams(getCommentsParamSchema),
  validateQuery(commentPaginationQuerySchema),
  CommentController.getComments
);

// DELETE /api/ideole/ideas/:ideaId/comments/:commentId - Delete a comment
ideaRouter.delete(
  '/ideas/:ideaId/comments/:commentId',
  validateParams(commentIdParamSchema),
  CommentController.deleteComment
);

export default ideaRouter;
