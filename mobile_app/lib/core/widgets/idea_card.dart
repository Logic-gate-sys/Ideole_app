import 'package:flutter/material.dart';
import '../../features/ideas/models/idea.dart';
import '../theme/app_colors.dart';
import 'app_widgets.dart';

class IdeaCard extends StatefulWidget {
  final Idea idea;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final bool isLiked;

  const IdeaCard({
    super.key,
    required this.idea,
    this.onTap,
    this.onLike,
    this.isLiked = false,
  });

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _animationController.forward();
  }

  void _onTapUp() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradientForCategory(widget.idea.category);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.mediumList,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Stack(
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(gradient: gradient),
                  ),
                  // Content
                  Container(
                    color: AppColors.surface.withOpacity(0.95),
                    child: Column(
                      children: [
                        // Header with gradient accent
                        Container(
                          decoration: BoxDecoration(gradient: gradient),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                      ),
                                      child: Text(
                                        widget.idea.category,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Shared by you',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.white.withOpacity(0.8),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // Like button
                              GestureDetector(
                                onTap: widget.onLike,
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Icon(
                                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Body content
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.idea.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              // Problem snippet
                              Text(
                                'Problem: ${widget.idea.problemText}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              // Visibility badge
                              Row(
                                children: [
                                  Icon(
                                    widget.idea.visibility == IdeaVisibility.public
                                        ? Icons.public
                                        : widget.idea.visibility == IdeaVisibility.community
                                            ? Icons.group
                                            : Icons.lock,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    widget.idea.visibility.toString().split('.').last.toUpperCase(),
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.textSecondary,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return AppGradients.blueGradient;
      case 'business':
        return AppGradients.purpleGradient;
      case 'health':
        return AppGradients.secondaryGradient;
      case 'education':
        return AppGradients.tertiaryGradient;
      default:
        return AppGradients.primaryGradient;
    }
  }
}
