import 'package:flutter/foundation.dart';
import '../../../core/services/error_handler.dart';
import '../models/membership_model.dart';
import '../services/membership_service.dart';

class MembershipController extends ChangeNotifier {
  final MembershipService _membershipService = MembershipService();

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  List<Membership> _myMemberships = [];
  final Map<String, List<Membership>> _communityMembers = {};
  final Map<String, List<Membership>> _pendingRequests = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  List<Membership> get myMemberships => _myMemberships;

  List<Membership> getMembersForCommunity(String communityId) {
    return _communityMembers[communityId] ?? [];
  }

  List<Membership> getPendingRequestsForCommunity(String communityId) {
    return _pendingRequests[communityId] ?? [];
  }

  Membership? getMyMembershipForCommunity(String communityId) {
    try {
      return _myMemberships.firstWhere((m) => m.communityId == communityId);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadMyMemberships() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myMemberships = await _membershipService.getMyMemberships();
    } on ApiException catch (e) {
      _error = e.message;
      _myMemberships = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _myMemberships = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCommunityMembers(String communityId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final members = await _membershipService.getCommunityMembers(communityId);
      _communityMembers[communityId] = members;
    } on ApiException catch (e) {
      _error = e.message;
      _communityMembers[communityId] = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _communityMembers[communityId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingRequests(String communityId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final requests =
          await _membershipService.getPendingMembershipRequests(communityId);
      _pendingRequests[communityId] = requests;
    } on ApiException catch (e) {
      _error = e.message;
      _pendingRequests[communityId] = [];
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _pendingRequests[communityId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestToJoinCommunity(String communityId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final membership =
          await _membershipService.requestToJoinCommunity(communityId);
      _myMemberships.removeWhere((m) => m.communityId == communityId);
      _myMemberships.add(membership);
      _successMessage = 'Join request submitted.';
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

  Future<bool> approveRequest({
    required String communityId,
    required String membershipId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final approved = await _membershipService.approveMembershipRequest(
        communityId: communityId,
        membershipId: membershipId,
      );

      _pendingRequests[communityId] = (getPendingRequestsForCommunity(communityId)
            ..removeWhere((item) => item.id == membershipId))
          .toList();

      final currentMembers = getMembersForCommunity(communityId).toList();
      currentMembers.add(approved);
      _communityMembers[communityId] = currentMembers;

      _successMessage = 'Membership approved.';
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

  Future<bool> rejectRequest({
    required String communityId,
    required String membershipId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _membershipService.rejectMembershipRequest(
        communityId: communityId,
        membershipId: membershipId,
      );

      _pendingRequests[communityId] = getPendingRequestsForCommunity(communityId)
          .where((item) => item.id != membershipId)
          .toList();

      _successMessage = 'Membership rejected.';
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

  Future<bool> removeMembership({
    required String communityId,
    required String membershipId,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _membershipService.removeMembership(
        communityId: communityId,
        membershipId: membershipId,
      );

      _myMemberships = _myMemberships.where((m) => m.id != membershipId).toList();
      _communityMembers[communityId] = getMembersForCommunity(communityId)
          .where((m) => m.id != membershipId)
          .toList();

      _successMessage = 'Membership removed.';
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

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
