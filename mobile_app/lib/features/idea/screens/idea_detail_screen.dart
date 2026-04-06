import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../models/idea.dart';
import '../../../shared/widgets/sahara_buttons.dart';
import '../controllers/idea_detail_controller.dart';

/// Idea Detail Screen - Displays full idea details, ratings, and comments
class IdeaDetailScreen extends StatefulWidget {
  final String ideaId;
  final Idea? cachedIdea; // Pass idea from list to avoid duplicate fetch

  const IdeaDetailScreen({
    super.key,
    required this.ideaId,
    this.cachedIdea,
  });

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();

    // Load idea details if not cached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IdeaDetailController>().loadIdeaDetail(widget.ideaId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(IdeaDetailController controller) {
    if (_commentController.text.trim().isEmpty) return;

    controller.addComment(_commentController.text.trim());
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<IdeaDetailController>(
        builder: (context, controller, _) {
          final idea = controller.currentIdea;

          if (controller.isLoading && idea == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage != null && idea == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load idea',
                    style: SaharaTypography.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      controller.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: SaharaTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Try Again',
                    onPressed: () {
                      controller.loadIdeaDetail(widget.ideaId);
                    },
                  ),
                ],
              ),
            );
          }

          if (idea == null) {
            return const Center(
              child: Text('Idea not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  idea.title,
                  style: SaharaTypography.displaySmall.copyWith(
                    color: SaharaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // Author & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      idea.ownerName ?? 'Anonymous',
                      style: SaharaTypography.bodyMedium.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatDate(idea.createdAt),
                      style: SaharaTypography.bodySmall.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildBadge(idea.visibility, _getVisibilityColor(idea.visibility)),
                    _buildBadge(idea.stage, _getStageColor(idea.stage)),
                  ],
                ),
                const SizedBox(height: 24),

                // Divider
                Divider(
                  color: SaharaColors.outline,
                  height: 32,
                ),

                // Description
                Text(
                  'Description',
                  style: SaharaTypography.bodyLarge.copyWith(
                    color: SaharaColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  idea.description,
                  style: SaharaTypography.bodyMedium.copyWith(
                    color: SaharaColors.onSurface,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Metrics
                if (idea.ratingCount > 0 || idea.averageRating != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ratings',
                        style: SaharaTypography.bodyLarge.copyWith(
                          color: SaharaColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${idea.averageRating?.toStringAsFixed(1) ?? 'N/A'} '
                            '(${idea.ratingCount} ratings)',
                            style: SaharaTypography.bodyLarge.copyWith(
                              color: SaharaColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),

                // Comments Section
                Text(
                  'Comments (${controller.comments.length})',
                  style: SaharaTypography.bodyLarge.copyWith(
                    color: SaharaColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Comment input
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SaharaColors.surfaceContainer,
                    border: Border.all(color: SaharaColors.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: SaharaTypography.bodyMedium.copyWith(
                            color: SaharaColors.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 3,
                        minLines: 1,
                        style: SaharaTypography.bodyMedium.copyWith(
                          color: SaharaColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: PrimaryButton(
                          label: 'Comment',
                          isLoading: controller.isCommentingLoading,
                          onPressed: () => _submitComment(controller),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Comments list
                ...controller.comments
                    .map((comment) => _buildComment(comment))
                    ,

                if (controller.comments.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No comments yet. Be the first!',
                        style: SaharaTypography.bodyMedium.copyWith(
                          color: SaharaColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build comment widget
  Widget _buildComment(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SaharaColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment['authorName'] ?? 'Anonymous',
                style: SaharaTypography.bodySmall.copyWith(
                  color: SaharaColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatDate(DateTime.parse(comment['createdAt'] as String)),
                style: SaharaTypography.bodySmall.copyWith(
                  color: SaharaColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment['content'] as String,
            style: SaharaTypography.bodySmall.copyWith(
              color: SaharaColors.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build badge
  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: SaharaTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Get color for visibility
  Color _getVisibilityColor(String visibility) {
    switch (visibility) {
      case 'PUBLIC':
        return Colors.green;
      case 'PROTECTED':
        return Colors.amber;
      case 'PRIVATE':
        return Colors.red;
      default:
        return SaharaColors.primary;
    }
  }

  /// Get color for stage
  Color _getStageColor(String stage) {
    switch (stage) {
      case 'INCEPTION':
        return Colors.blue;
      case 'COLLABORATIVE':
        return Colors.purple;
      case 'IMPLEMENTATION':
        return Colors.teal;
      default:
        return SaharaColors.primary;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
