import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/comment.dart';
import '../../../core/constants/api_constants.dart';

class CommentService {
  final ApiClient _apiClient = ApiClient();

  /// Post a comment on an idea
  /// Returns the created Comment object
  /// Throws ApiException on error
  Future<Comment> createComment({
    required String ideaId,
    required String text,
  }) async {
    try {
      if (text.isEmpty) {
        throw ApiException(
          message: 'Comment text cannot be empty',
          statusCode: 400,
        );
      }

      final endpoint = createCommentEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.post(
        endpoint,
        body: {'content': text},
      );

      // Backend response format: { success: true, data: {...} }
      return Comment.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to create comment: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get all comments for an idea
  /// Returns list of Comment objects with pagination
  /// Throws ApiException on error (404 if idea not found)
  Future<List<Comment>> getIdeaComments(
    String ideaId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final endpoint =
          getCommentsEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(
        '$endpoint?page=$page&limit=$limit',
      );

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> comments = response['data'] ?? [];
      return comments
          .map((json) => Comment.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch comments: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Delete a comment
  /// Throws ApiException on error (403 if not comment owner, 404 if not found)
  Future<void> deleteComment({
    required String ideaId,
    required String commentId,
  }) async {
    try {
      final endpoint = deleteCommentEndpoint
          .replaceFirst('{ideaId}', ideaId)
          .replaceFirst('{commentId}', commentId);

      await _apiClient.delete(endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete comment: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
