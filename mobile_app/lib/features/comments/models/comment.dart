class Comment {
  final String id;
  final String ideaId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.ideaId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  /// Create Comment from JSON response from backend API
  factory Comment.fromJson(Map<String, dynamic> json) {
    // Handle nested user object or direct fields
    final user = json['user'] as Map<String, dynamic>?;
    final userName =
        user?['name'] ?? user?['username'] ?? json['userName'] ?? 'Anonymous';
    
    return Comment(
      id: json['id'] ?? '',
      ideaId: json['ideaId'] ?? '',
      userId: user?['id'] ?? json['userId'] ?? '',
      userName: userName as String,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert Comment to JSON for sending to backend API
  Map<String, dynamic> toJson() => {
    'id': id,
    'ideaId': ideaId,
    'userId': userId,
    'userName': userName,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  /// Return a copy with updated content
  Comment copyWithContent(String newContent) {
    return Comment(
      id: id,
      ideaId: ideaId,
      userId: userId,
      userName: userName,
      content: newContent,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => 'Comment(userName: $userName, content: ${content.substring(0, 30)}...)';
}
