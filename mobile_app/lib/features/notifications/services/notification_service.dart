import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/notification_item.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<NotificationItem>> getNotifications({int limit = 50}) async {
    try {
      final response = await _apiClient.get(
        '$getNotificationsEndpoint?limit=$limit',
      );

      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => NotificationItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to fetch notifications: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
