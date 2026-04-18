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

      if (page == 1) {
        _visibleIdeas = ideas;
      } else {
        _visibleIdeas = [..._visibleIdeas, ...ideas];
      }

      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      if (page == 1) {
        _visibleIdeas = [];
      }
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      if (page == 1) {
        _visibleIdeas = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshVisibleIdeas() async {
    _currentPage = 1;
    await loadVisibleIdeas(page: 1);
  }

  Future<void> loadMoreVisibleIdeas() async {
    if (_isLoading) return;
    await loadVisibleIdeas(page: _currentPage + 1);
  }

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

      if (page == 1) {
        _userIdeas = ideas;
      } else {
        _userIdeas = [..._userIdeas, ...ideas];
      }

      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      if (page == 1) {
        _userIdeas = [];
      }
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      if (page == 1) {
        _userIdeas = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserIdeas() async {
    _currentPage = 1;
    await loadUserIdeas(page: 1);
  }

  Future<void> loadMoreUserIdeas() async {
    if (_isLoading) return;
    await loadUserIdeas(page: _currentPage + 1);
  }

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

  void clearSelectedIdea() {
    _selectedIdea = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> createIdea({
    required String title,
    required String description,
    required IdeaVisibility visibility,
    String? communityId,
    String? organisationId,
    List<IdeaCriteriaInput> criteria = const [],
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final newIdea = await _ideaService.createIdea(
        title: title,
        description: description,
        visibility: visibility,
        communityId: communityId,
        organisationId: organisationId,
        criteria: criteria,
      );

      _userIdeas.insert(0, newIdea);

      if (newIdea.isPublic || newIdea.isProtected) {
        _visibleIdeas.insert(0, newIdea);
      }

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

  Future<bool> updateIdea(
    String ideaId, {
    String? title,
    String? description,
    IdeaVisibility? visibility,
    IdeaStage? stage,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedIdea = await _ideaService.updateIdea(
        ideaId,
        title: title,
        description: description,
        visibility: visibility,
        stage: stage,
      );

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

  Future<bool> deleteIdea(String ideaId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ideaService.deleteIdea(ideaId);

      _visibleIdeas = _visibleIdeas.where((idea) => idea.id != ideaId).toList();
      _userIdeas = _userIdeas.where((idea) => idea.id != ideaId).toList();
      if (_selectedIdea?.id == ideaId) {
        _selectedIdea = null;
      }

      _successMessage = 'Idea deleted successfully!';
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

  Future<bool> refreshSelectedIdeaCriteria() async {
    final current = _selectedIdea;
    if (current == null) {
      _error = 'No selected idea found.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final criteria = await _ideaService.getIdeaCriteria(current.id);
      _selectedIdea = current.copyWith(criteria: criteria);
      _successMessage = null;
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCriteria({
    required String ideaId,
    required String name,
    required String description,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ideaService.createIdeaCriteria(
        ideaId: ideaId,
        name: name,
        description: description,
      );

      await loadIdeaDetails(ideaId);

      _successMessage = 'Criteria created successfully!';
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCriteria({
    required String ideaId,
    required String criteriaId,
    String? name,
    String? description,
    int? order,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ideaService.updateIdeaCriteria(
        ideaId: ideaId,
        criteriaId: criteriaId,
        name: name,
        description: description,
        order: order,
      );

      await loadIdeaDetails(ideaId);

      _successMessage = 'Criteria updated successfully!';
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCriteria({
    required String ideaId,
    required String criteriaId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ideaService.deleteIdeaCriteria(
        ideaId: ideaId,
        criteriaId: criteriaId,
      );

      await loadIdeaDetails(ideaId);

      _successMessage = 'Criteria deleted successfully!';
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> reorderCriteria({
    required String ideaId,
    required String criteriaId,
    required bool moveUp,
  }) async {
    final current = _selectedIdea;
    if (current == null || current.id != ideaId) {
      _error = 'No selected idea found for reordering.';
      notifyListeners();
      return false;
    }

    final ordered = [...current.criteria]..sort((a, b) => a.order.compareTo(b.order));
    final currentIndex = ordered.indexWhere((criterion) => criterion.id == criteriaId);

    if (currentIndex == -1) {
      _error = 'Criteria not found.';
      notifyListeners();
      return false;
    }

    final swapIndex = moveUp ? currentIndex - 1 : currentIndex + 1;
    if (swapIndex < 0 || swapIndex >= ordered.length) {
      return true;
    }

    final source = ordered[currentIndex];
    final target = ordered[swapIndex];

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _ideaService.updateIdeaCriteria(
        ideaId: ideaId,
        criteriaId: source.id,
        order: target.order,
      );
      await _ideaService.updateIdeaCriteria(
        ideaId: ideaId,
        criteriaId: target.id,
        order: source.order,
      );

      await loadIdeaDetails(ideaId);
      _successMessage = 'Criteria order updated.';
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
