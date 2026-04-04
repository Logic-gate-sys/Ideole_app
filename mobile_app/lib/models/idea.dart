/// Idea model representing a user's vision/idea
class Idea {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final String? ownerName;
  final String? ownerAvatar;
  final String visibility; // PUBLIC, PROTECTED, PRIVATE
  final String stage; // INCEPTION, COLLABORATIVE, IMPLEMENTATION
  final String? communityId;
  final String? organizationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int ratingCount;
  final double? averageRating;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    required this.visibility,
    required this.stage,
    this.communityId,
    this.organizationId,
    required this.createdAt,
    required this.updatedAt,
    this.ratingCount = 0,
    this.averageRating,
  });

  /// Create Idea from JSON (API response)
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['owner']?['username'] as String?,
      ownerAvatar: json['owner']?['profileUrl'] as String?,
      visibility: json['visibility'] as String? ?? 'PUBLIC',
      stage: json['stage'] as String? ?? 'INCEPTION',
      communityId: json['communityId'] as String?,
      organizationId: json['organizationId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ratingCount: json['ratingCount'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'visibility': visibility,
      'stage': stage,
      'communityId': communityId,
      'organizationId': organizationId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ratingCount': ratingCount,
      'averageRating': averageRating,
    };
  }

  /// Copy with updated fields
  Idea copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    String? ownerName,
    String? ownerAvatar,
    String? visibility,
    String? stage,
    String? communityId,
    String? organizationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? ratingCount,
    double? averageRating,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      visibility: visibility ?? this.visibility,
      stage: stage ?? this.stage,
      communityId: communityId ?? this.communityId,
      organizationId: organizationId ?? this.organizationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ratingCount: ratingCount ?? this.ratingCount,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}
