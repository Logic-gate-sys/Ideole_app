import type { Router } from 'express';
import { RatingControllers } from '../controllers/rating.controller.ts';
import { authenticate, authorise, optionalAuth } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createRatingSchema } from '../schema/rating.schema.ts';

export function setupRatingRoutes(router: Router) {
  router.post(
    '/ideas/:ideaId/rate',
    authenticate,
    authorise('rating:create'),
    Validator.validateBody(createRatingSchema),
    RatingControllers.createRating
  );

  router.get('/ideas/:ideaId/stats', optionalAuth, RatingControllers.getIdeaRatingStats);
  router.get('/ideas/:ideaId/ratings', optionalAuth, RatingControllers.getIdeaRatings);
}
