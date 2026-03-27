import { z } from 'zod';

// Create invite schema
export const createInviteSchema = z.object({
  body: z.object({
    reviewerId: z.string()
      .uuid('Invalid reviewer ID format'),
  }),
});

// Update invite status schema
export const updateInviteStatusSchema = z.object({
  body: z.object({
    status: z.enum(['PENDING', 'ACCEPTED'])
      .refine(status => status !== 'PENDING', {
        message: 'Status must be either PENDING or ACCEPTED',
      }),
  }),
});

// Invite ID parameter schema
export const inviteIdParamSchema = z.object({
  params: z.object({
    ideaId: z.string().uuid('Invalid idea ID format'),
    inviteId: z.string().uuid('Invalid invite ID format'),
  }),
});

// Get invites for idea parameter schema
export const getInvitesParamSchema = z.object({
  params: z.object({
    ideaId: z.string().uuid('Invalid idea ID format'),
  }),
});

// Export types
export type CreateInviteRequest = z.infer<typeof createInviteSchema>;
export type UpdateInviteStatusRequest = z.infer<typeof updateInviteStatusSchema>;
export type InviteIdParam = z.infer<typeof inviteIdParamSchema>;
export type GetInvitesParam = z.infer<typeof getInvitesParamSchema>;
