/// Rating model - stores user's evaluation scores for each criterion
class Rating {
  final String id;
  final String ideaId;
  final String reviewerId;
  final Map<String, int> scores;  // criteriaId -> score (1-10)
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.ideaId,
    required this.reviewerId,
    required this.scores,
    required this.createdAt,
  });

  /// Get average score across all criteria
  double getAverageScore() {
    if (scores.isEmpty) return 0.0;
    return scores.values.reduce((a, b) => a + b) / scores.length;
  }

  /// Get score for a specific criterion
  int? getScoreForCriteria(String criteriaId) => scores[criteriaId];

  /// Create Rating from JSON response from backend API
  factory Rating.fromJson(Map<String, dynamic> json) {
    // Parse scores map - handle potential type variations
    final scoresJson = json['scores'] as Map<String, dynamic>? ?? {};
    final scores = <String, int>{};
    scoresJson.forEach((key, value) {
      scores[key] = (value as num).toInt();
    });

    return Rating(
      id: json['id'] ?? '',
      ideaId: json['ideaId'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      scores: scores,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert Rating to JSON for sending to backend API
  Map<String, dynamic> toJson() => {
    'id': id,
    'ideaId': ideaId,
    'reviewerId': reviewerId,
    'scores': scores,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => 'Rating(ideaId: $ideaId, scores: $scores, average: ${getAverageScore().toStringAsFixed(1)})';
}

/// Aggregated rating statistics for an idea
class RatingStats {
  final String ideaId;
  final int totalRatings;
  final Map<String, double> averageScores;  // criteriaId -> average score
  final double averageOverall;

  RatingStats({
    required this.ideaId,
    required this.totalRatings,
    required this.averageScores,
    required this.averageOverall,
  });

  /// Get average score for a specific criterion
  double getAverageForCriteria(String criteriaId) => averageScores[criteriaId] ?? 0.0;

  /// Create RatingStats from JSON response
  factory RatingStats.fromJson(Map<String, dynamic> json) {
    final averageScoresJson = json['averageScores'] as Map<String, dynamic>? ?? {};
    final averageScores = <String, double>{};
    averageScoresJson.forEach((key, value) {
      averageScores[key] = (value as num).toDouble();
    });

    return RatingStats(
      ideaId: json['ideaId'] ?? '',
      totalRatings: json['totalRatings'] ?? 0,
      averageScores: averageScores,
      averageOverall: (json['averageOverall'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Get overall average rating
  double getOverallAverage() => averageOverall;

  /// Get rating count
  int getRatingCount() => totalRatings;

  @override
  String toString() => 'RatingStats(ideaId: $ideaId, overall: $averageOverall)';
}
