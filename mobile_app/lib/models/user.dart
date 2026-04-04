/// User model representing user profile data
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? username;
  final String? bio;
  final String? location;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActive;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.username,
    this.bio,
    this.location,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.lastActive,
  });

  /// Get full name (convenience getter)
  String get fullName => '$firstName $lastName';

  /// Create User from JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? json['first_name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? json['last_name'] as String? ?? '',
      username: json['username'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? json['created_at'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? json['updated_at'] as String),
      lastActive: json['lastActive'] != null || json['last_active'] != null
          ? DateTime.parse(json['lastActive'] as String? ?? json['last_active'] as String)
          : null,
    );
  }

  /// Convert User to JSON (for requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'bio': bio,
      'location': location,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  /// Create a copy of User with modified fields
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    String? location,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
