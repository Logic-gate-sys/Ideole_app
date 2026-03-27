import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { TestHelpers } from '../helpers/test-helpers.ts';
import { CommentService } from '../../src/services/comment.service.ts';

describe('CommentService - Unit Tests', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('createComment', () => {
    it('should create comment on public idea', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const result = await CommentService.createComment({
        content: 'Great idea!',
        ideaId: idea.id,
        userId: commenter.id,
      });

      expect(result).toBeDefined();
      expect(result.content).toBe('Great idea!');
      expect(result.userId).toBe(commenter.id);
    });

    it('should create comment if user is invited', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });
      await TestHelpers.createInvite(idea.id, commenter.id);

      const result = await CommentService.createComment({
        content: 'Feedback on your idea',
        ideaId: idea.id,
        userId: commenter.id,
      });

      expect(result).toBeDefined();
    });

    it('should allow creator to comment on own idea', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      const result = await CommentService.createComment({
        content: 'My own comment',
        ideaId: idea.id,
        userId: creator.id,
      });

      expect(result).toBeDefined();
      expect(result.userId).toBe(creator.id);
    });

    it('should throw error if idea not found', async () => {
      const user = await TestHelpers.createUser();

      await expect(
        CommentService.createComment({
          content: 'Comment',
          ideaId: 'nonexistent-id',
          userId: user.id,
        })
      ).rejects.toThrow('Idea not found');
    });

    it('should throw error if user has no access to private idea', async () => {
      const creator = await TestHelpers.createUser();
      const other = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      await expect(
        CommentService.createComment({
          content: 'Comment',
          ideaId: idea.id,
          userId: other.id,
        })
      ).rejects.toThrow('You do not have permission to comment on this idea');
    });
  });

  describe('getIdeaComments', () => {
    it('should retrieve all comments for an idea', async () => {
      const scenario = await TestHelpers.createCompleteScenario();

      const result = await CommentService.getIdeaComments(scenario.idea.id);

      expect(result.comments.length).toBe(3);
      expect(result.pagination.total).toBe(3);
    });

    it('should handle pagination correctly', async () => {
      const creator = await TestHelpers.createUser();
      const commenters = await TestHelpers.createMultipleUsers(15);
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      await TestHelpers.createMultipleComments(idea.id, commenters.map(c => c.id));

      const page1 = await CommentService.getIdeaComments(idea.id, 1, 10);
      const page2 = await CommentService.getIdeaComments(idea.id, 2, 10);

      expect(page1.comments.length).toBe(10);
      expect(page2.comments.length).toBe(5);
      expect(page1.pagination.pages).toBe(2);
    });

    it('should throw error if idea not found', async () => {
      await expect(
        CommentService.getIdeaComments('nonexistent-id')
      ).rejects.toThrow('Idea not found');
    });
  });

  describe('deleteComment', () => {
    it('should delete comment by creator', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      const result = await CommentService.deleteComment(comment.id, commenter.id);

      expect(result).toBeDefined();
    });

    it('should delete comment by idea creator', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      const result = await CommentService.deleteComment(comment.id, creator.id);

      expect(result).toBeDefined();
    });

    it('should throw error if comment not found', async () => {
      const user = await TestHelpers.createUser();

      await expect(
        CommentService.deleteComment('nonexistent-id', user.id)
      ).rejects.toThrow('Comment not found');
    });

    it('should throw error if user has no permission', async () => {
      const creator = await TestHelpers.createUser();
      const commenter = await TestHelpers.createUser();
      const otherUser = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });
      const comment = await TestHelpers.createComment(idea.id, commenter.id);

      await expect(
        CommentService.deleteComment(comment.id, otherUser.id)
      ).rejects.toThrow('You do not have permission to delete this comment');
    });
  });
});
