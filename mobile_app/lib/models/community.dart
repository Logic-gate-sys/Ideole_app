/// Community model
class Community {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String organizationId;
  final int memberCount;
  final bool isPublic;
  final String status; // ACTIVE, DORMANT, DISSOLVED
  final DateTime createdAt;
  final bool isMember; // True if current user is member
  final bool hasPendingRequest; // True if user has pending join request

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.organizationId,
    this.memberCount = 0,
    this.isPublic = true,
    this.status = 'ACTIVE',
    required this.createdAt,
    this.isMember = false,
    this.hasPendingRequest = false,
  });

  /// Create Community from JSON (API response)
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      organizationId: json['organizationId'] as String,
      memberCount: json['memberCount'] as int? ?? 0,
      isPublic: json['isPublic'] as bool? ?? true,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isMember: json['isMember'] as bool? ?? false,
      hasPendingRequest: json['hasPendingRequest'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'organizationId': organizationId,
      'memberCount': memberCount,
      'isPublic': isPublic,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'isMember': isMember,
      'hasPendingRequest': hasPendingRequest,
    };
  }

  /// Copy with updated fields
  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? organizationId,
    int? memberCount,
    bool? isPublic,
    String? status,
    DateTime? createdAt,
    bool? isMember,
    bool? hasPendingRequest,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      organizationId: organizationId ?? this.organizationId,
      memberCount: memberCount ?? this.memberCount,
      isPublic: isPublic ?? this.isPublic,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isMember: isMember ?? this.isMember,
      hasPendingRequest: hasPendingRequest ?? this.hasPendingRequest,
    );
  }
}
