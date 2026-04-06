import 'package:flutter/foundation.dart';
import '../../../services/idea_service.dart';
import '../../../models/idea.dart';

/// Idea Controller - Manages idea state and pagination
class IdeaController extends ChangeNotifier {
  final IdeaService _ideaService = IdeaService();

  // State
  List<Idea> _ideas = [];
  final List<Idea> _filteredIdeas = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  int _currentOffset = 0;
  String? _errorMessage;
  String _filterMode = 'all'; // 'all' or 'myIdeas'

  // Getters
  List<Idea> get ideas => _filterMode == 'all' ? _ideas : _filteredIdeas;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String get filterMode => _filterMode;
  int get ideaCount => _ideas.length;

  /// Load initial ideas (refresh)
  Future<void> loadIdeas({bool refresh = false}) async {
    if (refresh) {
      _isRefreshing = true;
      _currentOffset = 0;
      _hasMore = true;
    } else {
      _isLoading = true;
    }
    
    _errorMessage = null;
    notifyListeners();

    try {
      final ideas = await _ideaService.getIdeas(
        limit: IdeaService.pageSize,
        offset: 0,
        filter: _filterMode == 'myIdeas' ? 'myIdeas' : null,
      );

      _ideas = ideas;
      
      // Determine if there are more items
      _hasMore = ideas.length == IdeaService.pageSize;
      _currentOffset = ideas.length;

      if (refresh) {
        _isRefreshing = false;
      } else {
        _isLoading = false;
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load more ideas (infinite scroll/pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final moreIdeas = await _ideaService.getIdeas(
        limit: IdeaService.pageSize,
        offset: _currentOffset,
        filter: _filterMode == 'myIdeas' ? 'myIdeas' : null,
      );

      if (moreIdeas.isEmpty) {
        _hasMore = false;
      } else {
        _ideas.addAll(moreIdeas);
        _currentOffset += moreIdeas.length;
        _hasMore = moreIdeas.length == IdeaService.pageSize;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Switch between all ideas and my ideas
  void setFilterMode(String mode) {
    if (_filterMode != mode) {
      _filterMode = mode;
      _currentOffset = 0;
      _hasMore = true;
      loadIdeas();
    }
  }

  /// Create new idea
  Future<bool> createIdea({
    required String title,
    required String description,
    required String visibility,
    String? communityId,
    String? organizationId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newIdea = await _ideaService.createIdea(
        title: title,
        description: description,
        visibility: visibility,
        communityId: communityId,
        organizationId: organizationId,
      );

      // Add to top of list
      _ideas.insert(0, newIdea);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get single idea details
  Future<Idea?> getIdea(String ideaId) async {
    try {
      return await _ideaService.getIdea(ideaId);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  /// Delete idea
  Future<bool> deleteIdea(String ideaId) async {
    try {
      await _ideaService.deleteIdea(ideaId);
      _ideas.removeWhere((idea) => idea.id == ideaId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
