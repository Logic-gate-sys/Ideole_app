import type { Request, Response, NextFunction } from "express";
import { verifyToken } from "../lib/index.ts";
import { prisma } from "../lib/prisma.ts";
import { authorize, buildAuthContext } from "../lib/index.ts";
import type { Permission } from "../lib/index.ts";

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
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
      return res
        .status(401)
        .json({ message: "Access Denied: No token provided" });
    }
    const payload = await verifyToken(token);

    if (!payload || payload.type !== "access") {
      return res.status(401).json({ error: "Invalid token" });
    }
    const {userId} = payload;
    console.log("USER ID", userId)
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    req.user = { id: user.id, email: user.email, role: user.role };
  } catch(err) {
    return res.status(401).json({ error: "Authentication failed with error", details:err.message});
  }
  
  // next middleware 
  next();
}

export async function optionalAuth(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
      // No token provided, continue without authentication
      return next();
    }

    const payload = await verifyToken(token);

    if (!payload || payload.type !== "access") {
      // Invalid token, continue without authentication
      return next();
    }

    const { userId } = payload;
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (user) {
      req.user = { id: user.id, email: user.email, role: user.role };
    }
  } catch (err) {
    // Error during optional auth, continue without authentication
  }

  next();
}

// authorisation
export function authorise(permission: Permission) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const user = req.user;
    try {
      // base context from user data
      // For user-scoped permissions, the user is the owner of their own resource
      let resource;
      
      if (permission.startsWith('user:')) {
        resource = { ownerId: user.id };
      } else if (permission.includes(':own') || permission.includes(':admin')) {
        // Get the resource ID - could be 'id', 'communityId', 'ideaId', or other resource identifiers
        const resourceId = (req.params.id || req.params.communityId || req.params.ideaId) as string;
        
        if (resourceId) {
          // For ownership checks with a specific resource ID
          if (permission.startsWith('organisation:')) {
            const org = await prisma.organisation.findUnique({
              where: { id: resourceId },
              select: { id: true, ownerId: true },
            });
            if (org) {
              resource = org;
            }
          } else if (permission.startsWith('community:')) {
            const community = await prisma.community.findUnique({
              where: { id: resourceId },
              select: { id: true, adminId: true },
            });
            // For communities, admins own them
            if (community) {
              resource = { id: community.id, ownerId: community.adminId };
            }
          } else if (permission.startsWith('membership:')) {
            // For membership admin operations, get the community
            const community = await prisma.community.findUnique({
              where: { id: resourceId },
              select: { id: true, adminId: true },
            });
            // For communities, admins own them
            if (community) {
              resource = { id: community.id, ownerId: community.adminId };
            }
          } else if (permission.startsWith('idea:')) {
            // For idea operations, get the idea
            const idea = await prisma.idea.findUnique({
              where: { id: resourceId },
              select: { id: true, ownerId: true },
            });
            if (idea) {
              resource = idea;
            }
          } else if (permission.startsWith('criteria:')) {
            // For criteria operations, get the idea via the ideaId param
            const ideaId = req.params.ideaId as string;
            if (ideaId) {
              const idea = await prisma.idea.findUnique({
                where: { id: ideaId },
                select: { id: true, ownerId: true },
              });
              if (idea) {
                resource = idea;
              }
            }
          }
        }
      }
      
      const userContext = buildAuthContext(user, resource);
      const result = authorize(user, permission, userContext);

      if (result) {
        return res.status(403).json({ error: "Unauthorised", ...result });
      }

      next();
    } catch (error) {
      return res.status(500).json({ error: "Authorization check failed" });
    }
  };
}
