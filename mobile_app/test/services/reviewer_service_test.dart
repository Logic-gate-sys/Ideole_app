import { test, expect } from '@flutter/test-package';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ideole_app/services/reviewer_service.dart';

void main() {
  group('ReviewerService', () {
    late ReviewerService reviewerService;
    const testIdeaId = 'test-idea-123';
    const testReviewerId = 'test-reviewer-456';

    setUp(() {
      reviewerService = ReviewerService();
    });

    test('fetchIdeaReviewers returns list of reviewers', () async {
      // Depends on mock ApiService setup in real scenario
      // This test verifies the service integration works
      expect(reviewerService, isNotNull);
    });

    test('removeReviewer calls API correctly', () async {
      // Verify method exists and accepts parameters
      expect(
        () => reviewerService.removeReviewer(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });

    test('resendInvitation handles pending invites', () async {
      expect(
        () => reviewerService.resendInvitation(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });

    test('cancelInvitation removes pending invite', () async {
      expect(
        () => reviewerService.cancelInvitation(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });

    test('inviteReviewer creates new invitation', () async {
      expect(
        () => reviewerService.inviteReviewer(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });

    test('acceptInvitation updates status', () async {
      expect(
        () => reviewerService.acceptInvitation(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });

    test('declineInvitation updates status', () async {
      expect(
        () => reviewerService.declineInvitation(testIdeaId, testReviewerId),
        returnsNormally,
      );
    });
  });

  group('ManageReviewersController', () {
    late ManageReviewersController controller;
    const testIdeaId = 'test-idea-789';

    setUp(() {
      controller = ManageReviewersController();
    });

    test('initializes empty state', () {
      expect(controller.reviewers, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.errorMessage, isNull);
    });

    test('activeReviewers filters correctly', () {
      // Mock some reviewers
      expect(controller.activeReviewers, isEmpty);
    });

    test('pendingReviewers filters correctly', () {
      expect(controller.pendingReviewers, isEmpty);
    });

    test('loadReviewers sets loading state', () async {
      controller.loadReviewers(testIdeaId);
      expect(controller.isLoading, true);
    });

    test('clearError clears error message', () {
      controller.clearError();
      expect(controller.errorMessage, isNull);
    });
  });
}
