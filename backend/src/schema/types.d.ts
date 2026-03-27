// Type definitions for Ideole application

export type Visibility = 'PRIVATE' | 'COMMUNITY' | 'PUBLIC';
export type InviteStatus = 'PENDING' | 'ACCEPTED';

// User types
export interface IdeoleUser {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}

// Idea types
export interface IdeaData {
  id: string;
  title: string;
  problemText: string;
  solutionText: string;
  category: string;
  visibility: Visibility;
  isPublic: boolean;
  creatorId: string;
  createdAt: Date;
  updatedAt: Date;
}

// Rating types
export interface RatingData {
  id: string;
  ideaId: string;
  reviewerId: string;
  originality: number;
  feasibility: number;
  impact: number;
  createdAt: Date;
}

export interface RatingStats {
  ideaId: string;
  totalRatings: number;
  averageOriginality: number;
  averageFeasibility: number;
  averageImpact: number;
  averageOverall: number;
}

// Invite types
export interface InviteData {
  id: string;
  ideaId: string;
  reviewerId: string;
  status: InviteStatus;
  createdAt: Date;
}

// Comment types
export interface CommentData {
  id: string;
  ideaId: string;
  userId: string;
  content: string;
  createdAt: Date;
}

// API Response types
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  items: T[];
  pagination: {
    total: number;
    page: number;
    limit: number;
    pages: number;
  };
}

// Custom Express types
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
      };
    }
  }
}
