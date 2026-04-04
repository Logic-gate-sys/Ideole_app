import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/rating.dart';
import '../../../core/constants/api_constants.dart';

class RatingService {
  final ApiClient _apiClient = ApiClient();

  /// Rate an idea with three scoring dimensions
  /// Returns the created Rating object
  /// Throws ApiException on error (400 validation, 403 can't rate own idea)
  Future<Rating> rateIdea({
    required String ideaId,
    required int originality,  // 1-10
    required int feasibility,  // 1-10
    required int impact,       // 1-10
  }) async {
    try {
      // Validate each score
      for (final score in [originality, feasibility, impact]) {
        if (score < 1 || score > 10) {
          throw ApiException(
            message: 'Rating scores must be between 1 and 10',
            statusCode: 400,
          );
        }
      }

      final endpoint = createRatingEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.post(
        endpoint,
        body: {
          'originality': originality,
          'feasibility': feasibility,
          'impact': impact,
        },
      );

      // Backend response format: { success: true, data: {...} }
      return Rating.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to rate idea: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get rating statistics for an idea
  /// Returns RatingStats object with aggregated statistics
  /// Throws ApiException on error (404 if idea not found)
  Future<RatingStats> getIdeaRatingStats(String ideaId) async {
    try {
      final endpoint = getRatingStatsEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);

      // Backend response format: { success: true, data: {...} }
      return RatingStats.fromJson(response['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch rating stats: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get all ratings for an idea
  /// Returns list of Rating objects
  /// Throws ApiException on error
  Future<List<Rating>> getIdeaRatings(String ideaId) async {
    try {
      final endpoint = getIdeaRatingsEndpoint.replaceFirst('{ideaId}', ideaId);
      final response = await _apiClient.get(endpoint);

      // Backend response format: { success: true, data: [...] }
      final List<dynamic> ratings = response['data'] ?? [];
      return ratings.map((json) => Rating.fromJson(json as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch ratings: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
