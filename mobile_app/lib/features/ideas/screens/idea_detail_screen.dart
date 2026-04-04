import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';
import '../../ratings/controllers/rating_controller.dart';
import '../../comments/controllers/comment_controller.dart';
import '../../comments/screens/comments_section.dart';

class IdeaDetailScreen extends StatefulWidget {
  final String ideaId;

  const IdeaDetailScreen({
    super.key,
    required this.ideaId,
  });

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load idea details
      context.read<IdeaController>().loadIdeaDetails(widget.ideaId);

      // Load ratings and comments
      context.read<RatingController>().loadIdeaRatingData(widget.ideaId);
      context.read<CommentController>().loadComments(widget.ideaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Idea Details',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Handle share
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Consumer<IdeaController>(
        builder: (context, ideaController, _) {
          if (ideaController.isLoading && ideaController.selectedIdea == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ideaController.error != null && ideaController.selectedIdea == null) {
            return _buildErrorView(context, ideaController);
          }

          final idea = ideaController.selectedIdea;
          if (idea == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 64,
                    color: AppColors.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Idea not found',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildDetailView(context, idea);
        },
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, Idea idea) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Visibility badges
          Row(
            children: [
              AppBadge(
                label: idea.category,
                variant: AppBadgeVariant.tonal,
              ),
              const SizedBox(width: 8),
              AppBadge(
                label: idea.visibility == IdeaVisibility.public
                    ? 'Public'
                    : 'Private',
                variant: AppBadgeVariant.outlined,
                prefix: Icon(
                  idea.visibility == IdeaVisibility.public
                      ? Icons.public
                      : Icons.lock_outline,
                  size: 12,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(idea.createdAt),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            idea.title,
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 32,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Author info
          _buildAuthorInfo(idea),
          const SizedBox(height: 32),

          // Problem section
          _buildSection(
            context,
            title: 'Problem',
            content: idea.problemText,
            icon: Icons.warning_outlined,
            accentColor: AppColors.warning,
          ),
          const SizedBox(height: 24),

          // Solution section
          _buildSection(
            context,
            title: 'Solution',
            content: idea.solutionText,
            icon: Icons.lightbulb_outlined,
            accentColor: AppColors.primary,
          ),
          const SizedBox(height: 32),

          // Evaluation section
          _buildEvaluationSection(context, idea.id),
          const SizedBox(height: 32),

          // Discussion section
          _buildDiscussionSection(context, idea.id),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(Idea idea) {
    return Row(
      children: [
        AppAvatar(
          initials: idea.authorName.isEmpty
              ? '?'
              : idea.authorName[0].toUpperCase(),
          size: 40,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                idea.authorName,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Posted ${_formatDate(idea.createdAt)}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          backgroundColor: AppColors.surfaceContainerLowest,
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationSection(BuildContext context, String ideaId) {
    return Consumer<RatingController>(
      builder: (context, ratingController, _) {
        final stats = ratingController.getRatingStats(ideaId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Evaluation',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            if (stats != null) ...[
              _buildRatingStatsCard(stats),
              const SizedBox(height: 16),
            ] else
              AppCard(
                backgroundColor: AppColors.surfaceContainerLowest,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No evaluations yet. Be the first to rate!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            AppButton(
              label: 'Rate This Idea',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              isFullWidth: true,
              icon: Icons.star_outline,
              onPressed: () => _showRatingDialog(context, ideaId),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingStatsCard(dynamic stats) {
    return AppCard(
      backgroundColor: AppColors.primaryContainer.withOpacity(0.3),
      padding: const EdgeInsets.all(16),
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
                    'Average Rating',
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.getAverageRating().toStringAsFixed(1)}/10',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Text(
                '${stats.getRatingCount()} ratings',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMetricRow(
            'Originality',
            stats.averageOriginality,
            AppColors.primary,
          ),
          const SizedBox(height: 8),
          _buildMetricRow(
            'Feasibility',
            stats.averageFeasibility,
            AppColors.secondary,
          ),
          const SizedBox(height: 8),
          _buildMetricRow(
            'Impact',
            stats.averageImpact,
            AppColors.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
        Row(
          children: [
            SizedBox(
              width: 80,
              child: AppLinearProgress(
                value: value / 10,
                height: 4,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(1)}/10',
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscussionSection(BuildContext context, String ideaId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discussion',
          style: AppTextStyles.headlineSmall.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        CommentsSection(ideaId: ideaId),
      ],
    );
  }

  void _showRatingDialog(BuildContext context, String ideaId) {
    double originality = 5;
    double feasibility = 5;
    double impact = 5;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rate This Idea',
                            style: AppTextStyles.headlineSmall,
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pop(dialogContext),
                            child: Icon(
                              Icons.close,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Originality slider
                      AppSlider(
                        value: originality,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: 'Originality',
                        onChanged: (value) {
                          setState(() => originality = value);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Feasibility slider
                      AppSlider(
                        value: feasibility,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: 'Feasibility',
                        onChanged: (value) {
                          setState(() => feasibility = value);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Impact slider
                      AppSlider(
                        value: impact,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: 'Impact',
                        onChanged: (value) {
                          setState(() => impact = value);
                        },
                      ),
                      const SizedBox(height: 32),

                      // Actions
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.text,
                            size: AppButtonSize.medium,
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                          ),
                          const SizedBox(width: 12),
                          AppButton(
                            label: 'Submit',
                            variant:
                                AppButtonVariant.filled,
                            size: AppButtonSize.medium,
                            onPressed: () {
                              context
                                  .read<
                                      RatingController>()
                                  .rateIdea(
                                    ideaId: ideaId,
                                    originality:
                                        originality
                                            .toInt(),
                                    feasibility:
                                        feasibility
                                            .toInt(),
                                    impact: impact
                                        .toInt(),
                                  );
                              Navigator.pop(
                                  dialogContext);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, IdeaController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            controller.error ?? 'Error loading idea',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Go Back',
            variant: AppButtonVariant.filled,
            size: AppButtonSize.medium,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
