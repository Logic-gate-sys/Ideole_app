import type { Request, Response, NextFunction } from 'express';
import { verifyToken } from '../lib/index.ts';
import { prisma } from '../lib/prisma.ts';
import { authorize, buildAuthContext } from '../lib/index.ts';


declare global {
  namespace Express {
    interface Request {
      user?: any;
    }
  }
}


export async function authenticate(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next();
  }

  try {
    const token = authHeader.slice(7);
    const payload = await verifyToken(token);

    if (!payload || payload.type !== 'access') {
      return res.status(401).json({ error: 'Invalid token' });
    }

    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
    });

    if (!user) {
      return res.status(401).json({ error: 'User not found' });
    }

    req.user = user;
  } catch {
    return res.status(401).json({ error: 'Authentication failed' });
  }

  next();
}


/**
 * Authorise: Check if authenticated user has permission
 * Uses full RBAC authorization with contextual checks
 * 
 * @param permission - Permission to check (e.g., 'idea:create')
 * @param getContext - Optional async function to build rich authorization context
 * 
 * @example
 * router.get('/ideas/:id', authorise('idea:read:own', async (req) => ({
 *   isOwner: idea.ownerId === req.user?.id,
 *   resourceVisibility: idea.visibility
 * })), handler)
 */
export function authorise(
  permission: string,
  getContext?: (req: Request) => Promise<Record<string, any>>,
) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const user = req.user;

    if (!user) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    try {
      // Build base context from user data
      const baseContext = buildAuthContext(user);

      // Merge with optional extra context from route handler
      const extraContext = getContext ? await getContext(req) : {};
      const fullContext = { ...baseContext, ...extraContext };

      // Perform full authorization check
      const result = authorize(user, permission, fullContext);

      if (result) {
        return res.status(403).json({ error: 'unauthorised', ...result });
      }

      next();
    } catch (error) {
      return res.status(500).json({ error: 'Authorization check failed' });
    }
  };
}
