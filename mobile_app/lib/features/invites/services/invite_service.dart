import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/invite.dart';
import '../../../core/constants/api_constants.dart';

class InviteService {
  final ApiClient _apiClient = ApiClient();

  /// Send an invite to collaborate on an idea
  /// Returns the created Invite object
  /// Throws ApiException on error (403 if not idea owner, 404 if not found)
  Future<Invite> sendInvite({
    required String ideaId,
    required String invitedUserId,
  }) async {
    try {
      final endpoint = sendInviteEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.post(
        endpoint,
        body: {'invitedUserId': invitedUserId},
      );

      // Backend response format: { success: true, data: {...} }
      return Invite.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to send invite: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Accept a collaboration invite
  /// Returns the updated Invite object
  /// Throws ApiException on error (400 if already accepted/declined)
  Future<Invite> acceptInvite({
    required String ideaId,
    required String inviteId,
  }) async {
    try {
      final endpoint = acceptInviteEndpoint
          .replaceFirst('{ideaId}', ideaId)
          .replaceFirst('{inviteId}', inviteId);
      
      final response = await _apiClient.patch(
        endpoint,
        body: {'status': 'ACCEPTED'},
      );

      // Backend response format: { success: true, data: {...} }
      return Invite.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to accept invite: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Decline a collaboration invite
  /// Returns the updated Invite object
  /// Throws ApiException on error (400 if already accepted/declined)
  Future<Invite> declineInvite({
    required String ideaId,
    required String inviteId,
  }) async {
    try {
      final endpoint = acceptInviteEndpoint
          .replaceFirst('{ideaId}', ideaId)
          .replaceFirst('{inviteId}', inviteId);
      
      final response = await _apiClient.patch(
        endpoint,
        body: {'status': 'DECLINED'},
      );

      // Backend response format: { success: true, data: {...} }
      return Invite.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to decline invite: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get all invites for an idea (sent by idea owner)
  /// Returns list of Invite objects
  /// Throws ApiException on error
  Future<List<Invite>> getIdeaInvites(String ideaId) async {
    try {
      final endpoint = getIdeaInvitesEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> invites = response['data'] ?? [];
      return invites.map((json) => Invite.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch idea invites: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get all invites for current user (received invites)
  /// Returns list of Invite objects
  /// Throws ApiException on error (401 if not authenticated)
  Future<List<Invite>> getUserInvites() async {
    try {
      final response = await _apiClient.get(getUserInvitesEndpoint);

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> invites = response['data'] ?? [];
      return invites.map((json) => Invite.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch user invites: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get pending invites for current user
  /// Returns list of Invite objects with status PENDING
  /// Throws ApiException on error (401 if not authenticated)
  Future<List<Invite>> getPendingInvites() async {
    try {
      final response = await _apiClient.get(getPendingInvitesEndpoint);

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> invites = response['data'] ?? [];
      return invites.map((json) => Invite.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch pending invites: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
