import 'package:flutter/material.dart';
import '../../../core/widgets/index.dart';

/// Single idea card for feed display
class IdeaCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String? authorImage;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final double originality; // 0-100
  final double feasibility; // 0-100
  final double impact; // 0-100
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const IdeaCard({super.key, 
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorImage,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.originality = 75,
    this.feasibility = 80,
    this.impact = 85,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      backgroundColor: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          _buildAuthorRow(),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 18,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Metrics row (Originality, Feasibility, Impact with meter)
          _buildMetricsRow(),
          const SizedBox(height: 16),

          // Action buttons (Like, Comment, Share)
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      children: [
        AppAvatar(
          initials: authorName.isEmpty ? '?' : authorName[0].toUpperCase(),
          image: authorImage,
          size: 36,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Just now',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            const PopupMenuItem(
              child: Text('Save'),
            ),
            const PopupMenuItem(
              child: Text('Report'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Meter
        SizedBox(
          width: 100,
          height: 100,
          child: AppMeter(
            originality: originality,
            feasibility: feasibility,
            impact: impact,
            size: 100,
          ),
        ),
        // Metric labels
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetricLabel('Originality', originality, AppColors.primary),
              const SizedBox(height: 8),
              _buildMetricLabel(
                'Feasibility',
                feasibility,
                AppColors.secondary,
              ),
              const SizedBox(height: 8),
              _buildMetricLabel('Impact', impact, AppColors.tertiary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricLabel(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${value.toStringAsFixed(0)}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Like button
        _buildActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: likeCount.toString(),
          color: isLiked ? AppColors.error : AppColors.onSurfaceVariant,
          onTap: onLike,
        ),
        // Comment button
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: commentCount.toString(),
          onTap: onComment,
        ),
        // Share button
        _buildActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    final displayColor = color ?? AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: displayColor,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: displayColor,
            ),
          ),
        ],
      ),
    );
  }
}
