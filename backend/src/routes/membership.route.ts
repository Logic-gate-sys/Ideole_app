import type { Router } from 'express';
import { MembershipControllers } from '../controllers/membership.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';

export function setupMembershipRoutes(router: Router) {
  // Request to join community
  router.post(
    '/communities/:communityId/memberships/request',
    authenticate,
    authorise('membership:join'),
    MembershipControllers.requestToJoin
  );

  // Get pending membership requests (admin only)
  router.get(
    '/communities/:communityId/memberships/pending',
    authenticate,
    authorise('membership:manage:admin'),
    MembershipControllers.getPendingRequests
  );

  // Approve membership request (admin only)
  router.patch(
    '/communities/:communityId/memberships/:membershipId/approve',
    authenticate,
    authorise('membership:approve:admin'),
    MembershipControllers.approveMembershipRequest
  );

  // Reject membership request (admin only)
  router.patch(
    '/communities/:communityId/memberships/:membershipId/reject',
    authenticate,
    authorise('membership:reject:admin'),
    MembershipControllers.rejectMembershipRequest
  );

  // Remove member from community (admin or member)
  router.delete(
    '/communities/:communityId/memberships/:membershipId',
    authenticate,
    authorise('membership:remove:admin'),
    MembershipControllers.removeMember
  );

  // Get community members (public)
  router.get(
    '/communities/:communityId/members',
    MembershipControllers.getCommunityMembers
  );
}
