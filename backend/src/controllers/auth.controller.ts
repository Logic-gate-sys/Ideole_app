import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import { UserService } from '../services/user.service.ts';
import { SignupRequest, LoginRequest } from '../schema/ideole-auth.schema.ts';

export const AuthController = {
  /**
   * Signup - Register a new user
   * Request body: { name, email, password }
   * Returns: { success: true, data: { id, name, email, token } }
   */
  async signup(req: Request, res: Response) {
    try {
      const { name, email, password } = req.body as SignupRequest;

      // Hash password
      const passwordHash = await bcrypt.hash(password, 10);

      // Create user
      const user = await UserService.createUser({
        name,
        email,
        passwordHash,
      });

      // Generate token (for now, use userId as simple token)
      // In production: generate JWT
      const token = user.id;

      return res.status(201).json({
        success: true,
        data: {
          id: user.id,
          name: user.name,
          email: user.email,
          token,
        },
      });
    } catch (error: any) {
      // Check if user already exists
      if (error.message === 'User with this email already exists') {
        return res.status(409).json({
          success: false,
          error: error.message,
        });
      }

      console.error('Signup error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to create user',
      });
    }
  },

  /**
   * Login - Authenticate user
   * Request body: { email, password }
   * Returns: { success: true, data: { id, name, email, token } }
   */
  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body as LoginRequest;

      // Find user by email
      const user = await UserService.getUserByEmail(email);

      if (!user) {
        return res.status(401).json({
          success: false,
          error: 'Invalid email or password',
        });
      }

      // Compare passwords
      const isPasswordValid = await bcrypt.compare(password, user.passwordHash);

      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          error: 'Invalid email or password',
        });
      }

      // Generate token (for now, use userId as simple token)
      // In production: generate JWT
      const token = user.id;

      return res.status(200).json({
        success: true,
        data: {
          id: user.id,
          name: user.name,
          email: user.email,
          token,
        },
      });
    } catch (error: any) {
      console.error('Login error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to login',
      });
    }
  },
};
