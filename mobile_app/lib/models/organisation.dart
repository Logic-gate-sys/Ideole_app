/// Organisation model
class Organisation {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String ownerId;
  final int memberCount;
  final int projectCount;
  final DateTime createdAt;
  final String visibility; // PUBLIC, PRIVATE
  final String status; // ACTIVE, ARCHIVED

  Organisation({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.ownerId,
    required this.memberCount,
    required this.projectCount,
    required this.createdAt,
    required this.visibility,
    required this.status,
  });

  /// Create Organisation from JSON response
  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      ownerId: json['ownerId'] as String,
      memberCount: json['memberCount'] as int? ?? 0,
      projectCount: json['projectCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      visibility: json['visibility'] as String? ?? 'PRIVATE',
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'logoUrl': logoUrl,
    'ownerId': ownerId,
    'memberCount': memberCount,
    'projectCount': projectCount,
    'createdAt': createdAt.toIso8601String(),
    'visibility': visibility,
    'status': status,
  };

  /// Copy with method for immutability
  Organisation copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? ownerId,
    int? memberCount,
    int? projectCount,
    DateTime? createdAt,
    String? visibility,
    String? status,
  }) {
    return Organisation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      ownerId: ownerId ?? this.ownerId,
      memberCount: memberCount ?? this.memberCount,
      projectCount: projectCount ?? this.projectCount,
      createdAt: createdAt ?? this.createdAt,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'Organisation(id: $id, name: $name, status: $status)';
}
