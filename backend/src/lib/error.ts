import { ZodError } from 'zod';
import type { Response } from 'express';
import { sendError } from './response.ts';

/**
 * Handle errors in controllers with consistent format
 */
export function handleControllerError(error: any, res: Response): Response {
  // Zod validation error
  if (error instanceof ZodError) {
    return sendError(
      res,
      'Validation error',
      400,
      error.errors.map(e => ({
        path: e.path,
        message: e.message,
      })),
    );
  }

  // Generic error
  return sendError(res, error.message || 'Internal server error', 400);
}

/**
 * Handle authentication errors specifically
 */
export function handleAuthError(error: any, res: Response): Response {
  // Zod validation error
  if (error instanceof ZodError) {
    return sendError(
      res,
      'Validation error',
      400,
      error.errors.map(e => ({
        path: e.path,
        message: e.message,
      })),
    );
  }

  // Auth errors return 401
  return sendError(res, error.message || 'Authentication failed', 401);
}
