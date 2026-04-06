import 'api_service.dart';
import 'storage_service.dart';
import '../models/organisation.dart';

/// Organisation Service - Handles organisation API calls
class OrganisationService {
  static const int pageSize = 10; // Items per page

  /// Get all organisations with pagination
  Future<List<Organisation>> getOrganisations({
    int limit = pageSize,
    int offset = 0,
    String? search,
  }) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await ApiService.get(
        '/organisations',
        token: token!,
        queryParams: queryParams,
      );

      // Response format: { success: true, data: [...] }
      final organisations = (response['data'] as List?)
              ?.map((o) => Organisation.fromJson(o as Map<String, dynamic>))
              .toList() ??
          [];

      return organisations;
    } catch (e) {
      throw Exception('Failed to load organisations: $e');
    }
  }

  /// Get single organisation by ID
  Future<Organisation> getOrganisation(String organisationId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.get(
        '/organisations/$organisationId',
        token: token!,
      );

      // Response format: { success: true, data: {...} }
      return Organisation.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load organisation: $e');
    }
  }

  /// Search organisations by name or description
  Future<List<Organisation>> searchOrganisations(String query) async {
    return getOrganisations(search: query);
  }

  /// Create a new organisation
  Future<Organisation> createOrganisation({
    required String name,
    String? description,
    String visibility = 'PRIVATE',
  }) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.post(
        '/organisations',
        body: {
          'name': name,
          'description': description,
          'visibility': visibility,
        },
        token: token!,
      );

      return Organisation.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create organisation: $e');
    }
  }

  /// Update organisation
  Future<Organisation> updateOrganisation(
    String organisationId, {
    String? name,
    String? description,
    String? visibility,
  }) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final body = <String, dynamic>{
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (visibility != null) 'visibility': visibility,
      };

      final response = await ApiService.put(
        '/organisations/$organisationId',
        body: body,
        token: token!,
      );

      return Organisation.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update organisation: $e');
    }
  }

  /// Join an organisation
  Future<void> joinOrganisation(String organisationId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      await ApiService.post(
        '/organisations/$organisationId/join',
        body: {},
        token: token!,
      );
    } catch (e) {
      throw Exception('Failed to join organisation: $e');
    }
  }

  /// Leave an organisation
  Future<void> leaveOrganisation(String organisationId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      await ApiService.delete(
        '/organisations/$organisationId/leave',
        token: token!,
      );
    } catch (e) {
      throw Exception('Failed to leave organisation: $e');
    }
  }

  /// Get organisation members
  Future<List<Map<String, dynamic>>> getOrganisationMembers(
    String organisationId,
  ) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.get(
        '/organisations/$organisationId/members',
        token: token!,
      );

      return (response['data'] as List?)
              ?.map((m) => m as Map<String, dynamic>)
              .toList() ??
          [];
    } catch (e) {
      throw Exception('Failed to load members: $e');
    }
  }
}
