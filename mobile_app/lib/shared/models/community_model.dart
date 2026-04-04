class Community {
  final String id;
  final String name;
  final String? description;
  final String visibility; // PUBLIC, PROTECTED, PRIVATE
  final String status; // ACTIVE, DORMANT, BANNED, PENDING
  final String adminId;
  final String organisationId;
  final DateTime createdAt;

  Community({
    required this.id,
    required this.name,
    this.description,
    required this.visibility,
    required this.status,
    required this.adminId,
    required this.organisationId,
    required this.createdAt,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      visibility: json['visibility'] ?? 'PUBLIC',
      status: json['status'] ?? 'ACTIVE',
      adminId: json['adminId'] ?? '',
      organisationId: json['organisationId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'visibility': visibility,
    'status': status,
    'adminId': adminId,
    'organisationId': organisationId,
    'createdAt': createdAt.toIso8601String(),
  };

  // Useful getters
  bool isAdminOf(String userId) => adminId == userId;

  bool get isActive => status == 'ACTIVE';

  bool get isPublic => visibility == 'PUBLIC';
}
