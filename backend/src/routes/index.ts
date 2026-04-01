import { Router } from 'express';
import { authenticate } from '../middlewares/auth.middleware.ts';
import { setupAuthRoutes } from './auth.route.ts';

const router = Router();

// Apply authentication middleware globally (optional)
router.use(authenticate);

// Setup all routes
setupAuthRoutes(router);

export default router;
