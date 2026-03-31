import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/idea_card.dart';
import '../../../core/theme/app_colors.dart';
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
          return ErrorStateWidget(
            message: controller.error ?? 'Failed to load ideas',
            onRetry: () => controller.refreshVisibleIdeas(),
          );
        }

        if (controller.visibleIdeas.isEmpty) {
          return EmptyState(
            icon: Icons.lightbulb_outline,
            title: 'No ideas yet',
            description: 'Explore and discover amazing ideas from the community!',
            action: CustomButton(
              label: 'Refresh',
              onPressed: () => controller.refreshVisibleIdeas(),
            ),
          );
        }

        return _buildIdeasList(context, controller);
      },
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshVisibleIdeas(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: controller.visibleIdeas.length + 1,
        itemBuilder: (context, index) {
          if (index < controller.visibleIdeas.length) {
            final idea = controller.visibleIdeas[index];
            return IdeaCard(
              idea: idea,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => IdeaDetailScreen(ideaId: idea.id),
                  ),
                );
              },
            );
          } else {
            if (controller.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: CustomButton(
                label: 'Load More Ideas',
                onPressed: () => controller.loadMoreVisibleIdeas(),
                width: double.infinity,
              ),
            );
          }
        },
      ),
    );
  }
}
