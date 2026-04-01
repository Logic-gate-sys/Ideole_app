import type { User } from '../../../prisma/generated/client.ts';

export type Permission =
  | 'idea:create'
  | 'idea:read:all'
  | 'idea:read:public'
  | 'idea:read:protected'
  | 'idea:read:own'
  | 'idea:update:own'
  | 'idea:update:all'
  | 'idea:delete:own'
  | 'idea:delete:all'
  | 'idea:publish'
  | 'idea:invite:reviewer'
  | 'criteria:create:own'
  | 'criteria:read:any'
  | 'criteria:update:own'
  | 'criteria:delete:own'
  | 'rating:create'
  | 'rating:read:all'
  | 'rating:update:own'
  | 'rating:delete:own'
  | 'rating:delete:all'
  | 'comment:create'
  | 'comment:read:all'
  | 'comment:update:own'
  | 'comment:delete:own'
  | 'comment:delete:all'
  | 'conversation:create'
  | 'conversation:read:own'
  | 'message:create'
  | 'message:update:own'
  | 'message:delete:own'
  | 'message:delete:all'
  | 'community:create'
  | 'community:read:all'
  | 'community:read:public'
  | 'community:read:protected'
  | 'community:read:own'
  | 'community:update:own'
  | 'community:update:all'
  | 'community:delete:own'
  | 'community:delete:all'
  | 'community:manage:admin'
  | 'membership:join'
  | 'membership:read:own'
  | 'membership:approve:admin'
  | 'membership:reject:admin'
  | 'membership:manage:admin'
  | 'membership:remove:admin'
  | 'organisation:create'
  | 'organisation:read:own'
  | 'organisation:update:own'
  | 'organisation:delete:own'
  | 'organisation:manage:admin'
  | 'system:view:all'
  | 'system:manage:dormancy'
  | 'system:dissolve:communities'
  | 'system:update:stages'
  | 'user:read:own'
  | 'user:manage:all'
  | 'user:delete:all';

export const permissionsByRole: Record<User['role'], Permission[]> = {
  USER: [
    'idea:create',
    'idea:read:public',
    'idea:read:protected',
    'idea:read:own',
    'idea:update:own',
    'idea:delete:own',
    'idea:publish',
    'idea:invite:reviewer',
    'criteria:create:own',
    'criteria:read:any',
    'criteria:update:own',
    'criteria:delete:own',
    'rating:create',
    'rating:read:all',
    'rating:update:own',
    'rating:delete:own',
    'comment:create',
    'comment:read:all',
    'comment:update:own',
    'comment:delete:own',
    'conversation:create',
    'conversation:read:own',
    'message:create',
    'message:update:own',
    'message:delete:own',
    'community:read:public',
    'community:read:protected',
    'community:read:own',
    'membership:join',
    'membership:read:own',
    'user:read:own',
  ],
  ADMIN: [
    'idea:create',
    'idea:read:all',
    'idea:read:public',
    'idea:read:protected',
    'idea:read:own',
    'idea:update:own',
    'idea:update:all',
    'idea:delete:own',
    'idea:delete:all',
    'idea:publish',
    'idea:invite:reviewer',
    'criteria:create:own',
    'criteria:read:any',
    'criteria:update:own',
    'criteria:delete:own',
    'rating:create',
    'rating:read:all',
    'rating:update:own',
    'rating:delete:own',
    'rating:delete:all',
    'comment:create',
    'comment:read:all',
    'comment:update:own',
    'comment:delete:own',
    'comment:delete:all',
    'conversation:create',
    'conversation:read:own',
    'message:create',
    'message:update:own',
    'message:delete:own',
    'message:delete:all',
    'community:create',
    'community:read:all',
    'community:read:public',
    'community:read:protected',
    'community:read:own',
    'community:update:own',
    'community:update:all',
    'community:delete:own',
    'community:delete:all',
    'community:manage:admin',
    'membership:join',
    'membership:read:own',
    'membership:approve:admin',
    'membership:reject:admin',
    'membership:manage:admin',
    'membership:remove:admin',
    'organisation:create',
    'organisation:read:own',
    'organisation:update:own',
    'organisation:delete:own',
    'organisation:manage:admin',
    'system:view:all',
    'system:manage:dormancy',
    'system:dissolve:communities',
    'system:update:stages',
    'user:read:own',
    'user:manage:all',
    'user:delete:all',
  ],
};

export function can( user: Pick<User, 'role'>, permission: Permission): boolean {
  if (user == null) return false;
  return permissionsByRole[user.role].includes(permission);
}
