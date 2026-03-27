import { prisma } from "../../src/lib/prisma.ts";
import { v4 as uuidv4 } from 'uuid';
import bcrypt from 'bcrypt';

export const TestHelpers = {
  async clearDatabase() {
    // Delete in order of dependencies to avoid foreign key conflicts
    await prisma.ideaComment.deleteMany();
    await prisma.ideaRating.deleteMany();
    await prisma.ideaInvite.deleteMany();
    await prisma.idea.deleteMany();
    await prisma.user.deleteMany();
  },

  // ========== USER HELPERS ==========

  async createUser(overrides = {}) {
    const password = 'TestPassword123';
    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        email: `user-${uuidv4()}@example.com`,
        name: "Test User",
        passwordHash: hashedPassword,
        ...overrides,
      },
    });

    return {
      ...user,
      plainPassword: password, // Return plain password for login tests
    };
  },

  async createMultipleUsers(count: number) {
    const users = [];
    for (let i = 0; i < count; i++) {
      const user = await this.createUser({
        name: `User ${i + 1}`,
        email: `user${i + 1}-${uuidv4()}@example.com`,
      });
      users.push(user);
    }
    return users;
  },

  // ========== IDEA HELPERS ==========

  async createIdea(creatorId: string, overrides = {}) {
    return await prisma.idea.create({
      data: {
        title: "Innovative App Idea",
        problemText: "Many people struggle with task management across different platforms",
        solutionText: "Create a unified task management platform that syncs across devices",
        category: "Productivity",
        visibility: "PRIVATE",
        isPublic: false,
        creatorId,
        ...overrides,
      },
      include: {
        creator: { select: { id: true, name: true } },
      },
    });
  },

  async createMultipleIdeas(creatorId: string, count: number) {
    const ideas = [];
    for (let i = 0; i < count; i++) {
      const idea = await this.createIdea(creatorId, {
        title: `Idea ${i + 1}: ${["AI", "Mobile", "Web", "IoT", "Blockchain"][i % 5]} Solution`,
        problemText: `Problem description for idea ${i + 1}`,
        solutionText: `Solution description for idea ${i + 1}`,
      });
      ideas.push(idea);
    }
    return ideas;
  },

  // ========== RATING HELPERS ==========

  async createRating(ideaId: string, reviewerId: string, overrides = {}) {
    return await prisma.ideaRating.create({
      data: {
        ideaId,
        reviewerId,
        originality: 8,
        feasibility: 7,
        impact: 9,
        ...overrides,
      },
      include: {
        reviewer: { select: { id: true, name: true } },
      },
    });
  },

  async createMultipleRatings(ideaId: string, reviewerIds: string[]) {
    const ratings = [];
    for (const reviewerId of reviewerIds) {
      const rating = await this.createRating(ideaId, reviewerId);
      ratings.push(rating);
    }
    return ratings;
  },

  // ========== INVITE HELPERS ==========

  async createInvite(ideaId: string, reviewerId: string, overrides = {}) {
    return await prisma.ideaInvite.create({
      data: {
        ideaId,
        reviewerId,
        status: "PENDING",
        ...overrides,
      },
      include: {
        reviewer: { select: { id: true, name: true } },
        idea: { select: { id: true, title: true } },
      },
    });
  },

  async createMultipleInvites(ideaId: string, reviewerIds: string[]) {
    const invites = [];
    for (const reviewerId of reviewerIds) {
      const invite = await this.createInvite(ideaId, reviewerId);
      invites.push(invite);
    }
    return invites;
  },

  // ========== COMMENT HELPERS ==========

  async createComment(ideaId: string, userId: string, overrides = {}) {
    return await prisma.ideaComment.create({
      data: {
        ideaId,
        userId,
        content: "This is a great idea with lots of potential!",
        ...overrides,
      },
      include: {
        user: { select: { id: true, name: true } },
      },
    });
  },

  async createMultipleComments(ideaId: string, userIds: string[]) {
    const comments = [];
    for (const userId of userIds) {
      const comment = await this.createComment(ideaId, userId);
      comments.push(comment);
    }
    return comments;
  },

  // ========== UTILITY HELPERS ==========

  /**
   * Create a complete scenario: creator with ideas, reviewers with invites and ratings
   */
  async createCompleteScenario() {
    const creator = await this.createUser({ name: "Idea Creator" });
    const reviewers = await this.createMultipleUsers(3);

    const idea = await this.createIdea(creator.id);

    const invites = await this.createMultipleInvites(
      idea.id,
      reviewers.map(r => r.id)
    );

    // Accept first two invites
    await prisma.ideaInvite.update({
      where: { id: invites[0].id },
      data: { status: 'ACCEPTED' },
    });
    await prisma.ideaInvite.update({
      where: { id: invites[1].id },
      data: { status: 'ACCEPTED' },
    });

    const ratings = await this.createMultipleRatings(
      idea.id,
      [reviewers[0].id, reviewers[1].id]
    );

    const comments = await this.createMultipleComments(
      idea.id,
      reviewers.map(r => r.id)
    );

    return {
      creator,
      reviewers,
      idea,
      invites,
      ratings,
      comments,
    };
  },
};