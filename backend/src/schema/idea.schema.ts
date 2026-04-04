import { z } from 'zod';

export const createIdeaSchema = z.object({
  title: z.string().min(3).max(200),
  description: z.string().min(10).max(5000),
  visibility: z.enum(['PUBLIC', 'PROTECTED', 'PRIVATE']),
  communityId: z.string().uuid().optional(),
  organisationId: z.string().uuid().optional(),
  criteria: z
    .array(
      z.object({
        name: z.string().min(2).max(100),
        description: z.string().min(5).max(500),
      })
    )
    .optional(),
});

export const updateIdeaSchema = z.object({
  title: z.string().min(3).max(200).optional(),
  description: z.string().min(10).max(5000).optional(),
  visibility: z.enum(['PUBLIC', 'PROTECTED', 'PRIVATE']).optional(),
  stage: z.enum(['INCEPTION', 'COLLABORATIVE', 'IMPLEMENTATION']).optional(),
});

export const createCriteriaSchema = z.object({
  name: z.string().min(2).max(100),
  description: z.string().min(5).max(500),
});

export const updateCriteriaSchema = z.object({
  name: z.string().min(2).max(100).optional(),
  description: z.string().min(5).max(500).optional(),
  order: z.number().int().min(0).optional(),
});
