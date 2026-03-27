import { z } from 'zod';

// Update user profile schema
export const updateProfileSchema = z.object({
  body: z.object({
    name: z.string()
      .min(2, 'Name must be at least 2 characters')
      .max(100, 'Name must not exceed 100 characters')
      .optional(),
    skills: z.array(z.string())
      .max(20, 'Cannot add more than 20 skills')
      .optional(),
  }),
});

// User ID parameter schema
export const userIdParamSchema = z.object({
  params: z.object({
    userId: z.string().uuid('Invalid user ID format'),
  }),
});

// Export types
export type UpdateProfileRequest = z.infer<typeof updateProfileSchema>;
export type UserIdParam = z.infer<typeof userIdParamSchema>;