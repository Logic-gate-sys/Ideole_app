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
    );
  }

  @override
  String toString() =>
      'Idea(id: $id, title: $title, category: $category, visibility: $visibility)';
}
