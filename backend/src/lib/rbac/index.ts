// RBAC module - role-based access control
export type { Permission } from './rbac.ts';
export { can, permissionsByRole } from './rbac.ts';
export { authorize, buildAuthContext } from './authorize.ts';
