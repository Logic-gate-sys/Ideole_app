enum IdeaVisibility {
  private,
  community,
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
      order: json['order'] ?? 0,
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
  final String problemText;
  final String solutionText;
  final String category;
  final IdeaVisibility visibility;
  final bool isPublic;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<EvaluationCriteria> criteria;  // custom evaluation criteria

  Idea({
    required this.id,
    required this.title,
    required this.problemText,
    required this.solutionText,
    required this.category,
    required this.visibility,
    required this.isPublic,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    this.criteria = const [],
  });

  /// Create Idea from JSON response from backend API
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      problemText: json['problemText'] ?? '',
      solutionText: json['solutionText'] ?? '',
      category: json['category'] ?? '',
      visibility: visibilityFromString(json['visibility'] ?? 'PRIVATE'),
      isPublic: json['isPublic'] ?? false,
      creatorId: json['creatorId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      criteria: json['criteria'] != null
          ? (json['criteria'] as List).map((c) => EvaluationCriteria.fromJson(c as Map<String, dynamic>)).toList()
          : [],
    );
  }

  /// Convert Idea to JSON for sending to backend API
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'problemText': problemText,
    'solutionText': solutionText,
    'category': category,
    'visibility': visibilityToString(visibility),
    'isPublic': isPublic,
    'creatorId': creatorId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'criteria': criteria.map((c) => c.toJson()).toList(),
  };

  /// Return a copy of this Idea with specific fields replaced
  Idea copyWith({
    String? id,
    String? title,
    String? problemText,
    String? solutionText,
    String? category,
    IdeaVisibility? visibility,
    bool? isPublic,
    String? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<EvaluationCriteria>? criteria,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      problemText: problemText ?? this.problemText,
      solutionText: solutionText ?? this.solutionText,
      category: category ?? this.category,
      visibility: visibility ?? this.visibility,
      isPublic: isPublic ?? this.isPublic,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      criteria: criteria ?? this.criteria,
    );
  }

  /// Get author name from creatorId (placeholder)
  String get authorName {
    // This should ideally come from user lookup, for now use a placeholder
    return creatorId.isNotEmpty ? 'Author' : 'Unknown Author';
  }

  @override
  String toString() =>
      'Idea(id: $id, title: $title, category: $category, visibility: $visibility)';
}
