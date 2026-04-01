import type { Response } from 'express';

/**
 * Standard API response envelope
 */
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  details?: any;
  message?: string;
}

/**
 * Send a success response
 */
export function sendSuccess<T>(
  res: Response,
  data: T,
  statusCode: number = 200,
): Response {
  return res.status(statusCode).json({
    success: true,
    data,
  } as ApiResponse<T>);
}

/**
 * Send an error response
 */
export function sendError(
  res: Response,
  error: string,
  statusCode: number = 400,
  details?: any,
): Response {
  const response: ApiResponse = {
    success: false,
    error,
  };

  if (details) {
    response.details = details;
  }

  return res.status(statusCode).json(response);
}

/**
 * Send a logout response
 */
export function sendLogout(res: Response): Response {
  return res.json({
    success: true,
    message: 'Logged out successfully',
  });
}
