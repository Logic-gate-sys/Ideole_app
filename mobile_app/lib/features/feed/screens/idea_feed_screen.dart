import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../shared/widgets/idea_card.dart';
import '../controllers/idea_controller.dart';
import '../../idea/screens/create_idea_screen.dart';
import '../../idea/screens/idea_detail_screen.dart';
import '../../idea/controllers/create_idea_controller.dart';
import '../../idea/controllers/idea_detail_controller.dart';

/// Idea Feed Screen - Displays paginated list of ideas with infinite scroll
class IdeaFeedScreen extends StatefulWidget {
  const IdeaFeedScreen({super.key});

  @override
  State<IdeaFeedScreen> createState() => _IdeaFeedScreenState();
}

class _IdeaFeedScreenState extends State<IdeaFeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load ideas on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IdeaController>().loadIdeas();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll to load more ideas
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<IdeaController>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IdeaController>(
      builder: (context, controller, child) {
        // Empty state
        if (!controller.isLoading &&
            controller.ideas.isEmpty &&
            controller.errorMessage == null) {
          return _buildEmptyState(context);
        }

        // Error state
        if (controller.errorMessage != null && controller.ideas.isEmpty) {
          return _buildErrorState(context, controller);
        }

        // Loaded state with ideas
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => controller.loadIdeas(refresh: true),
            color: SaharaColors.primary,
            backgroundColor: SaharaColors.surface,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.ideas.length +
                  (controller.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at bottom if there are more items
                if (index == controller.ideas.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: SaharaColors.primary,
                      ),
                    ),
                  );
                }

                final idea = controller.ideas[index];
                return IdeaCard(
                  idea: idea,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<IdeaDetailController>(
                              create: (_) => IdeaDetailController(),
                            ),
                          ],
                          child: IdeaDetailScreen(ideaId: idea.id),
                        ),
                      ),
                    );
                  },
                  onMorePressed: () {
                    _showIdeaMenu(context, idea, controller);
                  },
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<CreateIdeaController>(
                        create: (_) => CreateIdeaController(),
                      ),
                    ],
                    child: const CreateIdeaScreen(),
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  // Refresh ideas list after creating new idea
                  controller.loadIdeas(refresh: true);
                }
              });
            },
            backgroundColor: SaharaColors.primary,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  /// Build empty state UI
  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: SaharaColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No ideas yet',
              style: SaharaTypography.headlineSmall.copyWith(
                color: SaharaColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share an idea',
              style: SaharaTypography.bodyMedium.copyWith(
                color: SaharaColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<CreateIdeaController>(
                          create: (_) => CreateIdeaController(),
                        ),
                      ],
                      child: const CreateIdeaScreen(),
                    ),
                  ),
                ).then((result) {
                  if (result == true) {
                    context.read<IdeaController>().loadIdeas(refresh: true);
                  }
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Idea'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SaharaColors.primary,
                foregroundColor: SaharaColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<CreateIdeaController>(
                    create: (_) => CreateIdeaController(),
                  ),
                ],
                child: const CreateIdeaScreen(),
              ),
            ),
          ).then((result) {
            if (result == true) {
              context.read<IdeaController>().loadIdeas(refresh: true);
            }
          });
        },
        backgroundColor: SaharaColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build error state UI
  Widget _buildErrorState(BuildContext context, IdeaController controller) {
    return Scaffold(
      body: Center(
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
              'Oops! Something went wrong',
              style: SaharaTypography.headlineSmall.copyWith(
                color: SaharaColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                controller.errorMessage ?? 'Failed to load ideas',
                textAlign: TextAlign.center,
                style: SaharaTypography.bodyMedium.copyWith(
                  color: SaharaColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.loadIdeas();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SaharaColors.primary,
                foregroundColor: SaharaColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<CreateIdeaController>(
                    create: (_) => CreateIdeaController(),
                  ),
                ],
                child: const CreateIdeaScreen(),
              ),
            ),
          ).then((result) {
            if (result == true) {
              context.read<IdeaController>().loadIdeas(refresh: true);
            }
          });
        },
        backgroundColor: SaharaColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Show more options menu for an idea
  void _showIdeaMenu(
    BuildContext context,
    dynamic idea,
    IdeaController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: SaharaColors.surface,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to idea detail
                },
              ),
              ListTile(
                leading: const Icon(Icons.comment_outlined),
                title: const Text('Comments'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to comments
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rate Idea'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show rating dialog
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Share functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Report functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
