import 'package:flutter/foundation.dart';
import '../../../core/services/error_handler.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';

class CommentController extends ChangeNotifier {
  final CommentService _commentService = CommentService();

  // State properties
  final Map<String, List<Comment>> _ideaComments =
      {}; // ideaId -> list of comments
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Pagination state per idea
  final Map<String, int> _currentPageMap = {}; // ideaId -> page number
  final int itemsPerPage = 20;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  /// Get comments for a specific idea
  List<Comment> getComments(String ideaId) => _ideaComments[ideaId] ?? [];

  /// Get comment count for a specific idea
  int getCommentCount(String ideaId) => getComments(ideaId).length;

  /// Get current page for a specific idea
  int getCurrentPage(String ideaId) => _currentPageMap[ideaId] ?? 1;

  // ============================================================
  // Load Comments Methods
  // ============================================================

  /// Load comments for an idea
  /// Called when viewing idea details to display discussion
  Future<void> loadComments(
    String ideaId, {
    int page = 1,
    bool silent = false,
  }) async {
    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      _error = null;
    }

    try {
      final comments = await _commentService.getIdeaComments(
        ideaId,
        page: page,
        limit: itemsPerPage,
      );

      if (page == 1) {
        // First page, replace all in chronological order (oldest -> newest).
        _ideaComments[ideaId] = _mergeAndSortComments(const [], comments);
      } else {
        // Additional pages are merged and de-duplicated.
        final existing = _ideaComments[ideaId] ?? const <Comment>[];
        _ideaComments[ideaId] = _mergeAndSortComments(existing, comments);
      }

      _currentPageMap[ideaId] = page;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      if (page == 1) {
        _ideaComments[ideaId] = [];
      }
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      if (page == 1) {
        _ideaComments[ideaId] = [];
      }
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  /// Refresh comments for an idea (pull-to-refresh)
  Future<void> refreshComments(String ideaId) async {
    _currentPageMap[ideaId] = 1;
    await loadComments(ideaId, page: 1);
  }

  /// Silent refresh used by realtime sync to avoid loading-state flicker.
  Future<void> syncComments(String ideaId) async {
    await loadComments(ideaId, page: 1, silent: true);
  }

  /// Load next page of comments
  Future<void> loadMoreComments(String ideaId) async {
    if (_isLoading) return;
    final nextPage = getCurrentPage(ideaId) + 1;
    await loadComments(ideaId, page: nextPage);
  }

  // ============================================================
  // Create Comment Methods
  // ============================================================

  /// Post a comment on an idea
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> createComment({
    required String ideaId,
    required String text,
  }) async {
    // Validate text
    if (text.isEmpty || text.trim().isEmpty) {
      _error = 'Comment text cannot be empty';
      notifyListeners();
      return false;
    }

    if (text.length > 500) {
      _error = 'Comment text cannot exceed 500 characters';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final comment = await _commentService.createComment(
        ideaId: ideaId,
        text: text.trim(),
      );

      final existing = _ideaComments[ideaId] ?? const <Comment>[];
      _ideaComments[ideaId] = _mergeAndSortComments(existing, [comment]);

      _successMessage = 'Comment posted!';
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

  /// Upsert a comment from realtime events.
  void upsertCommentRealtime(String ideaId, Comment comment) {
    final existing = _ideaComments[ideaId] ?? const <Comment>[];
    _ideaComments[ideaId] = _mergeAndSortComments(existing, [comment]);
    notifyListeners();
  }

  /// Remove a comment from realtime delete events.
  void removeCommentRealtime(String ideaId, String commentId) {
    final comments = _ideaComments[ideaId];
    if (comments == null) {
      return;
    }

    comments.removeWhere((comment) => comment.id == commentId);
    notifyListeners();
  }

  // ============================================================
  // Delete Comment Methods
  // ============================================================

  /// Delete a comment
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> deleteComment({
    required String ideaId,
    required String commentId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _commentService.deleteComment(ideaId: ideaId, commentId: commentId);

      // Remove from comments list
      if (_ideaComments[ideaId] != null) {
        _ideaComments[ideaId]!.removeWhere((c) => c.id == commentId);
      }

      _successMessage = 'Comment deleted';
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

  /// Refresh all loaded idea comments
  /// Useful if switching between ideas or after receiving updates
  Future<void> refreshAllComments() async {
    final ideaIds = _ideaComments.keys.toList();
    for (final ideaId in ideaIds) {
      await refreshComments(ideaId);
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

  /// Clear all cached comments for a specific idea
  void clearIdea(String ideaId) {
    _ideaComments.remove(ideaId);
    _currentPageMap.remove(ideaId);
    notifyListeners();
  }

  /// Clear all cached data
  void clearCache() {
    _ideaComments.clear();
    _currentPageMap.clear();
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  List<Comment> _mergeAndSortComments(
    List<Comment> existing,
    List<Comment> incoming,
  ) {
    final byId = <String, Comment>{};
    for (final comment in [...existing, ...incoming]) {
      byId[_commentIdentity(comment)] = comment;
    }

    final merged = byId.values.toList()
      ..sort((a, b) {
        final dateComparison = a.createdAt.compareTo(b.createdAt);
        if (dateComparison != 0) {
          return dateComparison;
        }

        return a.id.compareTo(b.id);
      });

    return merged;
  }

  String _commentIdentity(Comment comment) {
    if (comment.id.isNotEmpty) {
      return comment.id;
    }

    return '${comment.userId}_${comment.createdAt.microsecondsSinceEpoch}_${comment.content.hashCode}';
  }
}
