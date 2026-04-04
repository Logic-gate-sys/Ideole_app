import { z } from 'zod';

export const membershipRequestSchema = z.object({
  // No required fields - just a request to join
});

export type MembershipRequestInput = z.infer<typeof membershipRequestSchema>;
