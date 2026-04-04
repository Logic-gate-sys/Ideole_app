import 'package:flutter/material.dart';
import '../services/community_service.dart';
import '../../../shared/models/community_model.dart';

class CommunityController extends ChangeNotifier {
  final CommunityService _service = CommunityService();

  // State management
  Map<String, List<Community>> communitiesByOrg = {}; // organisationId -> communities
  Community? selectedCommunity;
  bool isLoading = false;
  String? error;

  // Create community
  Future<Community?> createCommunity({
    required String organisationId,
    required String name,
    String? description,
    required String visibility,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final community = await _service.createCommunity(
        organisationId: organisationId,
        name: name,
        description: description,
        visibility: visibility,
      );

      // Add to the map
      if (!communitiesByOrg.containsKey(organisationId)) {
        communitiesByOrg[organisationId] = [];
      }
      communitiesByOrg[organisationId]!.add(community);
      notifyListeners();
      return community;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get specific community
  Future<Community?> getCommunity({
    required String organisationId,
    required String communityId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final community = await _service.getCommunity(
        organisationId: organisationId,
        communityId: communityId,
      );
      selectedCommunity = community;
      notifyListeners();
      return community;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // List communities for an organisation
  Future<List<Community>> listCommunities(String organisationId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final communities = await _service.listCommunities(organisationId);
      communitiesByOrg[organisationId] = communities;
      notifyListeners();
      return communities;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Update community
  Future<Community?> updateCommunity({
    required String organisationId,
    required String communityId,
    required String name,
    String? description,
    required String visibility,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updatedCommunity = await _service.updateCommunity(
        organisationId: organisationId,
        communityId: communityId,
        name: name,
        description: description,
        visibility: visibility,
      );

      // Update in map
      if (communitiesByOrg.containsKey(organisationId)) {
        final index = communitiesByOrg[organisationId]!
            .indexWhere((c) => c.id == communityId);
        if (index != -1) {
          communitiesByOrg[organisationId]![index] = updatedCommunity;
        }
      }

      if (selectedCommunity?.id == communityId) {
        selectedCommunity = updatedCommunity;
      }

      notifyListeners();
      return updatedCommunity;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete community
  Future<bool> deleteCommunity({
    required String organisationId,
    required String communityId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _service.deleteCommunity(
        organisationId: organisationId,
        communityId: communityId,
      );

      if (communitiesByOrg.containsKey(organisationId)) {
        communitiesByOrg[organisationId]!
            .removeWhere((c) => c.id == communityId);
      }

      if (selectedCommunity?.id == communityId) {
        selectedCommunity = null;
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

  // Get communities for organisation
  List<Community> getCommunitiesForOrg(String organisationId) {
    return communitiesByOrg[organisationId] ?? [];
  }

  // Clear error
  void clearError() {
    error = null;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    selectedCommunity = null;
    notifyListeners();
  }
}
