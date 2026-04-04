/// API Endpoints
/// Base URL is managed in lib/core/config/environment.dart
/// This allows for easy switching between dev/staging/production
library;

// ============== Auth Endpoints ==============
const String loginEndpoint = "/auth/login";
const String signupEndpoint = "/auth/signup";
const String refreshTokenEndpoint = "/auth/refresh";
const String logoutEndpoint = "/auth/logout";
const String getMeEndpoint = "/auth/me";

// ============== Organisation Endpoints ==============
const String createOrganisationEndpoint = "/api/organisations";
const String getOrganisationEndpoint = "/api/organisations/{organisationId}"; // Replace {organisationId}
const String listOrganisationsEndpoint = "/api/organisations";
const String updateOrganisationEndpoint = "/api/organisations/{organisationId}"; // Replace {organisationId}
const String deleteOrganisationEndpoint = "/api/organisations/{organisationId}"; // Replace {organisationId}

// ============== Community Endpoints ==============
const String createCommunityEndpoint = "/api/organisations/{organisationId}/communities"; // Replace {organisationId}
const String getCommunityEndpoint = "/api/organisations/{organisationId}/communities/{communityId}"; // Replace both
const String listCommunitiesEndpoint = "/api/organisations/{organisationId}/communities"; // Replace {organisationId}
const String updateCommunityEndpoint = "/api/organisations/{organisationId}/communities/{communityId}"; // Replace both
const String deleteCommunityEndpoint = "/api/organisations/{organisationId}/communities/{communityId}"; // Replace both

// ============== Idea Endpoints ==============
const String createIdeaEndpoint = "/ideas";
const String getIdeasEndpoint = "/ideas";
const String getUserIdeasEndpoint = "/user/ideas";
const String getIdeaDetailsEndpoint = "/ideas/{ideaId}"; // Replace {ideaId}
const String updateIdeaEndpoint = "/ideas/{ideaId}"; // Replace {ideaId}
const String toggleIdeaVisibilityEndpoint = "/ideas/{ideaId}/public"; // Replace {ideaId}

// ============== Rating Endpoints ==============
const String createRatingEndpoint = "/ideas/{ideaId}/rate"; // Replace {ideaId}
const String getRatingStatsEndpoint = "/ideas/{ideaId}/stats"; // Replace {ideaId}
const String getIdeaRatingsEndpoint = "/ideas/{ideaId}/ratings"; // Replace {ideaId}

// ============== Invite Endpoints ==============
const String sendInviteEndpoint = "/ideas/{ideaId}/invite"; // Replace {ideaId}
const String acceptInviteEndpoint = "/ideas/{ideaId}/invite/{inviteId}"; // Replace both
const String getIdeaInvitesEndpoint = "/ideas/{ideaId}/invites"; // Replace {ideaId}
const String getUserInvitesEndpoint = "/user/invites";
const String getPendingInvitesEndpoint = "/user/invites/pending";

// ============== Comment Endpoints ==============
const String createCommentEndpoint = "/ideas/{ideaId}/comments"; // Replace {ideaId}
const String getCommentsEndpoint = "/ideas/{ideaId}/comments"; // Replace {ideaId}
const String deleteCommentEndpoint = "/ideas/{ideaId}/comments/{commentId}"; // Replace both

// ============== Health Check ==============
const String healthCheckEndpoint = "/health";
