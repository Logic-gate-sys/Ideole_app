import { z } from 'zod';

export const sendInviteSchema = z.object({
  invitedUserId: z.string().uuid(),
});

export const respondInviteSchema = z.object({
  status: z.enum(['ACCEPTED', 'DECLINED', 'CANCELLED']),
});
