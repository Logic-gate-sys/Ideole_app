import type { Request, Response } from 'express';
import { AuthService } from '../services/auth.service.ts';
import { sendSuccess, sendLogout } from '../lib/response.ts';
import { handleControllerError, handleAuthError } from '../lib/error.ts';

export const AuthControllers = {
  async register(req: Request, res: Response) {
    try {
      const result = await AuthService.registerUser(req.body);
      return sendSuccess(res, result, 201);
    } catch (error) {
      return handleControllerError(error, res);
    }
  },

  async login(req: Request, res: Response) {
    try {
      const result = await AuthService.loginUser(req.body);
      return sendSuccess(res, result);
    } catch (error) {
      return handleAuthError(error, res);
    }
  },

  async refresh(req: Request, res: Response) {
    try {
      const result = await AuthService.refreshAccessToken(req.body.refreshToken);
      return sendSuccess(res, result);
    } catch (error) {
      return handleAuthError(error, res);
    }
  }, 

async logout(req: Request, res: Response){
  return sendLogout(res);
},

async getMe(req: Request, res: Response){
  if (!req.user) {
    return handleAuthError(new Error('Not authenticated'), res);
  }

  const userData = {
    id: req.user.id,
    username: req.user.username,
    email: req.user.email,
    role: req.user.role,
    profileUrl: req.user.profileUrl,
  };

  return sendSuccess(res, userData);
}

}
