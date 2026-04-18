class Conversation {
  final String id;
  final String contextId;
  final String contextType;
  final String? ideaId;
  final DateTime createdAt;
  final int messageCount;

  Conversation({
    required this.id,
    required this.contextId,
    required this.contextType,
    this.ideaId,
    required this.createdAt,
    required this.messageCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      contextId: json['contextId'] ?? '',
      contextType: json['contextType'] ?? 'IDEA',
      ideaId: json['ideaId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ConversationMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime sentAt;

  ConversationMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.sentAt,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return ConversationMessage(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? user?['id'] ?? '',
      senderName:
          user?['name'] ?? user?['username'] ?? json['senderName'] ?? 'Unknown',
      content: json['content'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}
