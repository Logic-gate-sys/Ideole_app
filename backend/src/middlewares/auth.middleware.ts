import { Request, Response, NextFunction } from 'express';

/**
 * Auth middleware - Extract user ID from Authorization header
 * For testing purposes, accepts Bearer token with userId
 * In production, this would validate a JWT token
 */
export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, error: 'Missing Authorization header' });
    }

    // Extract token (userId for testing, JWT in production)
    const token = authHeader.substring(7);
    
    // For testing: token is the user ID
    // In production: decode JWT and extract userId
    (req as any).user = { id: token };
    
    next();
  } catch (error) {
    return res.status(401).json({ success: false, error: 'Invalid Authorization header' });
  }
};
