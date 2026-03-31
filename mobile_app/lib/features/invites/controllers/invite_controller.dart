import 'package:flutter/foundation.dart';
import '../../../core/services/error_handler.dart';
import '../models/invite.dart';
import '../services/invite_service.dart';

class InviteController extends ChangeNotifier {
  final InviteService _inviteService = InviteService();

  // State properties
  List<Invite> _userInvites = []; // Invites received by current user
  List<Invite> _pendingInvites = []; // Pending invites only
  final Map<String, List<Invite>> _ideaInvites = {}; // ideaId -> invites sent for that idea
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Pagination for user invites
  int _currentPage = 1;
  final int itemsPerPage = 10;

  // Getters
  List<Invite> get userInvites => _userInvites;
  List<Invite> get pendingInvites => _pendingInvites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get currentPage => _currentPage;
  int get pendingInviteCount => _pendingInvites.length;

  /// Get invites for a specific idea
  List<Invite> getIdeaInvites(String ideaId) => _ideaInvites[ideaId] ?? [];

  /// Get count of pending invites for a specific idea
  int getPendingCountForIdea(String ideaId) {
    final invites = _ideaInvites[ideaId] ?? [];
    return invites.where((i) => i.status == InviteStatus.pending).length;
  }

  // ============================================================
  // User Invites Methods (Received by Current User)
  // ============================================================

  /// Load all invites received by current user
  /// Requires authentication
  Future<void> loadUserInvites({int page = 1}) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    _currentPage = page;
    notifyListeners();

    try {
      final invites = await _inviteService.getUserInvites();
      _userInvites = invites;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _userInvites = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _userInvites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user invites (pull-to-refresh)
  Future<void> refreshUserInvites() async {
    _currentPage = 1;
    await loadUserInvites(page: 1);
  }

  /// Load next page of user invites
  Future<void> loadMoreUserInvites() async {
    if (_isLoading) return;
    await loadUserInvites(page: _currentPage + 1);
  }

  // ============================================================
  // Pending Invites Methods
  // ============================================================

  /// Load only pending invites for current user
  /// Shows notifications/badge with pending count
  Future<void> loadPendingInvites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final invites = await _inviteService.getPendingInvites();
      _pendingInvites = invites;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _pendingInvites = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _pendingInvites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Idea Invites Methods (Sent by Idea Owner)
  // ============================================================

  /// Load all invites sent for a specific idea
  /// Called by idea owner to see who they invited
  Future<void> loadIdeaInvites(String ideaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final invites = await _inviteService.getIdeaInvites(ideaId);
      _ideaInvites[ideaId] = invites;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _ideaInvites[ideaId] = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _ideaInvites[ideaId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Send Invite Methods
  // ============================================================

  /// Send an invite to collaborate on an idea
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> sendInvite({
    required String ideaId,
    required String invitedUserId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final invite = await _inviteService.sendInvite(
        ideaId: ideaId,
        invitedUserId: invitedUserId,
      );

      // Add to idea invites list
      if (_ideaInvites[ideaId] == null) {
        _ideaInvites[ideaId] = [invite];
      } else {
        _ideaInvites[ideaId]!.insert(0, invite);
      }

      _successMessage = 'Invite sent successfully!';
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
  // Invite Response Methods
  // ============================================================

  /// Accept a collaboration invite
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> acceptInvite({
    required String ideaId,
    required String inviteId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedInvite = await _inviteService.acceptInvite(
        ideaId: ideaId,
        inviteId: inviteId,
      );

      // Update in both lists
      final pendingIndex = _pendingInvites.indexWhere((i) => i.id == inviteId);
      if (pendingIndex >= 0) {
        _pendingInvites[pendingIndex] = updatedInvite;
      }

      final userIndex = _userInvites.indexWhere((i) => i.id == inviteId);
      if (userIndex >= 0) {
        _userInvites[userIndex] = updatedInvite;
      }

      _successMessage = 'Invite accepted! You are now a collaborator.';
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

  /// Decline a collaboration invite
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> declineInvite({
    required String ideaId,
    required String inviteId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedInvite = await _inviteService.declineInvite(
        ideaId: ideaId,
        inviteId: inviteId,
      );

      // Update in both lists
      final pendingIndex = _pendingInvites.indexWhere((i) => i.id == inviteId);
      if (pendingIndex >= 0) {
        _pendingInvites[pendingIndex] = updatedInvite;
      }

      final userIndex = _userInvites.indexWhere((i) => i.id == inviteId);
      if (userIndex >= 0) {
        _userInvites[userIndex] = updatedInvite;
      }

      _successMessage = 'Invite declined.';
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
    _userInvites.clear();
    _pendingInvites.clear();
    _ideaInvites.clear();
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
