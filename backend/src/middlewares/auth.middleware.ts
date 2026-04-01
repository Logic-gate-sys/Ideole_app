import type { Request, Response, NextFunction } from "express";
import { verifyToken } from "../lib/index.ts";
import { prisma } from "../lib/prisma.ts";
import { authorize, buildAuthContext } from "../lib/index.ts";

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

    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
    });

    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    req.user = { id: user.id, email: user.email, role: user.role };
  } catch {
    return res.status(401).json({ error: "Authentication failed" });
  }
  
  // next middleware 
  next();
}


// authorisation
export function authorise(permission: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    // if you make it this far , user exists
    const user = req.user;
    try {
      // base context from user data
      const userContext = buildAuthContext(user);
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
