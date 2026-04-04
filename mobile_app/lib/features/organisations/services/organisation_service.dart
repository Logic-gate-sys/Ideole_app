import '../../../shared/models/organisation_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';

class OrganisationService {
  final ApiClient _apiClient = ApiClient();

  /// Create a new organisation
  /// Returns Organisation object
  /// Throws ApiException on error
  Future<Organisation> createOrganisation({
    required String name,
    required String tier,
  }) async {
    try {
      final response = await _apiClient.post(
        createOrganisationEndpoint,
        body: {
          'name': name,
          'tier': tier,
        },
      );

      // Backend response: { success: true, data: { id, name, tier, maxCommunities, ... } }
      return Organisation.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create organisation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get a specific organisation by ID
  /// Returns Organisation object
  /// Throws ApiException on error
  Future<Organisation> getOrganisation(String organisationId) async {
    try {
      final endpoint = getOrganisationEndpoint.replaceFirst(
        '{organisationId}',
        organisationId,
      );
      final response = await _apiClient.get(endpoint);

      return Organisation.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch organisation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// List all organisations owned by user
  /// Returns list of Organisation objects
  /// Throws ApiException on error
  Future<List<Organisation>> listOrganisations() async {
    try {
      final response = await _apiClient.get(listOrganisationsEndpoint);

      // Backend response: { success: true, data: [{ id, name, ... }, ...] }
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((org) => Organisation.fromJson(org as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch organisations: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Update an organisation
  /// Returns updated Organisation object
  /// Throws ApiException on error
  Future<Organisation> updateOrganisation({
    required String organisationId,
    required String name,
    required String tier,
  }) async {
    try {
      final endpoint = updateOrganisationEndpoint.replaceFirst(
        '{organisationId}',
        organisationId,
      );
      final response = await _apiClient.put(
        endpoint,
        body: {
          'name': name,
          'tier': tier,
        },
      );

      return Organisation.fromJson(response['data']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update organisation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Delete an organisation
  /// Throws ApiException on error
  Future<void> deleteOrganisation(String organisationId) async {
    try {
      final endpoint = deleteOrganisationEndpoint.replaceFirst(
        '{organisationId}',
        organisationId,
      );
      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete organisation: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
