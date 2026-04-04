class Organisation {
  final String id;
  final String name;
  final String tier; // starter, professional, enterprise
  final int maxCommunities;
  final String ownerId;
  final DateTime createdAt;

  Organisation({
    required this.id,
    required this.name,
    required this.tier,
    required this.maxCommunities,
    required this.ownerId,
    required this.createdAt,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      tier: json['tier'] ?? 'starter',
      maxCommunities: json['maxCommunities'] ?? 5,
      ownerId: json['ownerId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tier': tier,
    'maxCommunities': maxCommunities,
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
  };

  // Useful getter to check if user owns this organisation
  bool isOwnedBy(String userId) => ownerId == userId;
}
