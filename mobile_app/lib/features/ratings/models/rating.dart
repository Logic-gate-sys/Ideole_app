enum RatingType {
  originality,
  feasibility,
  impact,
}

RatingType ratingTypeFromString(String value) {
  return RatingType.values.firstWhere(
    (r) => r.toString().split('.').last.toLowerCase() == value.toLowerCase(),
    orElse: () => RatingType.originality,
  );
}

String ratingTypeToString(RatingType type) {
  return type.toString().split('.').last;
}

class Rating {
  final String id;
  final String ideaId;
  final String reviewerId;
  final int originality;   // 1-10
  final int feasibility;   // 1-10
  final int impact;        // 1-10
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.ideaId,
    required this.reviewerId,
    required this.originality,
    required this.feasibility,
    required this.impact,
    required this.createdAt,
  });

  /// Calculate average score across all dimensions
  double getAverageScore() {
    return (originality + feasibility + impact) / 3.0;
  }

  /// Create Rating from JSON response from backend API
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? '',
      ideaId: json['ideaId'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      originality: json['originality'] ?? 5,
      feasibility: json['feasibility'] ?? 5,
      impact: json['impact'] ?? 5,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert Rating to JSON for sending to backend API
  Map<String, dynamic> toJson() => {
    'id': id,
    'ideaId': ideaId,
    'reviewerId': reviewerId,
    'originality': originality,
    'feasibility': feasibility,
    'impact': impact,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => 'Rating(ideaId: $ideaId, originality: $originality, feasibility: $feasibility, impact: $impact)';
}

class RatingStats {
  final String ideaId;
  final int totalRatings;
  final double averageOriginality;
  final double averageFeasibility;
  final double averageImpact;
  final double averageOverall;

  RatingStats({
    required this.ideaId,
    required this.totalRatings,
    required this.averageOriginality,
    required this.averageFeasibility,
    required this.averageImpact,
    required this.averageOverall,
  });

  /// Create RatingStats from JSON response
  factory RatingStats.fromJson(Map<String, dynamic> json) {
    return RatingStats(
      ideaId: json['ideaId'] ?? '',
      totalRatings: json['totalRatings'] ?? 0,
      averageOriginality: (json['averageOriginality'] as num?)?.toDouble() ?? 0.0,
      averageFeasibility: (json['averageFeasibility'] as num?)?.toDouble() ?? 0.0,
      averageImpact: (json['averageImpact'] as num?)?.toDouble() ?? 0.0,
      averageOverall: (json['averageOverall'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Get average rating across all dimensions
  double getOverallAverage() {
    return averageOverall;
  }

  /// Get rating count
  int getRatingCount() {
    return totalRatings;
  }

  @override
  String toString() => 'RatingStats(ideaId: $ideaId, overall: $averageOverall)';
}
