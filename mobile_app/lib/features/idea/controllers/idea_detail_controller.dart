import 'package:flutter/foundation.dart';
import '../../../services/idea_service.dart';
import '../../../models/idea.dart';

/// IdeaDetailController - Manages state for idea detail view
class IdeaDetailController extends ChangeNotifier {
  final IdeaService _ideaService = IdeaService();

  // State
  Idea? _currentIdea;
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = false;
  bool _isCommentingLoading = false;
  String? _errorMessage;

  // Getters
  Idea? get currentIdea => _currentIdea;
  List<Map<String, dynamic>> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get isCommentingLoading => _isCommentingLoading;
  String? get errorMessage => _errorMessage;

  /// Load idea details by ID
  Future<void> loadIdeaDetail(String ideaId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final idea = await _ideaService.getIdea(ideaId);
      _currentIdea = idea;
      
      // TODO: Load comments from backend when endpoint is available
      // For now, initialize with empty comments
      _comments = [];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add comment to idea
  Future<void> addComment(String content) async {
    _isCommentingLoading = true;
    notifyListeners();

    try {
      // TODO: Call backend API to save comment when endpoint is available
      // For now, just add to local list for demo purposes
      final newComment = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': content,
        'authorName': 'Current User', // Would come from AuthController
        'createdAt': DateTime.now().toIso8601String(),
      };

      _comments.insert(0, newComment);
      _isCommentingLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isCommentingLoading = false;
      notifyListeners();
    }
  }

  /// Rate idea
  Future<bool> rateIdea(double rating) async {
    if (_currentIdea == null) return false;

    try {
      // TODO: Call backend API to save rating when endpoint is available
      // For now, just update local state
      _currentIdea = _currentIdea!.copyWith(
        ratingCount: _currentIdea!.ratingCount + 1,
        averageRating: ((_currentIdea!.averageRating ?? 0) + rating) / 2,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
