import 'package:flutter/foundation.dart';
import '../../../models/organisation.dart';
import '../../../services/organisation_service.dart';

/// Organisation Controller - Manages organisation state and data
class OrganisationController extends ChangeNotifier {
  final OrganisationService _organisationService = OrganisationService();

  // State
  List<Organisation> _organisations = [];
  Organisation? _selectedOrganisation;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentOffset = 0;
  static const int _pageSize = 10;

  // Getters
  List<Organisation> get organisations => _organisations;
  Organisation? get selectedOrganisation => _selectedOrganisation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => true; // TODO: Implement hasMore check

  /// Load organisations
  Future<void> loadOrganisations({bool refresh = false}) async {
    if (refresh) {
      _currentOffset = 0;
      _organisations.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orgs = await _organisationService.getOrganisations(
        offset: _currentOffset,
        limit: _pageSize,
      );
      
      if (refresh) {
        _organisations = orgs;
      } else {
        _organisations.addAll(orgs);
      }

      _currentOffset += _pageSize;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load organisations: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get organisation by ID
  Future<void> getOrganisationById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrganisation = await _organisationService.getOrganisation(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load organisation: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create organisation
  Future<bool> createOrganisation({
    required String name,
    required String description,
    required String visibility, // PUBLIC, PROTECTED, PRIVATE
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final org = await _organisationService.createOrganisation(
        name: name,
        description: description,
        visibility: visibility,
      );

      _organisations.insert(0, org);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create organisation: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set selected organisation
  void setSelectedOrganisation(Organisation org) {
    _selectedOrganisation = org;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Load more organisations
  Future<void> loadMore() async {
    if (!hasMore || _isLoading) return;
    await loadOrganisations();
  }
}
