import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../controllers/idea_controller.dart';
import 'idea_detail_screen.dart';

class IdeasListScreen extends StatefulWidget {
  const IdeasListScreen({super.key});

  @override
  State<IdeasListScreen> createState() => _IdeasListScreenState();
}

class _IdeasListScreenState extends State<IdeasListScreen> {
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
    return Consumer<IdeaController>(
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
    );
  }

  Widget _buildEmptyView(BuildContext context, IdeaController controller) {
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
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshVisibleIdeas(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: controller.visibleIdeas.length + (controller.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.visibleIdeas.length) {
            final idea = controller.visibleIdeas[index];
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
                    Text(
                      idea.title,
                      style: AppTextStyles.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      idea.problemText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By ${idea.authorName}',
                          style: AppTextStyles.labelSmall,
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
}
