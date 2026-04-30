import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/membership_model.dart';

class MembershipService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Membership>> getMyMemberships() async {
    try {
      final response = await _apiClient.get(getUserMembershipsEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => Membership.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch memberships: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Membership> requestToJoinCommunity(String communityId) async {
    try {
      final endpoint = requestMembershipEndpoint.replaceFirst(
        '{communityId}',
        communityId,
      );
      final response = await _apiClient.post(endpoint);
      return Membership.fromJson(Map<String, dynamic>.from(response['data']));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to request membership: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<List<Membership>> getCommunityMembers(String communityId) async {
    try {
      final endpoint = getCommunityMembersEndpoint.replaceFirst(
        '{communityId}',
        communityId,
      );
      final response = await _apiClient.get(endpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => Membership.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch community members: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<List<Membership>> getPendingMembershipRequests(String communityId) async {
    try {
      final endpoint = getPendingMembershipsEndpoint.replaceFirst(
        '{communityId}',
        communityId,
      );
      final response = await _apiClient.get(endpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => Membership.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch pending requests: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<Membership> approveMembershipRequest({
    required String communityId,
    required String membershipId,
  }) async {
    try {
      final endpoint = approveMembershipEndpoint
          .replaceFirst('{communityId}', communityId)
          .replaceFirst('{membershipId}', membershipId);
      final response = await _apiClient.patch(endpoint);
      return Membership.fromJson(Map<String, dynamic>.from(response['data']));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to approve request: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> rejectMembershipRequest({
    required String communityId,
    required String membershipId,
  }) async {
    try {
      final endpoint = rejectMembershipEndpoint
          .replaceFirst('{communityId}', communityId)
          .replaceFirst('{membershipId}', membershipId);
      await _apiClient.patch(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to reject request: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  Future<void> removeMembership({
    required String communityId,
    required String membershipId,
  }) async {
    try {
      final endpoint = removeMembershipEndpoint
          .replaceFirst('{communityId}', communityId)
          .replaceFirst('{membershipId}', membershipId);
      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to remove membership: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
