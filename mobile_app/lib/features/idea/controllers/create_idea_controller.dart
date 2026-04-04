import 'package:flutter/foundation.dart';
import '../../../services/idea_service.dart';

/// CreateIdeaController - Manages state for creating new ideas
class CreateIdeaController extends ChangeNotifier {
  final IdeaService _ideaService = IdeaService();

  // State
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
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
      await _ideaService.createIdea(
        title: title,
        description: description,
        visibility: visibility,
        communityId: communityId,
        organizationId: organizationId,
      );

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
}
