import { Router } from 'express';
import { RatingController } from '../controllers/rating.controller.ts';
import { validateBody, validateParams } from '../middlewares/validate.middleware.ts';
import {
  createRatingSchema,
  ratingIdeaIdParamSchema,
} from '../schema/rating.schema.ts';

const ratingRouter = Router();

// POST /api/ideole/ideas/:ideaId/rate - Submit a rating
ratingRouter.post(
  '/ideas/:ideaId/rate',
  validateParams(ratingIdeaIdParamSchema),
  validateBody(createRatingSchema),
  RatingController.createRating
);

// GET /api/ideole/ideas/:ideaId/stats - Get aggregated rating stats
ratingRouter.get(
  '/ideas/:ideaId/stats',
  validateParams(ratingIdeaIdParamSchema),
  RatingController.getStats
);

// GET /api/ideole/ideas/:ideaId/ratings - Get all ratings for an idea
ratingRouter.get(
  '/ideas/:ideaId/ratings',
  validateParams(ratingIdeaIdParamSchema),
  RatingController.getIdeaRatings
);

export default ratingRouter;
