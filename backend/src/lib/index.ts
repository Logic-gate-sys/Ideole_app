// RBAC utilities
export type { Permission } from './rbac/rbac.ts';
export { can, permissionsByRole } from './rbac/rbac.ts';
export { authorize, buildAuthContext } from './rbac/authorize.ts';

// JWT
export { generateAccessToken, generateRefreshToken, verifyToken } from './jwt.ts';

// Password utilities
export { hashPassword, verifyPassword } from './password.ts';

// Response utilities
export { sendSuccess, sendError, sendLogout } from './response.ts';
export type { ApiResponse } from './response.ts';

// Error utilities
export { handleControllerError, handleAuthError } from './error.ts';

// Auth Service (object pattern)
export { AuthService } from '../services/auth.service.ts';
export type { AuthResponse } from '../services/auth.service.ts';
