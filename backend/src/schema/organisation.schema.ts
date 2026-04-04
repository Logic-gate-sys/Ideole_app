import { z } from 'zod';

export const createOrganisationSchema = z.object({
  name: z.string()
    .min(1, 'Organization name is required')
    .max(100, 'Organization name must be 100 characters or less'),
  tier: z.enum(['starter', 'professional', 'enterprise']).default('starter'),
});

export const updateOrganisationSchema = z.object({
  name: z.string()
    .min(1, 'Organization name is required')
    .max(100, 'Organization name must be 100 characters or less')
    .optional(),
  tier: z.enum(['starter', 'professional', 'enterprise']).optional(),
  maxCommunities: z.number().int().positive().optional(),
});

export type CreateOrganisationInput = z.infer<typeof createOrganisationSchema>;
export type UpdateOrganisationInput = z.infer<typeof updateOrganisationSchema>;
