import { Router } from 'express';
import { IdeaController } from '../controllers/idea.controller.ts';
import { validateBody, validateParams, validateQuery } from '../middlewares/validate.middleware.ts';
import {
  createIdeaSchema,
  updateIdeaSchema,
  togglePublicSchema,
  ideaIdParamSchema,
  getIdeasQuerySchema,
} from '../schema/idea.schema.ts';

const ideaRouter = Router();

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

export default ideaRouter;
