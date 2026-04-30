class MembershipUser {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profileUrl;

  MembershipUser({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.profileUrl,
  });

  factory MembershipUser.fromJson(Map<String, dynamic> json) {
    return MembershipUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileUrl: json['profileUrl'],
    );
  }

  String get displayName {
    final first = (firstName ?? '').trim();
    final last = (lastName ?? '').trim();
    if (first.isEmpty && last.isEmpty) {
      return username;
    }
    return '$first $last'.trim();
  }
}

class Membership {
  final String id;
  final String userId;
  final String communityId;
  final String? organisationId;
  final String role;
  final String status;
  final DateTime joinedAt;
  final MembershipUser? user;
  final String? communityName;

  Membership({
    required this.id,
    required this.userId,
    required this.communityId,
    this.organisationId,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.user,
    this.communityName,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isAdminRole => role.toLowerCase() == 'admin';

  factory Membership.fromJson(Map<String, dynamic> json) {
    final community = json['community'] as Map<String, dynamic>?;

    return Membership(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      communityId: json['communityId'] ?? community?['id'] ?? '',
      organisationId: json['organisationId'],
      role: json['role'] ?? 'member',
      status: json['status'] ?? 'PENDING',
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      user: json['user'] != null
          ? MembershipUser.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
      communityName: community?['name'],
    );
  }

  Membership copyWith({
    String? id,
    String? userId,
    String? communityId,
    String? organisationId,
    String? role,
    String? status,
    DateTime? joinedAt,
    MembershipUser? user,
    String? communityName,
  }) {
    return Membership(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      communityId: communityId ?? this.communityId,
      organisationId: organisationId ?? this.organisationId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      user: user ?? this.user,
      communityName: communityName ?? this.communityName,
    );
  }
}
