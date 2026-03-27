import { z } from 'zod';

// Create rating schema
export const createRatingSchema = z.object({
  originality: z.number()
    .int('Originality must be an integer')
    .min(1, 'Originality must be at least 1')
    .max(10, 'Originality must not exceed 10'),
  feasibility: z.number()
    .int('Feasibility must be an integer')
    .min(1, 'Feasibility must be at least 1')
    .max(10, 'Feasibility must not exceed 10'),
  impact: z.number()
    .int('Impact must be an integer')
    .min(1, 'Impact must be at least 1')
    .max(10, 'Impact must not exceed 10'),
});

// Idea ID parameter schema (for rating endpoints)
export const ratingIdeaIdParamSchema = z.object({
  ideaId: z.string().uuid('Invalid idea ID format'),
});

// Export types
export type CreateRatingRequest = z.infer<typeof createRatingSchema>;
export type RatingIdeaIdParam = z.infer<typeof ratingIdeaIdParamSchema>;
