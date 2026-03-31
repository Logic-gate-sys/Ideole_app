import 'package:flutter/foundation.dart';
import '../../../core/services/error_handler.dart';
import '../models/rating.dart';
import '../services/rating_service.dart';

class RatingController extends ChangeNotifier {
  final RatingService _ratingService = RatingService();

  // State properties
  final Map<String, RatingStats> _ideaRatingsStats = {}; // ideaId -> stats
  final Map<String, List<Rating>> _ideaRatings = {}; // ideaId -> list of ratings
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  /// Get rating stats for a specific idea
  RatingStats? getRatingStats(String ideaId) => _ideaRatingsStats[ideaId];

  /// Get ratings for a specific idea
  List<Rating> getRatings(String ideaId) => _ideaRatings[ideaId] ?? [];

  /// Check if user has already rated this idea
  bool hasRatedIdea(String ideaId) => (_ideaRatings[ideaId] ?? []).isNotEmpty;

  // ============================================================
  // Rating Stats Methods
  // ============================================================

  /// Load rating statistics for an idea
  /// Called when displaying idea details to show rating summary
  Future<void> loadRatingStats(String ideaId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final stats = await _ratingService.getIdeaRatingStats(ideaId);
      _ideaRatingsStats[ideaId] = stats;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Ratings List Methods
  // ============================================================

  /// Load all ratings for an idea
  /// Called when user wants to see individual ratings
  Future<void> loadRatings(String ideaId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final ratings = await _ratingService.getIdeaRatings(ideaId);
      _ideaRatings[ideaId] = ratings;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _ideaRatings[ideaId] = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _ideaRatings[ideaId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Rating Creation Methods
  // ============================================================

  /// Rate an idea with three separate dimensions
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> rateIdea({
    required String ideaId,
    required int originality,  // 1-10
    required int feasibility,  // 1-10
    required int impact,       // 1-10
  }) async {
    // Validate scores
    if (originality < 1 || originality > 10 ||
        feasibility < 1 || feasibility > 10 ||
        impact < 1 || impact > 10) {
      _error = 'Rating scores must be between 1 and 10';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final rating = await _ratingService.rateIdea(
        ideaId: ideaId,
        originality: originality,
        feasibility: feasibility,
        impact: impact,
      );

      // Add to ratings list
      if (_ideaRatings[ideaId] == null) {
        _ideaRatings[ideaId] = [rating];
      } else {
        _ideaRatings[ideaId]!.insert(0, rating);
      }

      // Refresh stats
      await loadRatingStats(ideaId);

      _successMessage = 'Your rating has been recorded!';
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // Bulk Load Methods
  // ============================================================

  /// Load both stats and ratings for an idea
  /// More efficient than calling both separately
  Future<void> loadIdeaRatingData(String ideaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load in parallel
      final statsResult = await _ratingService.getIdeaRatingStats(ideaId);
      final ratingsResult = await _ratingService.getIdeaRatings(ideaId);

      _ideaRatingsStats[ideaId] = statsResult;
      _ideaRatings[ideaId] = ratingsResult;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Error Handling Methods
  // ============================================================

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear success message
  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  /// Clear all messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Clear all cached data
  void clearCache() {
    _ideaRatingsStats.clear();
    _ideaRatings.clear();
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
