import 'package:flutter/material.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../models/idea.dart';

/// Idea Card - Reusable component to display an idea in a list
class IdeaCard extends StatelessWidget {
  final Idea idea;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const IdeaCard({
    Key? key,
    required this.idea,
    this.onTap,
    this.onMorePressed,
  }) : super(key: key);
  Color _getVisibilityColor() {
    switch (idea.visibility) {
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

  /// Get color for stage badge
  Color _getStageColor() {
    switch (idea.stage) {
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

  /// Format date to readable format
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + More Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          idea.title,
                          style: SaharaTypography.titleLarge.copyWith(
                            color: SaharaColors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Creator info
                        Text(
                          idea.ownerName ?? 'Anonymous',
                          style: SaharaTypography.bodySmall.copyWith(
                            color: SaharaColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More button
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: onMorePressed,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                idea.description,
                style: SaharaTypography.bodyMedium.copyWith(
                  color: SaharaColors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Badges Row: Visibility, Stage, Date
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Visibility Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getVisibilityColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      idea.visibility,
                      style: SaharaTypography.labelSmall.copyWith(
                        color: _getVisibilityColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Stage Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStageColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      idea.stage,
                      style: SaharaTypography.labelSmall.copyWith(
                        color: _getStageColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Date
                  Text(
                    _formatDate(idea.createdAt),
                    style: SaharaTypography.bodySmall.copyWith(
                      color: SaharaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // Metrics Row: Ratings, Comments
              if (idea.ratingCount > 0 || idea.averageRating != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      // Rating
                      if (idea.averageRating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${idea.averageRating?.toStringAsFixed(1)} '
                              '(${idea.ratingCount})',
                              style: SaharaTypography.bodySmall.copyWith(
                                color: SaharaColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
