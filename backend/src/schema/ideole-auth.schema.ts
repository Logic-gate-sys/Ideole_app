import { z } from 'zod';

// Signup schema - register new user
export const signupSchema = z.object({
  name: z.string()
    .min(2, 'Name must be at least 2 characters')
    .max(100, 'Name must not exceed 100 characters'),
  email: z.string()
    .email('Please provide a valid email address'),
  password: z.string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
    .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
    .regex(/[0-9]/, 'Password must contain at least one number'),
});

// Login schema
export const loginSchema = z.object({
  email: z.string()
    .email('Please provide a valid email address'),
  password: z.string()
    .min(8, 'Password must be at least 8 characters'),
});

// Export types for TypeScript
export type SignupRequest = z.infer<typeof signupSchema>;
export type LoginRequest = z.infer<typeof loginSchema>;
