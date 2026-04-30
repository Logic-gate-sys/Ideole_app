import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification_item.dart';
import 'notification_service.dart';

/// Polls user notifications and shows device push alerts for new items.
class NotificationPushService {
  NotificationPushService({
    NotificationService? notificationService,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  }) : _notificationService = notificationService ?? NotificationService(),
       _localNotificationsPlugin =
           localNotificationsPlugin ?? FlutterLocalNotificationsPlugin();

  static const Duration _pollInterval = Duration(seconds: 25);
  static const String _channelId = 'ideole_user_notifications';
  static const String _channelName = 'Ideole Notifications';
  static const String _channelDescription =
      'Alerts for comment, rating, invite, and other user notifications.';

  static const AndroidNotificationChannel _notificationChannel =
      AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );

  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  final Set<String> _seenNotificationIds = <String>{};

  Timer? _pollingTimer;
  String? _activeUserId;
  bool _initialized = false;
  bool _isPolling = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(initSettings);
    await _createNotificationChannel();
    await _requestPermissions();
    _initialized = true;
  }

  Future<void> startForUser(String userId) async {
    if (userId.trim().isEmpty) {
      await stop();
      return;
    }

    await init();

    if (_activeUserId == userId && _pollingTimer?.isActive == true) {
      return;
    }

    await stop(clearSeenCache: true);
    _activeUserId = userId;

    _seenNotificationIds
      ..clear()
      ..addAll(_notificationService.getCachedNotificationIds());

    try {
      final current = await _notificationService.getNotifications(
        limit: 100,
        allowCacheFallback: true,
      );
      _seenNotificationIds.addAll(
        current.where((n) => n.id.isNotEmpty).map((n) => n.id),
      );
    } catch (_) {
      // Keep push flow alive even when prime fetch fails.
    }

    _pollingTimer = Timer.periodic(_pollInterval, (_) {
      unawaited(_pollAndNotify());
    });

    unawaited(_pollAndNotify());
  }

  Future<void> stop({bool clearSeenCache = true}) async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _activeUserId = null;

    if (clearSeenCache) {
      _seenNotificationIds.clear();
    }
  }

  Future<void> dispose() async {
    await stop(clearSeenCache: true);
  }

  Future<void> _pollAndNotify() async {
    if (_isPolling || _activeUserId == null) {
      return;
    }

    _isPolling = true;

    try {
      final notifications = await _notificationService.getNotifications(
        limit: 100,
        allowCacheFallback: true,
      );

      final unseen =
          notifications
              .where((item) => item.id.isNotEmpty)
              .where((item) => !_seenNotificationIds.contains(item.id))
              .toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final notification in unseen) {
        await _showLocalNotification(notification);
        _seenNotificationIds.add(notification.id);
      }

      _trimSeenCache(notifications);
    } catch (_) {
      // Ignore polling errors and retry in next interval.
    } finally {
      _isPolling = false;
    }
  }

  Future<void> _showLocalNotification(NotificationItem notification) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotificationsPlugin.show(
      _notificationIdFrom(notification.id),
      notification.title,
      notification.message,
      details,
      payload: notification.id,
    );
  }

  Future<void> _createNotificationChannel() async {
    final android = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(_notificationChannel);
  }

  Future<void> _requestPermissions() async {
    final android = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();

    final ios = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);

    final macos = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    await macos?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _trimSeenCache(List<NotificationItem> latestNotifications) {
    const maxSeenIds = 500;
    if (_seenNotificationIds.length <= maxSeenIds) {
      return;
    }

    final latestIds = latestNotifications
        .where((item) => item.id.isNotEmpty)
        .map((item) => item.id)
        .take(maxSeenIds)
        .toSet();

    _seenNotificationIds
      ..clear()
      ..addAll(latestIds);
  }

  int _notificationIdFrom(String id) {
    return id.hashCode & 0x7fffffff;
  }
}
