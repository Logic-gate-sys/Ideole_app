/// API Endpoints
/// Base URL is managed in lib/core/config/environment.dart
/// This allows for easy switching between dev/staging/production
library;

// ============== Auth Endpoints ==============
const String loginEndpoint = "/auth/login";
const String signupEndpoint = "/auth/register";
const String refreshTokenEndpoint = "/auth/refresh";
const String logoutEndpoint = "/auth/logout";
const String getMeEndpoint = "/auth/me";

// ============== User Endpoints ==============
const String getUserProfileEndpoint = "/users/me";
const String updateUserProfileEndpoint = "/users/me";
const String updateLastActiveEndpoint = "/users/me/active";
const String getUserMembershipsEndpoint = "/users/me/memberships";
const String getUserIdeasEndpoint = "/users/me/ideas";
const String getNotificationsEndpoint = "/users/me/notifications";

// ============== Organisation Endpoints ==============
const String createOrganisationEndpoint = "/organisations";
const String getOrganisationEndpoint = "/organisations/{organisationId}"; // Replace {organisationId}
const String listOrganisationsEndpoint = "/organisations";
const String updateOrganisationEndpoint = "/organisations/{organisationId}"; // Replace {organisationId}
const String deleteOrganisationEndpoint = "/organisations/{organisationId}"; // Replace {organisationId}

// ============== Community Endpoints ==============
const String createCommunityEndpoint = "/organisations/{organisationId}/communities"; // Replace {organisationId}
const String getCommunityEndpoint = "/organisations/{organisationId}/communities/{communityId}"; // Replace both
const String listCommunitiesEndpoint = "/organisations/{organisationId}/communities"; // Replace {organisationId}
const String updateCommunityEndpoint = "/organisations/{organisationId}/communities/{communityId}"; // Replace both
const String deleteCommunityEndpoint = "/organisations/{organisationId}/communities/{communityId}"; // Replace both

// ============== Membership Endpoints ==============
const String requestMembershipEndpoint = "/communities/{communityId}/memberships/request"; // Replace {communityId}
const String getPendingMembershipsEndpoint = "/communities/{communityId}/memberships/pending"; // Replace {communityId}
const String approveMembershipEndpoint = "/communities/{communityId}/memberships/{membershipId}/approve"; // Replace both
const String rejectMembershipEndpoint = "/communities/{communityId}/memberships/{membershipId}/reject"; // Replace both
const String removeMembershipEndpoint = "/communities/{communityId}/memberships/{membershipId}"; // Replace both
const String getCommunityMembersEndpoint = "/communities/{communityId}/members"; // Replace {communityId}

// ============== Idea Endpoints ==============
const String createIdeaEndpoint = "/ideas";
const String getIdeasEndpoint = "/ideas";
const String getIdeaDetailsEndpoint = "/ideas/{ideaId}"; // Replace {ideaId}
const String updateIdeaEndpoint = "/ideas/{ideaId}"; // Replace {ideaId}
const String deleteIdeaEndpoint = "/ideas/{ideaId}"; // Replace {ideaId}

// ============== Idea Criteria Endpoints ==============
const String getIdeaCriteriaEndpoint = "/ideas/{ideaId}/criteria"; // Replace {ideaId}
const String createIdeaCriteriaEndpoint = "/ideas/{ideaId}/criteria"; // Replace {ideaId}
const String updateIdeaCriteriaEndpoint = "/ideas/{ideaId}/criteria/{criteriaId}"; // Replace both
const String deleteIdeaCriteriaEndpoint = "/ideas/{ideaId}/criteria/{criteriaId}"; // Replace both

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

// ============== Conversation Endpoints ==============
const String getIdeaConversationEndpoint = "/ideas/{ideaId}/conversations"; // Replace {ideaId}
const String createIdeaConversationEndpoint = "/ideas/{ideaId}/conversations"; // Replace {ideaId}
const String getConversationMessagesEndpoint = "/conversations/{conversationId}/messages"; // Replace {conversationId}
const String createConversationMessageEndpoint = "/conversations/{conversationId}/messages"; // Replace {conversationId}

// ============== Health Check ==============
const String healthCheckEndpoint = "/health";
