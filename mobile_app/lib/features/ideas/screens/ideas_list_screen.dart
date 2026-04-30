import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';
import 'idea_detail_screen.dart';

class IdeasListScreen extends StatefulWidget {
  const IdeasListScreen({super.key});

  @override
  State<IdeasListScreen> createState() => _IdeasListScreenState();
}

class _IdeasListScreenState extends State<IdeasListScreen> {
  static const EdgeInsets _listPadding = EdgeInsets.fromLTRB(16, 8, 16, 28);

  late IdeaController _ideaController;

  @override
  void initState() {
    super.initState();
    _ideaController = context.read<IdeaController>();
    // Load visible ideas on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ideaController.loadVisibleIdeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Consumer<IdeaController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.visibleIdeas.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.error != null && controller.visibleIdeas.isEmpty) {
            return _buildErrorView(context, controller);
          }

          if (controller.visibleIdeas.isEmpty) {
            return _buildEmptyView(context, controller);
          }

          return _buildIdeasList(context, controller);
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, IdeaController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
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
              controller.error ?? 'Failed to load ideas',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Retry',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              onPressed: () => controller.refreshVisibleIdeas(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, IdeaController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
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
              'No ideas yet',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore and discover amazing ideas from the community!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Refresh',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              onPressed: () => controller.refreshVisibleIdeas(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    final ideas = controller.visibleIdeas;
    final hasLoader = controller.isLoading;

    return RefreshIndicator(
      onRefresh: () => controller.refreshVisibleIdeas(),
      edgeOffset: 8,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: _listPadding,
        itemCount: 1 + ideas.length + (hasLoader ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFeedHeader(ideaCount: ideas.length);
          }

          final ideaIndex = index - 1;
          if (ideaIndex < ideas.length) {
            return _buildIdeaCard(context, ideas[ideaIndex]);
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedHeader({required int ideaCount}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer.withValues(alpha: 0.75),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.dynamic_feed,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Feed',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Fresh ideas from people building in public.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppBadge(
            label: _formatIdeaCount(ideaCount),
            variant: AppBadgeVariant.outlined,
            prefix: Icon(
              Icons.lightbulb_outline,
              size: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaCard(BuildContext context, Idea idea) {
    return AppCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => IdeaDetailScreen(ideaId: idea.id),
          ),
        );
      },
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(
                label: stageToString(idea.stage),
                variant: AppBadgeVariant.tonal,
                prefix: Icon(
                  Icons.timeline,
                  size: 12,
                  color: AppColors.onTertiaryContainer,
                ),
              ),
              AppBadge(
                label: visibilityToString(idea.visibility),
                variant: AppBadgeVariant.outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            idea.title,
            style: AppTextStyles.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            idea.shortDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'By ${idea.authorName}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildMetaPill(
                icon: Icons.chat_bubble_outline,
                value: idea.commentCount,
              ),
              const SizedBox(width: 8),
              _buildMetaPill(
                icon: Icons.star_border,
                value: idea.ratingCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaPill({required IconData icon, required int value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatIdeaCount(int count) {
    if (count == 1) {
      return '1 idea';
    }
    return '$count ideas';
  }
}
