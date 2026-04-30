enum NotificationType {
  invite,
  comment,
  rating,
  unknown,
}

NotificationType notificationTypeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'INVITE':
      return NotificationType.invite;
    case 'COMMENT':
      return NotificationType.comment;
    case 'RATING':
      return NotificationType.rating;
    default:
      return NotificationType.unknown;
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.metadata = const {},
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      type: notificationTypeFromString(json['type'] ?? ''),
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? const {}),
    );
  }
}
