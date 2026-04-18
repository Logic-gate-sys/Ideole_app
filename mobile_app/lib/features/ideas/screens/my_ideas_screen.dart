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
    );
  }

  Widget _buildEmptyView(BuildContext context) {
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
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshUserIdeas(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: controller.userIdeas.length + (controller.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.userIdeas.length) {
            final idea = controller.userIdeas[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AppCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => IdeaDetailScreen(ideaId: idea.id),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            idea.title,
                            style: AppTextStyles.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppBadge(
                          label: visibilityToString(idea.visibility),
                          variant: AppBadgeVariant.tonal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      idea.shortDescription,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created ${_formatDate(idea.createdAt)}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
        },
      ),
    );
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
