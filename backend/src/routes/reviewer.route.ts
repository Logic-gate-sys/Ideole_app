import type { Router } from 'express';
import { ReviewerControllers } from '../controllers/reviewer.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';

export function setupReviewerRoutes(router: Router) {
  // Get all reviewers for an idea
  router.get(
    '/ideas/:ideaId/reviewers',
    authenticate,
    ReviewerControllers.getIdeaReviewers
  );

  // Invite a reviewer to an idea (idea owner only)
  router.post(
    '/ideas/:ideaId/reviewers',
    authenticate,
    ReviewerControllers.inviteReviewer
  );

  // Remove a reviewer from an idea (idea owner only)
  router.delete(
    '/ideas/:ideaId/reviewers/:reviewerId',
    authenticate,
    ReviewerControllers.removeReviewer
  );

  // Resend invitation to a pending reviewer (idea owner only)
  router.post(
    '/ideas/:ideaId/reviewers/:reviewerId/resend-invite',
    authenticate,
    ReviewerControllers.resendInvitation
  );

  // Cancel a pending invitation (idea owner only)
  router.delete(
    '/ideas/:ideaId/reviewers/:reviewerId/invite',
    authenticate,
    ReviewerControllers.cancelInvitation
  );

  // Accept an invitation (reviewer endpoint)
  router.post(
    '/ideas/:ideaId/reviewers/:reviewerId/accept',
    authenticate,
    ReviewerControllers.acceptInvitation
  );

  // Decline an invitation (reviewer endpoint)
  router.post(
    '/ideas/:ideaId/reviewers/:reviewerId/decline',
    authenticate,
    ReviewerControllers.declineInvitation
  );
}
