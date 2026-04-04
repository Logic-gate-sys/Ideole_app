import { z } from 'zod';

export const createCommunitySchema = z.object({
  name: z.string().min(1, 'Community name is required').max(100),
  description: z.string().max(500).optional(),
  visibility: z.enum(['PUBLIC', 'PROTECTED', 'PRIVATE']).default('PRIVATE'),
});

export const updateCommunitySchema = z.object({
  name: z.string().min(1).max(100).optional(),
  description: z.string().max(500).optional(),
  visibility: z.enum(['PUBLIC', 'PROTECTED', 'PRIVATE']).optional(),
});

export type CreateCommunityInput = z.infer<typeof createCommunitySchema>;
export type UpdateCommunityInput = z.infer<typeof updateCommunitySchema>;
