import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../../../shared/models/user_model.dart';

class UserLookupService {
  final ApiClient _apiClient = ApiClient();

  Future<List<User>> searchUsers(String query, {int limit = 8}) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      return [];
    }

    try {
      final response = await _apiClient.get(
        searchUsersEndpoint,
        queryParams: {'q': normalizedQuery, 'limit': limit},
      );

      final users = response['data'] as List<dynamic>? ?? [];
      return users
          .map((json) => User.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to search users: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
