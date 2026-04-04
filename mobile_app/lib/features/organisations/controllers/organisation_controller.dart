import 'package:flutter/material.dart';
import '../services/organisation_service.dart';
import '../../../shared/models/organisation_model.dart';

class OrganisationController extends ChangeNotifier {
  final OrganisationService _service = OrganisationService();

  // State management
  List<Organisation> organisations = [];
  Organisation? selectedOrganisation;
  bool isLoading = false;
  String? error;

  // Create organisation
  Future<Organisation?> createOrganisation({
    required String name,
    required String tier,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final org = await _service.createOrganisation(
        name: name,
        tier: tier,
      );
      organisations.add(org);
      notifyListeners();
      return org;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get specific organisation
  Future<Organisation?> getOrganisation(String organisationId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final org = await _service.getOrganisation(organisationId);
      selectedOrganisation = org;
      notifyListeners();
      return org;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // List all organisations
  Future<List<Organisation>> listOrganisations() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      organisations = await _service.listOrganisations();
      notifyListeners();
      return organisations;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Update organisation
  Future<Organisation?> updateOrganisation({
    required String organisationId,
    required String name,
    required String tier,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updatedOrg = await _service.updateOrganisation(
        organisationId: organisationId,
        name: name,
        tier: tier,
      );

      // Update in list
      final index = organisations.indexWhere((o) => o.id == organisationId);
      if (index != -1) {
        organisations[index] = updatedOrg;
      }

      if (selectedOrganisation?.id == organisationId) {
        selectedOrganisation = updatedOrg;
      }

      notifyListeners();
      return updatedOrg;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete organisation
  Future<bool> deleteOrganisation(String organisationId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.deleteOrganisation(organisationId);
      organisations.removeWhere((o) => o.id == organisationId);

      if (selectedOrganisation?.id == organisationId) {
        selectedOrganisation = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    error = null;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    selectedOrganisation = null;
    notifyListeners();
  }
}
