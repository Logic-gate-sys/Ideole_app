import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../shared/widgets/sahara_buttons.dart';
import '../controllers/community_controller.dart';

/// Community Detail Screen - Shows full community information
class CommunityDetailScreen extends StatefulWidget {
  final String communityId;

  const CommunityDetailScreen({
    super.key,
    required this.communityId,
  });

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityController>().loadCommunityDetail(widget.communityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CommunityController>(
        builder: (context, controller, _) {
          final community = controller.currentCommunity;

          if (controller.isLoading && community == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage != null && community == null) {
            return Center(
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
                    'Failed to load community',
                    style: SaharaTypography.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      controller.errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: SaharaTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Try Again',
                    onPressed: () {
                      controller.loadCommunityDetail(widget.communityId);
                    },
                  ),
                ],
              ),
            );
          }

          if (community == null) {
            return const Center(
              child: Text('Community not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Community name
                Text(
                  community.name,
                  style: SaharaTypography.displaySmall.copyWith(
                    color: SaharaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Member count & status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: SaharaColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${community.memberCount} members',
                          style: SaharaTypography.bodyMedium.copyWith(
                            color: SaharaColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (community.isMember)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Member',
                          style: SaharaTypography.bodySmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else if (community.hasPendingRequest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Request Pending',
                          style: SaharaTypography.bodySmall.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Divider
                Divider(
                  color: SaharaColors.outline,
                  height: 32,
                ),

                // Description
                Text(
                  'About',
                  style: SaharaTypography.bodyLarge.copyWith(
                    color: SaharaColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  community.description,
                  style: SaharaTypography.bodyMedium.copyWith(
                    color: SaharaColors.onSurface,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Status
                if (community.status != 'ACTIVE')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: SaharaTypography.bodyLarge.copyWith(
                          color: SaharaColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'This community is ${community.status.toLowerCase()}',
                          style: SaharaTypography.bodyMedium.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),

                // Action buttons
                if (!community.isMember && !community.hasPendingRequest)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: 'Request to Join',
                      onPressed: () {
                        _showJoinDialog(context, controller);
                      },
                    ),
                  )
                else if (community.isMember)
                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      label: 'Leave Community',
                      onPressed: () {
                        _showLeaveDialog(context, controller);
                      },
                    ),
                  )
                else if (community.hasPendingRequest)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Your request is pending. An admin will review it soon.',
                      style: SaharaTypography.bodyMedium.copyWith(
                        color: Colors.amber,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Show join confirmation dialog
  void _showJoinDialog(
    BuildContext context,
    CommunityController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Community?'),
        content: const Text(
          'Request to join this community. '
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
              final success =
                  await controller.requestToJoin(widget.communityId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Request sent!'
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

  /// Show leave confirmation dialog
  void _showLeaveDialog(
    BuildContext context,
    CommunityController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Community?'),
        content: const Text(
          'You will no longer be a member of this community.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              // Note: membershipId would need to be passed from backend
              // For now, this is a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave functionality coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
