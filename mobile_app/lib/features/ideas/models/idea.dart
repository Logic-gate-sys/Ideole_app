enum IdeaVisibility {
  protected,
  private,
  public,
}

IdeaVisibility visibilityFromString(String value) {
  return IdeaVisibility.values.firstWhere(
    (v) => v.toString().split('.').last.toUpperCase() == value.toUpperCase(),
    orElse: () => IdeaVisibility.private,
  );
}

String visibilityToString(IdeaVisibility visibility) {
  return visibility.toString().split('.').last.toUpperCase();
}

enum IdeaStage {
  inception,
  collaborative,
  implementation,
}

IdeaStage stageFromString(String value) {
  return IdeaStage.values.firstWhere(
    (v) => v.toString().split('.').last.toUpperCase() == value.toUpperCase(),
    orElse: () => IdeaStage.inception,
  );
}

String stageToString(IdeaStage stage) {
  return stage.toString().split('.').last.toUpperCase();
}

class IdeaCriteriaInput {
  final String name;
  final String description;

  const IdeaCriteriaInput({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };
}

/// Represents a custom evaluation criterion for an idea
class EvaluationCriteria {
  final String id;
  final String ideaId;
  final String name;
  final String description;
  final int order;

  EvaluationCriteria({
    required this.id,
    required this.ideaId,
    required this.name,
    required this.description,
    required this.order,
  });

  factory EvaluationCriteria.fromJson(Map<String, dynamic> json) {
    return EvaluationCriteria(
      id: json['id'] ?? '',
      ideaId: json['ideaId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ideaId': ideaId,
    'name': name,
    'description': description,
    'order': order,
  };

  EvaluationCriteria copyWith({
    String? id,
    String? ideaId,
    String? name,
    String? description,
    int? order,
  }) {
    return EvaluationCriteria(
      id: id ?? this.id,
      ideaId: ideaId ?? this.ideaId,
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
    );
  }
}

class Idea {
  final String id;
  final String title;
  final String description;
  final IdeaVisibility visibility;
  final IdeaStage stage;
  final String ownerId;
  final String ownerUsername;
  final String? ownerProfileUrl;
  final String? communityId;
  final String? organisationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int ratingCount;
  final int commentCount;
  final List<EvaluationCriteria> criteria;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.visibility,
    required this.stage,
    required this.ownerId,
    required this.ownerUsername,
    this.ownerProfileUrl,
    this.communityId,
    this.organisationId,
    required this.createdAt,
    required this.updatedAt,
    this.ratingCount = 0,
    this.commentCount = 0,
    this.criteria = const [],
  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;
    final counts = json['_count'] as Map<String, dynamic>?;
    final criteriaData = (json['criteria'] as List<dynamic>? ?? [])
        .map((c) => EvaluationCriteria.fromJson(c as Map<String, dynamic>))
        .toList();

    return Idea(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      visibility: visibilityFromString(json['visibility'] ?? 'PRIVATE'),
      stage: stageFromString(json['stage'] ?? 'INCEPTION'),
      ownerId: json['ownerId'] ?? owner?['id'] ?? '',
      ownerUsername: owner?['username'] ?? '',
      ownerProfileUrl: owner?['profileUrl'],
      communityId: json['communityId'],
      organisationId: json['organisationId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      ratingCount: (json['ratingCount'] as num?)?.toInt() ??
          (counts?['ratings'] as num?)?.toInt() ??
          0,
      commentCount: (json['commentCount'] as num?)?.toInt() ??
          (counts?['comments'] as num?)?.toInt() ??
          0,
      criteria: criteriaData,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'visibility': visibilityToString(visibility),
    'stage': stageToString(stage),
    'ownerId': ownerId,
    'ownerUsername': ownerUsername,
    'ownerProfileUrl': ownerProfileUrl,
    'communityId': communityId,
    'organisationId': organisationId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'ratingCount': ratingCount,
    'commentCount': commentCount,
    'criteria': criteria.map((c) => c.toJson()).toList(),
  };

  Idea copyWith({
    String? id,
    String? title,
    String? description,
    IdeaVisibility? visibility,
    IdeaStage? stage,
    String? ownerId,
    String? ownerUsername,
    String? ownerProfileUrl,
    String? communityId,
    String? organisationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? ratingCount,
    int? commentCount,
    List<EvaluationCriteria>? criteria,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      stage: stage ?? this.stage,
      ownerId: ownerId ?? this.ownerId,
      ownerUsername: ownerUsername ?? this.ownerUsername,
      ownerProfileUrl: ownerProfileUrl ?? this.ownerProfileUrl,
      communityId: communityId ?? this.communityId,
      organisationId: organisationId ?? this.organisationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ratingCount: ratingCount ?? this.ratingCount,
      commentCount: commentCount ?? this.commentCount,
      criteria: criteria ?? this.criteria,
    );
  }

  String get authorName {
    return ownerUsername.isNotEmpty ? ownerUsername : 'Unknown Author';
  }

  String get stageLabel => stageToString(stage);

  String get visibilityLabel => visibilityToString(visibility);

  bool get isPublic => visibility == IdeaVisibility.public;

  bool get isProtected => visibility == IdeaVisibility.protected;

  bool get isPrivate => visibility == IdeaVisibility.private;

  bool isOwnedBy(String? userId) => userId != null && userId == ownerId;

  bool get belongsToCommunity =>
      communityId != null && communityId!.trim().isNotEmpty;

  bool get belongsToOrganisation =>
      organisationId != null && organisationId!.trim().isNotEmpty;

  String get shortDescription {
    if (description.length <= 140) {
      return description;
    }
    return '${description.substring(0, 137)}...';
  }

  @override
  String toString() {
    return 'Idea(id: $id, title: $title, visibility: $visibility, stage: $stage)';
  }
}
