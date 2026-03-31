import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/idea_card.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/idea_controller.dart';
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
    return Consumer<IdeaController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.userIdeas.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.error != null && controller.userIdeas.isEmpty) {
          return ErrorStateWidget(
            message: controller.error ?? 'Failed to load your ideas',
            onRetry: () => controller.refreshUserIdeas(),
          );
        }

        if (controller.userIdeas.isEmpty) {
          return EmptyState(
            icon: Icons.lightbulb_outline,
            title: 'No ideas yet',
            description: 'Start sharing your ideas with the community!',
            action: CustomButton(
              label: 'Create Your First Idea',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateIdeaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          );
        }

        return _buildIdeasList(context, controller);
      },
    );
  }

  Widget _buildIdeasList(BuildContext context, IdeaController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshUserIdeas(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: controller.userIdeas.length + 1,
        itemBuilder: (context, index) {
          if (index < controller.userIdeas.length) {
            final idea = controller.userIdeas[index];
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
                onPressed: () => controller.loadMoreUserIdeas(),
                width: double.infinity,
              ),
            );
          }
        },
      ),
    );
  }
}
