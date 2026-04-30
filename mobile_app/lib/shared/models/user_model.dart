class User {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? role;
  final String? profileUrl;
  final String? status;
  final DateTime? createdAt;
  final String? token; // JWT - optional for some responses

  User({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
    this.role,
    this.profileUrl,
    this.status,
    this.createdAt,
    this.token,
  });

  String get displayName {
    final hasFirst = (firstName ?? '').trim().isNotEmpty;
    final hasLast = (lastName ?? '').trim().isNotEmpty;

    if (hasFirst || hasLast) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }

    return username;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final rawFirstName = (json['firstName'] as String?)?.trim();
    final rawLastName = (json['lastName'] as String?)?.trim();
    final fallbackName = (json['name'] as String?)?.trim();

    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? fallbackName ?? '',
      firstName: rawFirstName,
      lastName: rawLastName,
      email: json['email'] ?? '',
      role: json['role'],
      profileUrl: json['profileUrl'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'role': role,
    'profileUrl': profileUrl,
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    if (token != null) 'token': token,
  };

  User copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    String? profileUrl,
    String? status,
    DateTime? createdAt,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      profileUrl: profileUrl ?? this.profileUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }
}
