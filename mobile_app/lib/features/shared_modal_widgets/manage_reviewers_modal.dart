import 'package:flutter/material.dart';
import '../../../shared/theme/sahara_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'manage_reviewers_controller.dart';

/// Manage Reviewers Modal - View and manage idea reviewers
class ManageReviewersModal extends StatefulWidget {
  final String ideaId;
  final String ideaTitle;
  final VoidCallback? onReviewersChanged;

  const ManageReviewersModal({
    Key? key,
    required this.ideaId,
    required this.ideaTitle,
    this.onReviewersChanged,
  }) : super(key: key);

  @override
  State<ManageReviewersModal> createState() => _ManageReviewersModalState();
}

class _ManageReviewersModalState extends State<ManageReviewersModal> {
  late ManageReviewersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ManageReviewersController();
    _controller.loadReviewers(widget.ideaId);
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
      widget.onReviewersChanged?.call();
    }
  }

  void _showRemoveConfirm(ReviewerItem reviewer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Reviewer?'),
        content: Text(
          'Remove ${reviewer.name} from this idea? They won\'t be able to access project details or submit reviews.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _controller.removeReviewer(reviewer.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${reviewer.name} has been removed'),
                    backgroundColor: SaharaColors.error,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Remove',
              style: TextStyle(color: SaharaColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manage Reviewers',
                              style: SaharaTypography.headlineSmall.copyWith(
                                color: SaharaColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.ideaTitle,
                              style: SaharaTypography.bodySmall.copyWith(
                                color: SaharaColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: SaharaColors.textMain,
                          ),
                        ),
                      ],
                    ),
                    // Stats bar
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: SaharaColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${_controller.activeReviewers.length} Active',
                            style: SaharaTypography.labelMedium.copyWith(
                              color: SaharaColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${_controller.pendingReviewers.length} Pending',
                            style: SaharaTypography.labelMedium.copyWith(
                              color: SaharaColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _controller.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: SaharaColors.primary,
                        ),
                      )
                    : _controller.errorMessage != null
                        ? _buildErrorState()
                        : _controller.reviewers.isEmpty
                            ? _buildEmptyState()
                            : _buildReviewersList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 48,
            color: SaharaColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reviewers Yet',
            style: SaharaTypography.titleMedium.copyWith(
              color: SaharaColors.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Invite reviewers to evaluate this idea and provide feedback on its originality, feasibility, and impact.',
              textAlign: TextAlign.center,
              style: SaharaTypography.bodySmall.copyWith(
                color: SaharaColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: SaharaColors.error,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _controller.errorMessage!,
              textAlign: TextAlign.center,
              style: SaharaTypography.bodySmall.copyWith(
                color: SaharaColors.error,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _controller.clearError,
            style: ElevatedButton.styleFrom(
              backgroundColor: SaharaColors.primary,
            ),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewersList(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Active Reviewers Section
        if (_controller.activeReviewers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Text(
              'Active Reviewers',
              style: SaharaTypography.labelLarge.copyWith(
                color: SaharaColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._controller.activeReviewers.map(
            (reviewer) => _buildReviewerCard(reviewer),
          ),
          const SizedBox(height: 24),
        ],

        // Pending Reviewers Section
        if (_controller.pendingReviewers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Text(
              'Pending Invitations',
              style: SaharaTypography.labelLarge.copyWith(
                color: SaharaColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._controller.pendingReviewers.map(
            (reviewer) => _buildReviewerCard(reviewer),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewerCard(ReviewerItem reviewer) {
    final isPending = reviewer.status == ReviewerStatus.pending;
    final statusColor =
        isPending ? SaharaColors.warning : SaharaColors.success;
    final statusText = isPending ? 'Pending' : 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: SaharaColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: SaharaColors.primaryLight,
                  backgroundImage: reviewer.avatarUrl != null
                      ? NetworkImage(reviewer.avatarUrl!)
                      : null,
                  child: reviewer.avatarUrl == null
                      ? Text(
                          reviewer.name.substring(0, 1).toUpperCase(),
                          style: SaharaTypography.titleLarge.copyWith(
                            color: SaharaColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewer.name,
                        style: SaharaTypography.bodyMedium.copyWith(
                          color: SaharaColors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reviewer.role,
                        style: SaharaTypography.bodySmall.copyWith(
                          color: SaharaColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: SaharaTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Expertise tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: SaharaColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reviewer.expertise,
                style: SaharaTypography.labelSmall.copyWith(
                  color: SaharaColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Timeline info
            Text(
              _buildTimelineText(reviewer),
              style: SaharaTypography.bodySmall.copyWith(
                color: SaharaColors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),
            // Action buttons
            Row(
              children: [
                if (isPending)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _controller.isLoading
                          ? null
                          : () =>
                              _controller.resendInvitation(reviewer.id),
                      icon: const Icon(Icons.mail_outline, size: 18),
                      label: const Text('Resend'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: SaharaColors.primary),
                      ),
                    ),
                  ),
                if (isPending) const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _controller.isLoading
                        ? null
                        : () => isPending
                            ? _controller.cancelInvitation(reviewer.id)
                            : _showRemoveConfirm(reviewer),
                    icon: Icon(
                      isPending ? Icons.close : Icons.person_remove_outlined,
                      size: 18,
                    ),
                    label: Text(isPending ? 'Cancel' : 'Remove'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isPending
                            ? SaharaColors.warning
                            : SaharaColors.error,
                      ),
                      foregroundColor:
                          isPending ? SaharaColors.warning : SaharaColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildTimelineText(ReviewerItem reviewer) {
    if (reviewer.status == ReviewerStatus.joined && reviewer.joinedDate != null) {
      final daysAgo = DateTime.now().difference(reviewer.joinedDate!).inDays;
      if (daysAgo == 0) {
        return 'Joined today';
      } else if (daysAgo == 1) {
        return 'Joined yesterday';
      } else {
        return 'Joined $daysAgo days ago';
      }
    } else if (reviewer.status == ReviewerStatus.pending &&
        reviewer.invitedDate != null) {
      final hoursAgo = DateTime.now().difference(reviewer.invitedDate!).inHours;
      if (hoursAgo < 24) {
        return 'Invited ${hoursAgo}h ago';
      } else {
        final daysAgo = (hoursAgo / 24).ceil();
        return 'Invited $daysAgo days ago';
      }
    }
    return 'Member of this project';
  }
}
