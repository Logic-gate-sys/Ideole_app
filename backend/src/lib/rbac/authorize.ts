import type { User } from '../../../prisma/generated/client.ts';
import { can } from './rbac.ts';

export function authorize(
  user: User,
  permission: string,
  context?: {
    userStatus?: string;
    isMember?: boolean;
    membershipStatus?: string;
    isOwner?: boolean;
    resourceVisibility?: string;
  },
): { code: string; message: string } | null {
 if (!user) {
    return { code: 'NOT_AUTHENTICATED', message: 'User not authenticated' };
  }
  //if user exists and has no permission
  if (!can(user, permission as any)) {
    return { code: 'PERMISSION_DENIED', message: 'User lacks permission' };
  }

  // user status
  if (context?.userStatus === 'BANNED') {
    return { code: 'USER_BANNED', message: 'User is banned' };
  }

  if (context?.userStatus === 'DORMANT') {
    return { code: 'USER_DORMANT', message: 'User account is dormant' };
  }

  // membership status if in community context
  if (context?.isMember === false && permission.includes('community')) {
    return { code: 'NOT_MEMBER', message: 'User is not a community member' };
  }

  if (context?.membershipStatus === 'BANNED') {
    return { code: 'MEMBERSHIP_BANNED', message: 'User is banned from community' };
  }

  if (context?.membershipStatus === 'PENDING' && permission.includes('write')) {
    return { code: 'MEMBERSHIP_PENDING', message: 'Membership still pending' };
  }

  // ownership for owner-only actions
  if (permission.includes(':own') && !context?.isOwner) {
    return { code: 'NOT_OWNER', message: 'User is not the owner' };
  }

  // visibility access
  if (context?.resourceVisibility === 'PRIVATE' && !context?.isOwner) {
    return { code: 'RESOURCE_PRIVATE', message: 'Resource is private' };
  }

  if (context?.resourceVisibility === 'PROTECTED' && !context?.isMember) {
    return { code: 'RESOURCE_PROTECTED', message: 'Resource requires membership' };
  }

  return null; // All checks passed
}


export function buildAuthContext(user: User, resource?: {visibility?: string;ownerId?: string;status?: string; },
  membership?: {status?: string;},
) {
  return {
    userStatus: user?.status,
    isOwner: user && resource?.ownerId === user.id,
    isMember: membership != null,
    membershipStatus: membership?.status,
    resourceVisibility: resource?.visibility,
  };
}
