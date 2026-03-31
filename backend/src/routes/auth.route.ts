import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller.ts';
import { validateBody } from '../middlewares/validate.middleware.ts';
import { signupSchema, loginSchema } from '../schema/ideole-auth.schema.ts';

const authRouter = Router();

// Public auth routes (no auth middleware required)
authRouter.post('/auth/signup', validateBody(signupSchema), (req, res) => {
  return AuthController.signup(req, res);
});

authRouter.post('/auth/login', validateBody(loginSchema), (req, res) => {
  return AuthController.login(req, res);
});

export default authRouter;
