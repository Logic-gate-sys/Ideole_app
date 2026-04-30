import type { Router } from 'express';
import { CommentControllers } from '../controllers/comment.controller.ts';
import { authenticate, authorise, optionalAuth } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createCommentSchema } from '../schema/comment.schema.ts';

export function setupCommentRoutes(router: Router) {
  router.get('/ideas/:ideaId/comments', optionalAuth, CommentControllers.getIdeaComments);

  router.post(
    '/ideas/:ideaId/comments',
    authenticate,
    authorise('comment:create'),
    Validator.validateBody(createCommentSchema),
    CommentControllers.createComment
  );

  router.delete(
    '/ideas/:ideaId/comments/:commentId',
    authenticate,
    authorise('comment:delete:own'),
    CommentControllers.deleteComment
  );
}
