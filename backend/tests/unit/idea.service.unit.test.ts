import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { TestHelpers } from '../helpers/test-helpers.ts';
import { IdeaService } from '../../src/services/idea.service.ts';

describe('IdeaService - Unit Tests', () => {
  beforeEach(async () => {
    await TestHelpers.clearDatabase();
  });

  afterEach(async () => {
    await TestHelpers.clearDatabase();
  });

  describe('createIdea', () => {
    it('should create a new idea successfully', async () => {
      const creator = await TestHelpers.createUser();

      const result = await IdeaService.createIdea({
        title: 'My New Idea',
        problemText: 'This is a problem statement',
        solutionText: 'This is a solution statement',
        category: 'Technology',
        visibility: 'PRIVATE',
        creatorId: creator.id,
      });

      expect(result).toBeDefined();
      expect(result.title).toBe('My New Idea');
      expect(result.creatorId).toBe(creator.id);
      expect(result.isPublic).toBe(false);
    });

    it('should set isPublic to true when visibility is PUBLIC', async () => {
      const creator = await TestHelpers.createUser();

      const result = await IdeaService.createIdea({
        title: 'Public Idea',
        problemText: 'Problem',
        solutionText: 'Solution',
        category: 'Technology',
        visibility: 'PUBLIC',
        creatorId: creator.id,
      });

      expect(result.isPublic).toBe(true);
    });
  });

  describe('getIdeaById', () => {
    it('should retrieve idea with all relations', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const result = await IdeaService.getIdeaById(idea.id);

      expect(result).toBeDefined();
      expect(result.id).toBe(idea.id);
      expect(result.creator).toBeDefined();
      expect(result.ratings).toBeDefined();
      expect(result.comments).toBeDefined();
      expect(result.invites).toBeDefined();
    });

    it('should throw error when idea not found', async () => {
      await expect(
        IdeaService.getIdeaById('nonexistent-id')
      ).rejects.toThrow('Idea not found');
    });
  });

  describe('getVisibleIdeasForUser', () => {
    it('should return public ideas', async () => {
      const creator = await TestHelpers.createUser();
      const viewer = await TestHelpers.createUser();

      // Create public idea
      await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const result = await IdeaService.getVisibleIdeasForUser(viewer.id);

      expect(result.ideas.length).toBe(1);
      expect(result.pagination.total).toBe(1);
    });

    it('should return user\'s own ideas', async () => {
      const user = await TestHelpers.createUser();

      await TestHelpers.createMultipleIdeas(user.id, 3);

      const result = await IdeaService.getVisibleIdeasForUser(user.id);

      expect(result.ideas.length).toBe(3);
      expect(result.pagination.total).toBe(3);
    });

    it('should return invited ideas', async () => {
      const creator = await TestHelpers.createUser();
      const reviewer = await TestHelpers.createUser();

      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });
      await TestHelpers.createInvite(idea.id, reviewer.id);

      const result = await IdeaService.getVisibleIdeasForUser(reviewer.id);

      expect(result.ideas.length).toBe(1);
      expect(result.ideas[0].id).toBe(idea.id);
    });

    it('should not return private ideas user has no access to', async () => {
      const creator = await TestHelpers.createUser();
      const viewer = await TestHelpers.createUser();

      await TestHelpers.createIdea(creator.id, { visibility: 'PRIVATE' });

      const result = await IdeaService.getVisibleIdeasForUser(viewer.id);

      expect(result.ideas.length).toBe(0);
    });

    it('should handle pagination correctly', async () => {
      const user = await TestHelpers.createUser();
      await TestHelpers.createMultipleIdeas(user.id, 15);

      const page1 = await IdeaService.getVisibleIdeasForUser(user.id, 1, 10);
      const page2 = await IdeaService.getVisibleIdeasForUser(user.id, 2, 10);

      expect(page1.ideas.length).toBe(10);
      expect(page2.ideas.length).toBe(5);
      expect(page1.pagination.pages).toBe(2);
    });
  });

  describe('updateIdea', () => {
    it('should update idea successfully', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      const result = await IdeaService.updateIdea(
        idea.id,
        { title: 'Updated Title' },
        creator.id
      );

      expect(result.title).toBe('Updated Title');
      expect(result.id).toBe(idea.id);
    });

    it('should throw error if user is not creator', async () => {
      const creator = await TestHelpers.createUser();
      const otherUser = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await expect(
        IdeaService.updateIdea(idea.id, { title: 'New Title' }, otherUser.id)
      ).rejects.toThrow('Only the creator can update this idea');
    });

    it('should not update if idea not found', async () => {
      const user = await TestHelpers.createUser();

      await expect(
        IdeaService.updateIdea('nonexistent-id', { title: 'Title' }, user.id)
      ).rejects.toThrow('Idea not found');
    });
  });

  describe('toggleIdeaPublic', () => {
    it('should toggle idea to public', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { isPublic: false });

      const result = await IdeaService.toggleIdeaPublic(idea.id, true, creator.id);

      expect(result.isPublic).toBe(true);
      expect(result.visibility).toBe('PUBLIC');
    });

    it('should toggle idea to private', async () => {
      const creator = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id, { visibility: 'PUBLIC', isPublic: true });

      const result = await IdeaService.toggleIdeaPublic(idea.id, false, creator.id);

      expect(result.isPublic).toBe(false);
      expect(result.visibility).toBe('PRIVATE');
    });

    it('should throw error if user is not creator', async () => {
      const creator = await TestHelpers.createUser();
      const otherUser = await TestHelpers.createUser();
      const idea = await TestHelpers.createIdea(creator.id);

      await expect(
        IdeaService.toggleIdeaPublic(idea.id, true, otherUser.id)
      ).rejects.toThrow('Only the creator can change idea visibility');
    });
  });

  describe('getUserIdeas', () => {
    it('should return user\'s ideas with pagination', async () => {
      const user = await TestHelpers.createUser();
      await TestHelpers.createMultipleIdeas(user.id, 5);

      const result = await IdeaService.getUserIdeas(user.id, 1, 10);

      expect(result.ideas.length).toBe(5);
      expect(result.pagination.total).toBe(5);
    });

    it('should not return other user\'s ideas', async () => {
      const user1 = await TestHelpers.createUser();
      const user2 = await TestHelpers.createUser();

      await TestHelpers.createIdea(user1.id);
      await TestHelpers.createIdea(user2.id);

      const result = await IdeaService.getUserIdeas(user1.id);

      expect(result.ideas.length).toBe(1);
      expect(result.ideas[0].creatorId).toBe(user1.id);
    });
  });
});
