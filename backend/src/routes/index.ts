import { Router } from 'express';
import { authMiddleware } from '../middlewares/auth.middleware.ts';
import ideaRouter from './idea.route.ts';
import ratingRouter from './rating.route.ts';
import inviteRouter from './invite.route.ts';
import commentRouter from './comment.route.ts';

const apiRouter = Router();

// Apply auth middleware to all ideole routes
apiRouter.use(authMiddleware);

// Mount feature routers
apiRouter.use(ideaRouter);
apiRouter.use(ratingRouter);
apiRouter.use(inviteRouter);
apiRouter.use(commentRouter);

export default apiRouter;