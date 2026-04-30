import { z } from 'zod';

export const createRatingSchema = z.object({
  originality: z.number().int().min(1).max(10),
  feasibility: z.number().int().min(1).max(10),
  impact: z.number().int().min(1).max(10),
});
