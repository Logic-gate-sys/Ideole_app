import 'package:flutter/foundation.dart';
import '../../services/reviewer_service.dart';

/// Reviewer model for managing idea reviewers
class ReviewerItem {
  final String id;
  final String name;
  final String role;
  final String expertise;
  final String? avatarUrl;
  final ReviewerStatus status;
  final DateTime? joinedDate;
  final DateTime? invitedDate;

  ReviewerItem({
    required this.id,
    required this.name,
    required this.role,
    required this.expertise,
    this.avatarUrl,
    required this.status,
    this.joinedDate,
    this.invitedDate,
  });

  /// Create from ReviewerService Reviewer model
  factory ReviewerItem.fromReviewer(Reviewer reviewer) {
    final status = reviewer.status == 'joined'
        ? ReviewerStatus.joined
        : reviewer.status == 'pending'
            ? ReviewerStatus.pending
            : ReviewerStatus.declined;

    return ReviewerItem(
      id: reviewer.id,
      name: reviewer.name,
      role: reviewer.role,
      expertise: reviewer.expertise,
      avatarUrl: reviewer.avatarUrl,
      status: status,
      joinedDate: reviewer.joinedDate,
      invitedDate: reviewer.invitedDate,
    );
  }
}

enum ReviewerStatus {
  joined,    // Active reviewer
  pending,   // Invitation pending
  declined,  // Declined invitation
}

/// Manage Reviewers Controller - Handle reviewer invites and management
class ManageReviewersController extends ChangeNotifier {
  // State
  List<ReviewerItem> _reviewers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentIdeaId;
  
  // Services
  late ReviewerService _reviewerService;

  // Getters
  List<ReviewerItem> get reviewers => _reviewers;
  List<ReviewerItem> get activeReviewers =>
      _reviewers.where((r) => r.status == ReviewerStatus.joined).toList();
  List<ReviewerItem> get pendingReviewers =>
      _reviewers.where((r) => r.status == ReviewerStatus.pending).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ManageReviewersController() {
    _reviewerService = ReviewerService();
  }

  /// Load reviewers from API for a specific idea
  Future<void> loadReviewers(String ideaId) async {
    _currentIdeaId = ideaId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reviewers = await _reviewerService.fetchIdeaReviewers(ideaId);
      _reviewers = reviewers
          .map((r) => ReviewerItem.fromReviewer(r))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove reviewer
  Future<bool> removeReviewer(String reviewerId) async {
    if (_currentIdeaId == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _reviewerService.removeReviewer(_currentIdeaId!, reviewerId);
      
      _reviewers.removeWhere((r) => r.id == reviewerId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove reviewer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resend invitation to pending reviewer
  Future<bool> resendInvitation(String reviewerId) async {
    if (_currentIdeaId == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _reviewerService.resendInvitation(_currentIdeaId!, reviewerId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to resend invitation: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cancel invitation
  Future<bool> cancelInvitation(String reviewerId) async {
    if (_currentIdeaId == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _reviewerService.cancelInvitation(_currentIdeaId!, reviewerId);
      
      _reviewers.removeWhere((r) => r.id == reviewerId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel invitation: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
