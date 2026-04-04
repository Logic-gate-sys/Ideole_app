import type { Request, Response } from 'express';
import { AuthService } from '../services/auth.service.ts';
import { generateAccessToken, generateRefreshToken, verifyToken } from '../lib/jwt.ts';
import { env } from '../../env.ts';

export const AuthControllers = {
  async register(req: Request, res:Response){
    try{
      const body = req.body; 
      const newUser = await AuthService.registerUser(body); 
      // access and refresh token 
      const payload = {
        userId: newUser.id,
        email:newUser.email,
        role: newUser.role,
      }
      const acessToken = await generateAccessToken({...payload, type:'access'}); 
      const refreshToken = await generateRefreshToken({...payload, type:'refresh'}); 
      //send refresh token to http-only
      res.cookie('refresh-token', refreshToken, {
             httpOnly:true,
             secure: env.NODE_ENV==='production'? true: false,
             maxAge:7*24*(1000*60*60),
             sameSite:'lax'
      })

      // return 
      return res.status(201).json({
        success:true, 
        data: newUser,
        token: acessToken
      })
    }catch(err){
        return res.status(500).json({
            message:'error',
            details: err.message
        })
    }
    
  },
  
  
  // login 
  async login(req: Request, res:Response){
    try{
      const body = req.body; 
      const user = await AuthService.loginUser(body); 
      // access and refresh token 
      const payload = {
        userId: user.id,
        email: user.email,
        role: user.role,
      }
      const acessToken = await generateAccessToken({...payload, type:'access'}); 
      const refreshToken = await generateRefreshToken({...payload, type:'refresh'}); 
      //send refresh token to http-only
      res.cookie('refresh-token', refreshToken, {
             httpOnly:true,
             secure: env.NODE_ENV==='production'? true: false,
             maxAge:7*24*(1000*60*60),
             sameSite:'lax'
      })

      // return 
      return res.status(200).json({
        success:true, 
        data: user,
        token: acessToken
      })
    }catch(err){
        return res.status(401).json({
            message:'error',
            details: err.message
        })
    }
    
  },

  // refresh token
  async refresh(req: Request, res: Response) {
    try {
      const { refreshToken } = req.body;

      const payload = await verifyToken(refreshToken);

      if (!payload || payload.type !== 'refresh') {
        return res.status(401).json({
          message: 'error',
          details: 'Invalid refresh token'
        });
      }

      const user = await AuthService.refreshAccessToken(payload.userId);

      // Generate new access token
      const newAccessToken = await generateAccessToken({
        userId: user.id,
        email: user.email,
        role: user.role,
        type: 'access'
      });

      return res.status(200).json({
        success: true,
        data: user,
        token: newAccessToken
      });
    } catch (err) {
      return res.status(401).json({
        message: 'error',
        details: err.message
      });
    }
  },

  // logout
  async logout(req: Request, res: Response) {
    try {
      await AuthService.logout();

      // Clear refresh token cookie
      res.clearCookie('refresh-token', {
        httpOnly: true,
        secure: env.NODE_ENV === 'production' ? true : false,
        sameSite: 'lax'
      });

      return res.status(200).json({
        success: true,
        message: 'Logged out successfully'
      });
    } catch (err) {
      return res.status(500).json({
        message: 'error',
        details: err.message
      });
    }
  },

  // get me
  async getMe(req: Request, res: Response) {
    try {
      const user = await AuthService.getMe(req.user.id);

      return res.status(200).json({
        success: true,
        data: user
      });
    } catch (err) {
      return res.status(401).json({
        message: 'error',
        details: err.message
      });
    }
  },

}
