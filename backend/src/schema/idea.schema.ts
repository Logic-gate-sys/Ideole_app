import { z } from 'zod';
import { Visibility } from '../types/index.ts';

// Create idea schema
export const createIdeaSchema = z.object({
  title: z.string()
    .min(5, 'Title must be at least 5 characters')
    .max(200, 'Title must not exceed 200 characters'),
  problemText: z.string()
    .min(10, 'Problem description must be at least 10 characters')
    .max(2000, 'Problem description must not exceed 2000 characters'),
  solutionText: z.string()
    .min(10, 'Solution description must be at least 10 characters')
    .max(2000, 'Solution description must not exceed 2000 characters'),
  category: z.string()
    .min(2, 'Category must be provided')
    .max(50, 'Category must not exceed 50 characters'),
  visibility: z.enum(['PRIVATE', 'COMMUNITY', 'PUBLIC'])
    .default('PRIVATE'),
});

// Update idea schema
export const updateIdeaSchema = z.object({
  title: z.string()
    .min(5, 'Title must be at least 5 characters')
    .max(200, 'Title must not exceed 200 characters')
    .optional(),
  problemText: z.string()
    .min(10, 'Problem description must be at least 10 characters')
    .max(2000, 'Problem description must not exceed 2000 characters')
    .optional(),
  solutionText: z.string()
    .min(10, 'Solution description must be at least 10 characters')
    .max(2000, 'Solution description must not exceed 2000 characters')
    .optional(),
  category: z.string()
    .min(2, 'Category must be provided')
    .max(50, 'Category must not exceed 50 characters')
    .optional(),
  visibility: z.enum(['PRIVATE', 'COMMUNITY', 'PUBLIC'])
    .optional(),
});

// Toggle idea visibility schema
export const togglePublicSchema = z.object({
  isPublic: z.boolean(),
});

// Idea ID parameter schema
export const ideaIdParamSchema = z.object({
  ideaId: z.string().uuid('Invalid idea ID format'),
});

// Query schema for getting ideas
export const getIdeasQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1).catch(1),
  limit: z.coerce.number().int().min(1).default(10).catch(10),
  visibility: z.string()
    .transform(v => v.split(',').map((item: string) => item.trim()))
    .refine(
      items => items.every(item => ['PRIVATE', 'COMMUNITY', 'PUBLIC'].includes(item)),
      'Each visibility value must be PRIVATE, COMMUNITY, or PUBLIC'
    )
    .optional(),
});

// Export types
export type CreateIdeaRequest = z.infer<typeof createIdeaSchema>;
export type UpdateIdeaRequest = z.infer<typeof updateIdeaSchema>;
export type TogglePublicRequest = z.infer<typeof togglePublicSchema>;
export type IdeaIdParam = z.infer<typeof ideaIdParamSchema>;
export type GetIdeasQuery = z.infer<typeof getIdeasQuerySchema>;
