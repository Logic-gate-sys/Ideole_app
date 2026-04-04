import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import { app } from '../../src/app.ts';
import { createTestUser } from '../helpers/testHelpers.ts';
import { prisma } from '../../src/lib/prisma.ts';

describe('Idea Integration Tests', () => {
  let user1: any;
  let user2: any;
  let community: any;
  let organisation: any;

  beforeEach(async () => {
    user1 = await createTestUser({}, 'access');
    user2 = await createTestUser({ username: 'user2', email: 'user2@test.com' }, 'access');

    // Create organisation and community
    organisation = await prisma.organisation.create({
      data: {
        name: 'Test Org',
        ownerId: user1.id,
      },
    });

    community = await prisma.community.create({
      data: {
        name: 'Test Community',
        adminId: user1.id,
        organisationId: organisation.id,
      },
    });

    // Add user1 as admin member
    await prisma.membership.create({
      data: {
        userId: user1.id,
        communityId: community.id,
        organisationId: organisation.id,
        status: 'ACTIVE',
        role: 'admin',
      },
    });

    // Add user2 as member
    await prisma.membership.create({
      data: {
        userId: user2.id,
        communityId: community.id,
        organisationId: organisation.id,
        status: 'ACTIVE',
        role: 'member',
      },
    });
  });

  describe('POST /api/ideas', () => {
    it('should create a public idea without criteria', async () => {
      const response = await request(app)
        .post('/api/ideas')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'Innovative Solution',
          description: 'This is a detailed description of my innovative solution to a common problem',
          visibility: 'PUBLIC',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe('Innovative Solution');
      expect(response.body.data.visibility).toBe('PUBLIC');
      expect(response.body.data.stage).toBe('INCEPTION');
      expect(response.body.data.ownerId).toBe(user1.id);
    });

    it('should create an idea with evaluation criteria', async () => {
      const response = await request(app)
        .post('/api/ideas')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'Business Idea',
          description: 'A business idea with specific evaluation criteria for assessment and review',
          visibility: 'PROTECTED',
          criteria: [
            { name: 'Originality', description: 'How unique is the idea' },
            { name: 'Feasibility', description: 'Can it be implemented' },
            { name: 'Impact', description: 'What is the potential impact' },
          ],
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.criteria).toHaveLength(3);
      expect(response.body.data.criteria.map((c: any) => c.name)).toContain('Originality');
      expect(response.body.data.criteria.map((c: any) => c.name)).toContain('Feasibility');
    });

    it('should create a private idea for community', async () => {
      const response = await request(app)
        .post('/api/ideas')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'Community Idea',
          description: 'A private idea only visible to community members with detailed description',
          visibility: 'PRIVATE',
          communityId: community.id,
        });

      expect(response.status).toBe(201);
      expect(response.body.data.communityId).toBe(community.id);
      expect(response.body.data.visibility).toBe('PRIVATE');
    });

    it('should reject if user not community member', async () => {
      const user3 = await createTestUser({ username: 'user3', email: 'user3@test.com' }, 'access');

      const response = await request(app)
        .post('/api/ideas')
        .set('Authorization', `Bearer ${user3.token}`)
        .send({
          title: 'Unauthorized Idea',
          description: 'This should fail because user is not a community member',
          visibility: 'PRIVATE',
          communityId: community.id,
        });

      expect(response.status).toBe(403);
    });

    it('should reject without authentication', async () => {
      const response = await request(app)
        .post('/api/ideas')
        .send({
          title: 'Unauthenticated Idea',
          description: 'This should fail due to missing authentication header',
          visibility: 'PUBLIC',
        });

      expect(response.status).toBe(401);
    });

    it('should reject invalid title (too short)', async () => {
      const response = await request(app)
        .post('/api/ideas')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'ab',
          description: 'This is a valid description that exceeds minimum length requirements',
          visibility: 'PUBLIC',
        });

      expect(response.status).toBe(400);
    });
  });

  describe('GET /api/ideas/:ideaId', () => {
    let publicIdea: any;
    let protectedIdea: any;
    let privateIdea: any;

    beforeEach(async () => {
      publicIdea = await prisma.idea.create({
        data: {
          title: 'Public Idea',
          description: 'A public idea visible to everyone without any restrictions',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      protectedIdea = await prisma.idea.create({
        data: {
          title: 'Protected Idea',
          description: 'A protected idea visible only to community members',
          visibility: 'PROTECTED',
          communityId: community.id,
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      privateIdea = await prisma.idea.create({
        data: {
          title: 'Private Idea',
          description: 'A private idea only visible to the owner',
          visibility: 'PRIVATE',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });
    });

    it('should get public idea without auth', async () => {
      const response = await request(app).get(`/api/ideas/${publicIdea.id}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe('Public Idea');
    });

    it('should get protected idea as community member', async () => {
      const response = await request(app)
        .get(`/api/ideas/${protectedIdea.id}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(200);
      expect(response.body.data.title).toBe('Protected Idea');
    });

    it('should reject protected idea for non-member', async () => {
      const user3 = await createTestUser({ username: 'user3', email: 'user3@test.com' }, 'access');

      const response = await request(app)
        .get(`/api/ideas/${protectedIdea.id}`)
        .set('Authorization', `Bearer ${user3.token}`);

      expect(response.status).toBe(403);
    });

    it('should get private idea as owner', async () => {
      const response = await request(app)
        .get(`/api/ideas/${privateIdea.id}`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.data.title).toBe('Private Idea');
    });

    it('should reject private idea for non-owner', async () => {
      const response = await request(app)
        .get(`/api/ideas/${privateIdea.id}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });

    it('should return 404 for non-existent idea', async () => {
      const response = await request(app).get('/api/ideas/nonexistent');

      expect(response.status).toBe(404);
    });
  });

  describe('GET /api/ideas', () => {
    beforeEach(async () => {
      await prisma.idea.createMany({
        data: [
          {
            title: 'Public Idea 1',
            description: 'First public idea with comprehensive details and description',
            visibility: 'PUBLIC',
            ownerId: user1.id,
            stage: 'INCEPTION',
          },
          {
            title: 'Public Idea 2',
            description: 'Second public idea with additional information about the concept',
            visibility: 'PUBLIC',
            ownerId: user2.id,
            stage: 'INCEPTION',
          },
        ],
      });
    });

    it('should list public ideas', async () => {
      const response = await request(app).get('/api/ideas');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.ideas).toBeDefined();
      expect(response.body.data.total).toBeGreaterThanOrEqual(2);
      expect(Array.isArray(response.body.data.ideas)).toBe(true);
    });

    it('should support pagination', async () => {
      const response = await request(app).get('/api/ideas?limit=1&offset=0');

      expect(response.status).toBe(200);
      expect(response.body.data.ideas).toHaveLength(1);
      expect(response.body.data.page).toBe(1);
    });

    it('should filter by visibility', async () => {
      const response = await request(app).get('/api/ideas?visibility=PUBLIC');

      expect(response.status).toBe(200);
      expect(response.body.data.ideas.every((idea: any) => idea.visibility === 'PUBLIC')).toBe(true);
    });

    it('should filter by stage', async () => {
      const response = await request(app).get('/api/ideas?stage=INCEPTION');

      expect(response.status).toBe(200);
      expect(response.body.data.ideas.every((idea: any) => idea.stage === 'INCEPTION')).toBe(true);
    });
  });

  describe('PUT /api/ideas/:ideaId', () => {
    let idea: any;

    beforeEach(async () => {
      idea = await prisma.idea.create({
        data: {
          title: 'Original Idea',
          description: 'Original description of the idea concept',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });
    });

    it('should update idea as owner', async () => {
      const response = await request(app)
        .put(`/api/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'Updated Idea Title',
          description: 'Updated description with new information about the idea project',
          visibility: 'PROTECTED',
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe('Updated Idea Title');
      expect(response.body.data.visibility).toBe('PROTECTED');
    });

    it('should reject update by non-owner', async () => {
      const response = await request(app)
        .put(`/api/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${user2.token}`)
        .send({
          title: 'Unauthorized Update',
          description: 'This update should be rejected by the system',
        });

      expect(response.status).toBe(403);
    });

    it('should reject update without authentication', async () => {
      const response = await request(app)
        .put(`/api/ideas/${idea.id}`)
        .send({
          title: 'Unauthenticated Update',
          description: 'This should fail due to no authentication',
        });

      expect(response.status).toBe(401);
    });

    it('should return 404 for non-existent idea', async () => {
      const response = await request(app)
        .put('/api/ideas/nonexistent')
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          title: 'New Title',
          description: 'New description text for testing',
        });

      expect(response.status).toBe(404);
    });
  });

  describe('DELETE /api/ideas/:ideaId', () => {
    it('should delete idea as owner', async () => {
      const idea = await prisma.idea.create({
        data: {
          title: 'Idea to Delete',
          description: 'This idea will be deleted from the system',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      const response = await request(app)
        .delete(`/api/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);

      // Verify deleted
      const getRes = await request(app).get(`/api/ideas/${idea.id}`);
      expect(getRes.status).toBe(404);
    });

    it('should reject delete by non-owner', async () => {
      const idea = await prisma.idea.create({
        data: {
          title: 'Protected Idea',
          description: 'This idea should not be deletable by someone else',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      const response = await request(app)
        .delete(`/api/ideas/${idea.id}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });
  });

  describe('GET /api/ideas/:ideaId/criteria', () => {
    let ideaWithCriteria: any;

    beforeEach(async () => {
      ideaWithCriteria = await prisma.idea.create({
        data: {
          title: 'Idea with Criteria',
          description: 'An idea that has multiple evaluation criteria set up',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      await prisma.evaluationCriteria.createMany({
        data: [
          {
            name: 'Feasibility',
            description: 'How feasible is this idea',
            ideaId: ideaWithCriteria.id,
            order: 0,
          },
          {
            name: 'Impact',
            description: 'What is the potential impact',
            ideaId: ideaWithCriteria.id,
            order: 1,
          },
        ],
      });
    });

    it('should get idea criteria', async () => {
      const response = await request(app).get(`/api/ideas/${ideaWithCriteria.id}/criteria`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.data[0].name).toBe('Feasibility');
      expect(response.body.data[1].name).toBe('Impact');
    });

    it('should return 404 for non-existent idea', async () => {
      const response = await request(app).get('/api/ideas/nonexistent/criteria');

      expect(response.status).toBe(404);
    });
  });

  describe('POST /api/ideas/:ideaId/criteria', () => {
    let idea: any;

    beforeEach(async () => {
      idea = await prisma.idea.create({
        data: {
          title: 'Idea for Criteria',
          description: 'An idea where we will add evaluation criteria',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });
    });

    it('should create evaluation criteria as idea owner', async () => {
      const response = await request(app)
        .post(`/api/ideas/${idea.id}/criteria`)
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          name: 'Originality',
          description: 'How original is the idea in the market',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('Originality');
      expect(response.body.data.ideaId).toBe(idea.id);
    });

    it('should reject criteria creation by non-owner', async () => {
      const response = await request(app)
        .post(`/api/ideas/${idea.id}/criteria`)
        .set('Authorization', `Bearer ${user2.token}`)
        .send({
          name: 'Feasibility',
          description: 'Can this be implemented',
        });

      expect(response.status).toBe(403);
    });

    it('should reject criteria creation after INCEPTION stage', async () => {
      // Move to collaborative stage
      await prisma.idea.update({
        where: { id: idea.id },
        data: { stage: 'COLLABORATIVE' },
      });

      const response = await request(app)
        .post(`/api/ideas/${idea.id}/criteria`)
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          name: 'Impact',
          description: 'What is the impact of this idea',
        });

      expect(response.status).toBe(400);
    });
  });

  describe('PUT /api/ideas/:ideaId/criteria/:criteriaId', () => {
    let idea: any;
    let criteria: any;

    beforeEach(async () => {
      idea = await prisma.idea.create({
        data: {
          title: 'Idea with Criteria Updates',
          description: 'An idea for testing criteria updates',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      criteria = await prisma.evaluationCriteria.create({
        data: {
          name: 'Original Name',
          description: 'Original description of the criteria',
          ideaId: idea.id,
          order: 0,
        },
      });
    });

    it('should update criteria as idea owner', async () => {
      const response = await request(app)
        .put(`/api/ideas/${idea.id}/criteria/${criteria.id}`)
        .set('Authorization', `Bearer ${user1.token}`)
        .send({
          name: 'Updated Criteria Name',
          description: 'Updated description of the evaluation criteria',
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.name).toBe('Updated Criteria Name');
    });

    it('should reject update by non-owner', async () => {
      const response = await request(app)
        .put(`/api/ideas/${idea.id}/criteria/${criteria.id}`)
        .set('Authorization', `Bearer ${user2.token}`)
        .send({
          name: 'Unauthorized Name',
          description: 'This should be rejected',
        });

      expect(response.status).toBe(403);
    });
  });

  describe('DELETE /api/ideas/:ideaId/criteria/:criteriaId', () => {
    let idea: any;
    let criteria: any;

    beforeEach(async () => {
      idea = await prisma.idea.create({
        data: {
          title: 'Idea for Criteria Deletion',
          description: 'An idea where criteria will be deleted',
          visibility: 'PUBLIC',
          ownerId: user1.id,
          stage: 'INCEPTION',
        },
      });

      criteria = await prisma.evaluationCriteria.create({
        data: {
          name: 'Criteria to Delete',
          description: 'This criteria will be deleted',
          ideaId: idea.id,
          order: 0,
        },
      });
    });

    it('should delete criteria as idea owner', async () => {
      const response = await request(app)
        .delete(`/api/ideas/${idea.id}/criteria/${criteria.id}`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    it('should reject deletion by non-owner', async () => {
      const response = await request(app)
        .delete(`/api/ideas/${idea.id}/criteria/${criteria.id}`)
        .set('Authorization', `Bearer ${user2.token}`);

      expect(response.status).toBe(403);
    });

    it('should reject deletion when ratings exist', async () => {
      // Create a rating for this idea
      await prisma.ideaRating.create({
        data: {
          ideaId: idea.id,
          authorId: user2.id,
          scores: JSON.stringify({}),
          isLatest: true,
        },
      });

      const response = await request(app)
        .delete(`/api/ideas/${idea.id}/criteria/${criteria.id}`)
        .set('Authorization', `Bearer ${user1.token}`);

      expect(response.status).toBe(400);
    });
  });
});
