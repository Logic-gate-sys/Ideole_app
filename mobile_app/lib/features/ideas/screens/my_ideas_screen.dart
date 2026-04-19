import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';
import 'idea_detail_screen.dart';
import 'create_idea_screen.dart';

class MyIdeasScreen extends StatefulWidget {
  const MyIdeasScreen({super.key});

  @override
  State<MyIdeasScreen> createState() => _MyIdeasScreenState();
}

class _MyIdeasScreenState extends State<MyIdeasScreen> {
  static const EdgeInsets _listPadding = EdgeInsets.fromLTRB(16, 10, 16, 28);

  late IdeaController _ideaController;

  @override
  void initState() {
    super.initState();
    _ideaController = context.read<IdeaController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ideaController.loadUserIdeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'My Ideas',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateIdeaScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<IdeaController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.userIdeas.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.error != null && controller.userIdeas.isEmpty) {
            return _buildErrorView(context, controller);
          }

          if (controller.userIdeas.isEmpty) {
            return _buildEmptyView(context);
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
              controller.error ?? 'Failed to load your ideas',
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
              onPressed: () => controller.refreshUserIdeas(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
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
              'Start sharing your ideas with the community!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Create Your First Idea',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              icon: Icons.add,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateIdeaScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    final ideas = controller.userIdeas;
    final hasLoader = controller.isLoading;

    return RefreshIndicator(
      onRefresh: () => controller.refreshUserIdeas(),
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
            return _buildMyIdeasHeader(ideaCount: ideas.length);
          }

          final ideaIndex = index - 1;
          if (ideaIndex < ideas.length) {
            return _buildMyIdeaCard(context, ideas[ideaIndex]);
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

  Widget _buildMyIdeasHeader({required int ideaCount}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryContainer.withValues(alpha: 0.65),
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
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.lightbulb,
              size: 22,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Ideas',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Track progress and keep building your concepts.',
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
            textColor: AppColors.secondary,
            borderColor: AppColors.secondary,
            prefix: Icon(
              Icons.inventory_2_outlined,
              size: 12,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyIdeaCard(BuildContext context, Idea idea) {
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
          const SizedBox(height: 10),
          Text(
            'Updated ${_formatDate(idea.updatedAt)} • Created ${_formatDate(idea.createdAt)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'today';
    if (difference.inDays == 1) return 'yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
