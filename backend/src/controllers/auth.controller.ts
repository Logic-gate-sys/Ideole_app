import type { Request, Response } from 'express';
import { AuthService } from '../services/auth.service.ts';
import { generateAccessToken, generateRefreshToken } from 'lib/jwt.ts';
import {env} from '../../env.ts'

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
      const user = req.user; 
      const newUser = await AuthService.registerUser(user); 
      // access and refresh token 
      const acessToken = await generateAccessToken(user); 
      const refreshToken = await generateRefreshToken(user); 
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

}


/*
router.post('/auth/register',Validator.validateBody(registerSchema),  AuthControllers.register);
  router.post('/auth/login',Validator.validateBody(loginSchema), AuthControllers.login);
  router.post('/auth/refresh',Validator.validateBody(refreshTokenSchema), AuthControllers.refresh);
  router.post('/auth/logout', AuthControllers.logout);

*/