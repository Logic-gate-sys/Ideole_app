import { z } from 'zod';

// Create comment schema
export const createCommentSchema = z.object({
  content: z.string()
    .min(1, 'Comment cannot be empty')
    .max(1000, 'Comment must not exceed 1000 characters'),
});

// Comment ID parameter schema
export const commentIdParamSchema = z.object({
  ideaId: z.string().uuid('Invalid idea ID format'),
  commentId: z.string().uuid('Invalid comment ID format'),
});

// Get comments for idea parameter schema
export const getCommentsParamSchema = z.object({
  ideaId: z.string().uuid('Invalid idea ID format'),
});

// Query schema for pagination
export const commentPaginationQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1).catch(1),
  limit: z.coerce.number().int().min(1).default(20).catch(20),
});

// Export types
export type CreateCommentRequest = z.infer<typeof createCommentSchema>;
export type CommentIdParam = z.infer<typeof commentIdParamSchema>;
export type GetCommentsParam = z.infer<typeof getCommentsParamSchema>;
export type CommentPaginationQuery = z.infer<typeof commentPaginationQuerySchema>;
