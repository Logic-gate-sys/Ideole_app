import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/idea.dart';
import '../../../core/constants/api_constants.dart';

class IdeaService {
  final ApiClient _apiClient = ApiClient();

  /// Get all visible ideas (public and community)
  /// Returns list of Idea objects
  /// Throws ApiException on error
  Future<List<Idea>> getVisibleIdeas({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '$getIdeasEndpoint?page=$page&limit=$limit&visibility=public,community',
      );

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> ideas = response['data'] ?? [];
      return ideas.map((json) => Idea.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch visible ideas: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get current user's own ideas
  /// Returns list of Idea objects
  /// Throws ApiException on error (401 if not authenticated)
  Future<List<Idea>> getUserIdeas({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '$getUserIdeasEndpoint?page=$page&limit=$limit',
      );

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> ideas = response['data'] ?? [];
      return ideas.map((json) => Idea.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch user ideas: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get a specific idea by ID
  /// Returns Idea object
  /// Throws ApiException on error (404 if not found)
  Future<Idea> getIdeaById(String ideaId) async {
    try {
      final endpoint = getIdeaDetailsEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);

      // Backend response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Create a new idea
  /// Returns created Idea object
  /// Throws ApiException on error (400 for validation errors)
  Future<Idea> createIdea({
    required String title,
    required String problemText,
    required String solutionText,
    required String category,
    required IdeaVisibility visibility,
  }) async {
    try {
      final response = await _apiClient.post(
        createIdeaEndpoint,
        body: {
          'title': title,
          'problemText': problemText,
          'solutionText': solutionText,
          'category': category,
          'visibility': visibility.toString().split('.').last.toUpperCase(),
        },
      );

      // Backend response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Update an existing idea
  /// Returns updated Idea object
  /// Throws ApiException on error (403 if not owner, 404 if not found)
  Future<Idea> updateIdea(
    String ideaId, {
    String? title,
    String? problemText,
    String? solutionText,
    String? category,
    IdeaVisibility? visibility,
  }) async {
    try {
      final endpoint = updateIdeaEndpoint.replaceFirst('{ideaId}', ideaId);
      final body = <String, dynamic>{
        'title': ?title,
        'problemText': ?problemText,
        'solutionText': ?solutionText,
        'category': ?category,
        if (visibility != null)
          'visibility': visibility.toString().split('.').last.toUpperCase(),
      };

      final response = await _apiClient.patch(endpoint, body: body);

      // Backend response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Toggle idea's public visibility
  /// Returns updated Idea object
  /// Throws ApiException on error (403 if not owner, 404 if not found)
  Future<Idea> toggleIdeaVisibility(String ideaId) async {
    try {
      final endpoint = toggleIdeaVisibilityEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.patch(endpoint, body: {});

      // Backend response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to toggle visibility: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
