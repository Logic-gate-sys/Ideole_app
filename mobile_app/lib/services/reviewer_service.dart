import 'api_service.dart';
import 'storage_service.dart';

/// Reviewer model for API responses
class Reviewer {
  final String id;
  final String name;
  final String email;
  final String role;
  final String expertise;
  final String? avatarUrl;
  final String status; // 'joined', 'pending', 'declined'
  final DateTime? joinedDate;
  final DateTime? invitedDate;

  Reviewer({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.expertise,
    this.avatarUrl,
    required this.status,
    this.joinedDate,
    this.invitedDate,
  });

  /// Create Reviewer from JSON API response
  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'Reviewer',
      expertise: json['expertise'] as String? ?? 'Expert',
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'] as String)
          : null,
      invitedDate: json['invitedDate'] != null
          ? DateTime.parse(json['invitedDate'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'expertise': expertise,
    'avatarUrl': avatarUrl,
    'status': status,
    'joinedDate': joinedDate?.toIso8601String(),
    'invitedDate': invitedDate?.toIso8601String(),
  };
}

/// Service for managing idea reviewers
class ReviewerService {
  static final ReviewerService _instance = ReviewerService._internal();

  factory ReviewerService() {
    return _instance;
  }

  ReviewerService._internal();

  /// Get all reviewers for an idea
  /// 
  /// Returns a list of Reviewer objects (both active and pending)
  /// Throws Exception if API call fails
  Future<List<Reviewer>> fetchIdeaReviewers(String ideaId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.get(
        '/ideas/$ideaId/reviewers',
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      final data = response['data'];
      if (data is! List) {
        throw Exception('Expected list of reviewers');
      }

      return data
          .map((json) => Reviewer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviewers: $e');
    }
  }

  /// Remove a reviewer from an idea
  /// 
  /// Throws Exception if user is not authorized or reviewer not found
  Future<void> removeReviewer(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.delete(
        '/ideas/$ideaId/reviewers/$reviewerId',
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to remove reviewer');
      }
    } catch (e) {
      throw Exception('Failed to remove reviewer: $e');
    }
  }

  /// Resend invitation to a pending reviewer
  /// 
  /// Throws Exception if invitation is not pending or user is not authorized
  Future<void> resendInvitation(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.post(
        '/ideas/$ideaId/reviewers/$reviewerId/resend-invite',
        body: {},
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to resend invitation');
      }
    } catch (e) {
      throw Exception('Failed to resend invitation: $e');
    }
  }

  /// Cancel a pending invitation
  /// 
  /// Throws Exception if invitation is not pending or user is not authorized
  Future<void> cancelInvitation(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.delete(
        '/ideas/$ideaId/reviewers/$reviewerId/invite',
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to cancel invitation');
      }
    } catch (e) {
      throw Exception('Failed to cancel invitation: $e');
    }
  }

  /// Invite a reviewer to an idea
  /// 
  /// Throws Exception if user is not authorized or reviewer not found
  Future<Reviewer> inviteReviewer(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.post(
        '/ideas/$ideaId/reviewers',
        body: {'reviewerId': reviewerId},
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to invite reviewer');
      }

      return Reviewer.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to invite reviewer: $e');
    }
  }

  /// Accept a reviewer invitation (user accepting their own invitation)
  /// 
  /// Throws Exception if invitation not found or user is not the reviewer
  Future<void> acceptInvitation(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.post(
        '/ideas/$ideaId/reviewers/$reviewerId/accept',
        body: {},
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to accept invitation');
      }
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  /// Decline a reviewer invitation (user declining their own invitation)
  /// 
  /// Throws Exception if invitation not found or user is not the reviewer
  Future<void> declineInvitation(String ideaId, String reviewerId) async {
    try {
      final token = StorageService().getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await ApiService.post(
        '/ideas/$ideaId/reviewers/$reviewerId/decline',
        body: {},
        token: token,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      if (response['success'] != true) {
        throw Exception(response['details'] ?? 'Failed to decline invitation');
      }
    } catch (e) {
      throw Exception('Failed to decline invitation: $e');
    }
  }
}
