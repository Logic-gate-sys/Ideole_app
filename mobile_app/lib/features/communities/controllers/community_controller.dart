import 'package:flutter/foundation.dart';
import '../../../services/community_service.dart';
import '../../../models/community.dart';

/// CommunityController - Manages community state
class CommunityController extends ChangeNotifier {
  final CommunityService _communityService = CommunityService();

  // State
  List<Community> _communities = [];
  Community? _currentCommunity;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentOffset = 0;
  String? _errorMessage;
  String? _selectedOrgId; // For filtering by organisation

  // Getters
  List<Community> get communities => _communities;
  Community? get currentCommunity => _currentCommunity;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  int get communityCount => _communities.length;

  /// Load initial communities
  Future<void> loadCommunities({
    String? organizationId,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentOffset = 0;
      _hasMore = true;
    } else {
      _isLoading = true;
    }

    _errorMessage = null;
    _selectedOrgId = organizationId;
    notifyListeners();

    try {
      final communities = await _communityService.getCommunities(
        organizationId: organizationId,
        limit: CommunityService.pageSize,
        offset: 0,
      );

      _communities = communities;
      _hasMore = communities.length == CommunityService.pageSize;
      _currentOffset = communities.length;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more communities (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final moreCommunities = await _communityService.getCommunities(
        organizationId: _selectedOrgId,
        limit: CommunityService.pageSize,
        offset: _currentOffset,
      );

      if (moreCommunities.isEmpty) {
        _hasMore = false;
      } else {
        _communities.addAll(moreCommunities);
        _currentOffset += moreCommunities.length;
        _hasMore = moreCommunities.length == CommunityService.pageSize;
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Get single community details
  Future<void> loadCommunityDetail(String communityId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final community = await _communityService.getCommunity(communityId);
      _currentCommunity = community;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Request to join community
  Future<bool> requestToJoin(String communityId) async {
    try {
      final success = await _communityService.requestToJoin(communityId);

      if (success && _currentCommunity != null) {
        _currentCommunity = _currentCommunity!.copyWith(
          hasPendingRequest: true,
        );
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Leave community
  Future<bool> leaveCommunity(String communityId, String membershipId) async {
    try {
      final success =
          await _communityService.leaveCommunity(communityId, membershipId);

      if (success && _currentCommunity != null) {
        _currentCommunity = _currentCommunity!.copyWith(
          isMember: false,
          memberCount: (_currentCommunity!.memberCount - 1).clamp(0, double.infinity).toInt(),
        );
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh communities list
  Future<void> refreshCommunities() async {
    await loadCommunities(organizationId: _selectedOrgId, refresh: true);
  }
}
