import 'package:flutter/foundation.dart';
import '../../../core/services/error_handler.dart';
import '../models/idea.dart';
import '../services/idea_service.dart';

class IdeaController extends ChangeNotifier {
  final IdeaService _ideaService = IdeaService();

  // State properties
  List<Idea> _visibleIdeas = [];
  List<Idea> _userIdeas = [];
  Idea? _selectedIdea;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Pagination
  int _currentPage = 1;
  final int itemsPerPage = 10;

  // Getters
  List<Idea> get visibleIdeas => _visibleIdeas;
  List<Idea> get userIdeas => _userIdeas;
  Idea? get selectedIdea => _selectedIdea;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get currentPage => _currentPage;

  // ============================================================
  // Visible Ideas Methods
  // ============================================================

  /// Load visible ideas (public and community)
  /// Called on app startup and when user navigates to explore tab
  Future<void> loadVisibleIdeas({int page = 1}) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    _currentPage = page;
    notifyListeners();

    try {
      final ideas = await _ideaService.getVisibleIdeas(
        page: page,
        limit: itemsPerPage,
      );
      _visibleIdeas = ideas;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _visibleIdeas = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _visibleIdeas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh visible ideas (pull-to-refresh)
  Future<void> refreshVisibleIdeas() async {
    _currentPage = 1;
    await loadVisibleIdeas(page: 1);
  }

  /// Load next page of visible ideas
  Future<void> loadMoreVisibleIdeas() async {
    if (_isLoading) return;
    await loadVisibleIdeas(page: _currentPage + 1);
  }

  // ============================================================
  // User Ideas Methods
  // ============================================================

  /// Load current user's own ideas
  /// Requires authentication
  Future<void> loadUserIdeas({int page = 1}) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    _currentPage = page;
    notifyListeners();

    try {
      final ideas = await _ideaService.getUserIdeas(
        page: page,
        limit: itemsPerPage,
      );
      _userIdeas = ideas;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _userIdeas = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _userIdeas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user ideas (pull-to-refresh)
  Future<void> refreshUserIdeas() async {
    _currentPage = 1;
    await loadUserIdeas(page: 1);
  }

  /// Load next page of user ideas
  Future<void> loadMoreUserIdeas() async {
    if (_isLoading) return;
    await loadUserIdeas(page: _currentPage + 1);
  }

  // ============================================================
  // Idea Details Methods
  // ============================================================

  /// Load and display a specific idea
  /// Called when user taps on an idea in the list
  Future<void> loadIdeaDetails(String ideaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final idea = await _ideaService.getIdeaById(ideaId);
      _selectedIdea = idea;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _selectedIdea = null;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _selectedIdea = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear currently selected idea
  void clearSelectedIdea() {
    _selectedIdea = null;
    _error = null;
    notifyListeners();
  }

  // ============================================================
  // Create Idea Methods
  // ============================================================

  /// Create a new idea
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> createIdea({
    required String title,
    required String problemText,
    required String solutionText,
    required String category,
    required IdeaVisibility visibility,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final newIdea = await _ideaService.createIdea(
        title: title,
        problemText: problemText,
        solutionText: solutionText,
        category: category,
        visibility: visibility,
      );

      // Add to user ideas list
      _userIdeas.insert(0, newIdea);
      _successMessage = 'Idea created successfully!';
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
  // Update Idea Methods
  // ============================================================

  /// Update an existing idea
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> updateIdea(
    String ideaId, {
    String? title,
    String? problemText,
    String? solutionText,
    String? category,
    IdeaVisibility? visibility,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedIdea = await _ideaService.updateIdea(
        ideaId,
        title: title,
        problemText: problemText,
        solutionText: solutionText,
        category: category,
        visibility: visibility,
      );

      // Update in both lists if present
      final visibleIndex = _visibleIdeas.indexWhere((i) => i.id == ideaId);
      if (visibleIndex >= 0) {
        _visibleIdeas[visibleIndex] = updatedIdea;
      }

      final userIndex = _userIdeas.indexWhere((i) => i.id == ideaId);
      if (userIndex >= 0) {
        _userIdeas[userIndex] = updatedIdea;
      }

      if (_selectedIdea?.id == ideaId) {
        _selectedIdea = updatedIdea;
      }

      _successMessage = 'Idea updated successfully!';
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
  // Visibility Toggle Methods
  // ============================================================

  /// Toggle idea's public visibility
  /// Shows success/error messages
  /// Returns true if successful, false otherwise
  Future<bool> toggleVisibility(String ideaId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedIdea = await _ideaService.toggleIdeaVisibility(ideaId);

      // Update in both lists if present
      final visibleIndex = _visibleIdeas.indexWhere((i) => i.id == ideaId);
      if (visibleIndex >= 0) {
        _visibleIdeas[visibleIndex] = updatedIdea;
      }

      final userIndex = _userIdeas.indexWhere((i) => i.id == ideaId);
      if (userIndex >= 0) {
        _userIdeas[userIndex] = updatedIdea;
      }

      if (_selectedIdea?.id == ideaId) {
        _selectedIdea = updatedIdea;
      }

      _successMessage = 'Visibility updated successfully!';
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
}
