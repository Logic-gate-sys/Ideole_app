import '../../../shared/models/community_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';

class CommunityService {
  final ApiClient _apiClient = ApiClient();

  /// Create a new community within an organisation
  /// Returns Community object
  /// Throws ApiException on error
  Future<Community> createCommunity({
    required String organisationId,
    required String name,
    String? description,
    required String visibility,
  }) async {
    try {
      final endpoint = createCommunityEndpoint.replaceFirst(
        '{organisationId}',
        organisationId,
      );
      final response = await _apiClient.post(
        endpoint,
        body: {
          'name': name,
          'description': description,
          'visibility': visibility,
        },
      );

      // Backend response: { success: true, data: { id, name, ... } }
      return Community.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create community: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get a specific community by ID
  /// Returns Community object
  /// Throws ApiException on error
  Future<Community> getCommunity({
    required String organisationId,
    required String communityId,
  }) async {
    try {
      final endpoint = getCommunityEndpoint
          .replaceFirst('{organisationId}', organisationId)
          .replaceFirst('{communityId}', communityId);

      final response = await _apiClient.get(endpoint);
      return Community.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch community: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// List all communities in an organisation
  /// Returns list of Community objects
  /// Throws ApiException on error
  Future<List<Community>> listCommunities(String organisationId) async {
    try {
      final endpoint = listCommunitiesEndpoint.replaceFirst(
        '{organisationId}',
        organisationId,
      );
      final response = await _apiClient.get(endpoint);

      // Backend response: { success: true, data: [{ id, name, ... }, ...] }
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((community) => Community.fromJson(community as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch communities: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Update a community
  /// Returns updated Community object
  /// Throws ApiException on error
  Future<Community> updateCommunity({
    required String organisationId,
    required String communityId,
    required String name,
    String? description,
    required String visibility,
  }) async {
    try {
      final endpoint = updateCommunityEndpoint
          .replaceFirst('{organisationId}', organisationId)
          .replaceFirst('{communityId}', communityId);

      final response = await _apiClient.put(
        endpoint,
        body: {
          'name': name,
          'description': description,
          'visibility': visibility,
        },
      );

      return Community.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update community: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Delete a community
  /// Throws ApiException on error
  Future<void> deleteCommunity({
    required String organisationId,
    required String communityId,
  }) async {
    try {
      final endpoint = deleteCommunityEndpoint
          .replaceFirst('{organisationId}', organisationId)
          .replaceFirst('{communityId}', communityId);

      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete community: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
