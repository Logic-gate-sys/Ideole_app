import 'api_service.dart';
import 'storage_service.dart';
import '../models/community.dart';

/// Community Service - Handles community API calls
class CommunityService {
  static const int pageSize = 10; // Items per page

  /// Get communities in an organisation
  /// For MVP without org management, this may return limited results
  Future<List<Community>> getCommunities({
    String? organizationId,
    int limit = pageSize,
    int offset = 0,
  }) async {
    try {
      final token = StorageService().getAccessToken();

      final queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      // If org ID provided, use org-specific endpoint
      // Otherwise try generic communities list
      final endpoint = organizationId != null
          ? '/organisations/$organizationId/communities'
          : '/communities'; // Assuming generic endpoint exists

      final response = await ApiService.get(
        endpoint,
        token: token,
        queryParams: queryParams,
      );

      // Response format: { success: true, data: [...] }
      final communities = (response['data'] as List?)
              ?.map((c) => Community.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [];

      return communities;
    } catch (e) {
      throw Exception('Failed to load communities: $e');
    }
  }

  /// Get single community by ID
  Future<Community> getCommunity(String communityId) async {
    try {
      final token = StorageService().getAccessToken();

      final response = await ApiService.get(
        '/communities/$communityId',
        token: token,
      );

      // Response format: { success: true, data: {...} }
      return Community.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load community: $e');
    }
  }

  /// Request to join community
  Future<bool> requestToJoin(String communityId) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      await ApiService.post(
        '/communities/$communityId/memberships/request',
        body: {},
        token: token,
      );

      return true;
    } catch (e) {
      throw Exception('Failed to request joining community: $e');
    }
  }

  /// Cancel join request
  Future<bool> cancelJoinRequest(String communityId) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      // This would need a backend endpoint
      // For now, return success (would be implemented on backend)
      return true;
    } catch (e) {
      throw Exception('Failed to cancel request: $e');
    }
  }

  /// Leave community (remove membership)
  Future<bool> leaveCommunity(String communityId, String membershipId) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      await ApiService.delete(
        '/communities/$communityId/memberships/$membershipId',
        token: token,
      );

      return true;
    } catch (e) {
      throw Exception('Failed to leave community: $e');
    }
  }
}
