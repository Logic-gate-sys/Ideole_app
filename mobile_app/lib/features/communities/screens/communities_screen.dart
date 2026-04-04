import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../shared/widgets/community_card.dart';
import '../controllers/community_controller.dart';
import 'community_detail_screen.dart';

/// Communities Screen - Displays list of communities
class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({Key? key}) : super(key: key);

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load communities on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityController>().loadCommunities();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll to load more communities
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<CommunityController>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityController>(
      builder: (context, controller, child) {
        // Empty state
        if (!controller.isLoading &&
            controller.communities.isEmpty &&
            controller.errorMessage == null) {
          return _buildEmptyState();
        }

        // Error state
        if (controller.errorMessage != null && controller.communities.isEmpty) {
          return _buildErrorState(controller);
        }

        // Loaded state with communities
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => controller.refreshCommunities(),
            color: SaharaColors.primary,
            backgroundColor: SaharaColors.surface,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.communities.length +
                  (controller.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator at bottom if there are more items
                if (index == controller.communities.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: SaharaColors.primary,
                      ),
                    ),
                  );
                }

                final community = controller.communities[index];
                return CommunityCard(
                  community: community,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<CommunityController>(
                              create: (_) => CommunityController(),
                            ),
                          ],
                          child: CommunityDetailScreen(
                            communityId: community.id,
                          ),
                        ),
                      ),
                    );
                  },
                  onJoinPressed: () {
                    _showJoinDialog(context, controller, community.id);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Build empty state UI
  Widget _buildEmptyState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 64,
              color: SaharaColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No communities yet',
              style: SaharaTypography.headlineSmall.copyWith(
                color: SaharaColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Communities will appear here soon',
              style: SaharaTypography.bodyMedium.copyWith(
                color: SaharaColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CommunityController>().loadCommunities();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
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
    );
  }

  /// Build error state UI
  Widget _buildErrorState(CommunityController controller) {
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
              'Failed to load communities',
              style: SaharaTypography.headlineSmall.copyWith(
                color: SaharaColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                controller.errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: SaharaTypography.bodyMedium.copyWith(
                  color: SaharaColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.loadCommunities();
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
    );
  }

  /// Show join confirmation dialog
  void _showJoinDialog(
    BuildContext context,
    CommunityController controller,
    String communityId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request to Join?'),
        content: const Text(
          'Send a request to join this community. '
          'An admin will review your request.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.requestToJoin(communityId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Request sent! Waiting for approval.'
                          : 'Failed to send request',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }
}
