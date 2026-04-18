import { Router } from 'express';
import { setupAuthRoutes } from './auth.route.ts';
import { setupOrganisationRoutes } from './organisation.route.ts';
import { setupCommunityRoutes } from './community.route.ts';
import { setupUserRoutes } from './user.route.ts';
import { setupMembershipRoutes } from './membership.route.ts';
import { setupIdeaRoutes } from './idea.route.ts';
import { setupRatingRoutes } from './rating.route.ts';
import { setupCommentRoutes } from './comment.route.ts';
import { setupInviteRoutes } from './invite.route.ts';
import { setupConversationRoutes } from './conversation.route.ts';
import { setupNotificationRoutes } from './notification.route.ts';

const router = Router();

// Setup all routes
setupAuthRoutes(router);
setupOrganisationRoutes(router);
setupCommunityRoutes(router);
setupUserRoutes(router);
setupMembershipRoutes(router);
setupIdeaRoutes(router);
setupRatingRoutes(router);
setupCommentRoutes(router);
setupInviteRoutes(router);
setupConversationRoutes(router);
setupNotificationRoutes(router);

export default router;
