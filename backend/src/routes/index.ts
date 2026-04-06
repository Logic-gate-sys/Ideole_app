import { Router } from 'express';
import { setupAuthRoutes } from './auth.route.ts';
import { setupOrganisationRoutes } from './organisation.route.ts';
import { setupCommunityRoutes } from './community.route.ts';
import { setupUserRoutes } from './user.route.ts';
import { setupMembershipRoutes } from './membership.route.ts';
import { setupIdeaRoutes } from './idea.route.ts';
import { setupReviewerRoutes } from './reviewer.route.ts';

const router = Router();

// Setup all routes
setupAuthRoutes(router);
setupOrganisationRoutes(router);
setupCommunityRoutes(router);
setupUserRoutes(router);
setupMembershipRoutes(router);
setupIdeaRoutes(router);
setupReviewerRoutes(router);

export default router;
