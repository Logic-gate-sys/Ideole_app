import { z } from 'zod';

export const updateUserSchema = z.object({
  username: z.string()
    .min(3, 'Username must be at least 3 characters')
    .max(30, 'Username must be 30 characters or less')
    .optional(),
  email: z.string()
    .email('Invalid email address')
    .optional(),
  profileUrl: z.string()
    .url('Invalid URL format')
    .optional(),
});

export type UpdateUserInput = z.infer<typeof updateUserSchema>;
