import type { Router } from 'express';
import { IdeaControllers } from '../controllers/idea.controller.ts';
import { authenticate, authorise, optionalAuth } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createIdeaSchema, updateIdeaSchema, createCriteriaSchema, updateCriteriaSchema } from '../schema/idea.schema.ts';

export function setupIdeaRoutes(router: Router) {
  // Get all Ideas (feed) - optionalAuth allows public access with optional user context
  router.get('/ideas', optionalAuth, IdeaControllers.getAllIdeas);

  // Create Idea
  router.post(
    '/ideas',
    authenticate,
    authorise('idea:create'),
    Validator.validateBody(createIdeaSchema),
    IdeaControllers.createIdea
  );

  // Get single Idea - optionalAuth allows public access to public ideas
  router.get('/ideas/:ideaId', optionalAuth, IdeaControllers.getIdea);

  // Update Idea
  router.put(
    '/ideas/:ideaId',
    authenticate,
    authorise('idea:update:own'),
    Validator.validateBody(updateIdeaSchema),
    IdeaControllers.updateIdea
  );

  // Delete Idea
  router.delete(
    '/ideas/:ideaId',
    authenticate,
    authorise('idea:delete:own'),
    IdeaControllers.deleteIdea
  );

  // Get Idea's Evaluation Criteria - optionalAuth for public viewing
  router.get('/ideas/:ideaId/criteria', optionalAuth, IdeaControllers.getIdeaCriteria);

  // Create Evaluation Criteria
  router.post(
    '/ideas/:ideaId/criteria',
    authenticate,
    authorise('criteria:create:own'),
    Validator.validateBody(createCriteriaSchema),
    IdeaControllers.createCriteria
  );

  // Update Evaluation Criteria
  router.put(
    '/ideas/:ideaId/criteria/:criteriaId',
    authenticate,
    authorise('criteria:update:own'),
    Validator.validateBody(updateCriteriaSchema),
    IdeaControllers.updateCriteria
  );

  // Delete Evaluation Criteria
  router.delete(
    '/ideas/:ideaId/criteria/:criteriaId',
    authenticate,
    authorise('criteria:delete:own'),
    IdeaControllers.deleteCriteria
  );
}
