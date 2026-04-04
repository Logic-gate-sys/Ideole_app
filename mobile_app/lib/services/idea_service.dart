import 'api_service.dart';
import 'storage_service.dart';
import '../models/idea.dart';

/// Idea Service - Handles idea API calls with pagination
class IdeaService {
  static const int pageSize = 10; // Items per page

  /// Get all ideas (feed) with pagination
  /// Respects visibility (PUBLIC visible to all, PROTECTED/PRIVATE filtered)
  Future<List<Idea>> getIdeas({
    int limit = pageSize,
    int offset = 0,
    String? filter, // 'myIdeas' to get only user's ideas
  }) async {
    try {
      final token = StorageService().getAccessToken();
      
      final queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (filter != null) 'filter': filter,
      };

      final response = await ApiService.get(
        '/ideas',
        token: token, // Optional auth - exposes based on visibility
        queryParams: queryParams,
      );

      // Response format: { success: true, data: { ideas: [...], total, page } }
      final data = response['data'] as Map<String, dynamic>;
      final ideas = (data['ideas'] as List?)
          ?.map((idea) => Idea.fromJson(idea as Map<String, dynamic>))
          .toList() ?? [];
      
      return ideas;
    } catch (e) {
      throw Exception('Failed to load ideas: $e');
    }
  }

  /// Get single idea by ID
  Future<Idea> getIdea(String ideaId) async {
    try {
      final token = StorageService().getAccessToken();

      final response = await ApiService.get(
        '/ideas/$ideaId',
        token: token,
      );

      // Response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load idea: $e');
    }
  }

  /// Create new idea
  Future<Idea> createIdea({
    required String title,
    required String description,
    required String visibility, // PUBLIC, PROTECTED, PRIVATE
    String? communityId,
    String? organizationId,
  }) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await ApiService.post(
        '/ideas',
        body: {
          'title': title,
          'description': description,
          'visibility': visibility,
          if (communityId != null) 'communityId': communityId,
          if (organizationId != null) 'organizationId': organizationId,
        },
        token: token,
      );

      // Response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create idea: $e');
    }
  }

  /// Update idea
  Future<Idea> updateIdea({
    required String ideaId,
    required String title,
    required String description,
    required String visibility,
  }) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await ApiService.put(
        '/ideas/$ideaId',
        body: {
          'title': title,
          'description': description,
          'visibility': visibility,
        },
        token: token,
      );

      // Response format: { success: true, data: {...} }
      return Idea.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update idea: $e');
    }
  }

  /// Delete idea
  Future<void> deleteIdea(String ideaId) async {
    try {
      final token = StorageService().getAccessToken();

      if (token == null) {
        throw Exception('Not authenticated');
      }

      await ApiService.delete(
        '/ideas/$ideaId',
        token: token,
      );
    } catch (e) {
      throw Exception('Failed to delete idea: $e');
    }
  }
}
