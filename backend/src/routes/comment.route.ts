import { Router } from 'express';
import { CommentController } from '../controllers/ideole-comment.controller.ts';
import { validateBody, validateParams, validateQuery } from '../middlewares/validate.middleware.ts';
import {
  createCommentSchema,
  commentIdParamSchema,
  getCommentsParamSchema,
  commentPaginationQuerySchema,
} from '../schema/comment.schema.ts';

const commentRouter = Router();

// POST /api/ideole/ideas/:ideaId/comments - Create a comment
commentRouter.post(
  '/ideas/:ideaId/comments',
  validateParams(getCommentsParamSchema),
  validateBody(createCommentSchema),
  CommentController.createComment
);

// GET /api/ideole/ideas/:ideaId/comments - Get all comments for an idea
commentRouter.get(
  '/ideas/:ideaId/comments',
  validateParams(getCommentsParamSchema),
  validateQuery(commentPaginationQuerySchema),
  CommentController.getComments
);

// DELETE /api/ideole/ideas/:ideaId/comments/:commentId - Delete a comment
commentRouter.delete(
  '/ideas/:ideaId/comments/:commentId',
  validateParams(commentIdParamSchema),
  CommentController.deleteComment
);

export default commentRouter;
