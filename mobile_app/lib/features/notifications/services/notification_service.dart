import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/error_handler.dart';
import '../models/notification_item.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  final ApiClient _apiClient = ApiClient();
  final Map<String, NotificationItem> _cacheById = {};

  List<NotificationItem> getCachedNotifications() {
    final list = _cacheById.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Set<String> getCachedNotificationIds() {
    return _cacheById.keys.toSet();
  }

  void clearCache() {
    _cacheById.clear();
  }

  void _mergeIntoCache(List<NotificationItem> notifications) {
    for (final notification in notifications) {
      if (notification.id.isEmpty) {
        continue;
      }

      _cacheById[notification.id] = notification;
    }
  }

  Future<List<NotificationItem>> getNotifications({
    int limit = 50,
    bool allowCacheFallback = true,
  }) async {
    try {
      final response = await _apiClient.get(
        '$getNotificationsEndpoint?limit=$limit',
      );

      final list = response['data'] as List<dynamic>? ?? [];
      final notifications = list
          .map(
            (item) =>
                NotificationItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      _mergeIntoCache(notifications);
      return getCachedNotifications();
    } on ApiException {
      if (allowCacheFallback && _cacheById.isNotEmpty) {
        return getCachedNotifications();
      }

      rethrow;
    } catch (e) {
      if (allowCacheFallback && _cacheById.isNotEmpty) {
        return getCachedNotifications();
      }

      throw ApiException(
        message: 'Failed to fetch notifications: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
