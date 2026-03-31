import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/invite_controller.dart';
import '../models/invite.dart';

class InvitesScreen extends StatefulWidget {
  const InvitesScreen({super.key});

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late InviteController _inviteController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _inviteController = context.read<InviteController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inviteController.loadPendingInvites();
      _inviteController.loadUserInvites();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Consumer<InviteController>(
                builder: (context, controller, _) {
                  final pendingCount = controller.pendingInviteCount;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Pending'),
                      if (pendingCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$pendingCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            const Tab(text: 'All'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPendingView(context),
              _buildAllInvitesView(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingView(BuildContext context) {
    return Consumer<InviteController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.pendingInvites.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error != null && controller.pendingInvites.isEmpty) {
          return _buildErrorView(context, controller);
        }

        if (controller.pendingInvites.isEmpty) {
          return _buildEmptyView(
            context,
            'No pending invites',
            'You\'re all caught up!',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadPendingInvites(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.pendingInvites.length,
            itemBuilder: (context, index) {
              final invite = controller.pendingInvites[index];
              return _buildInviteCard(context, invite, controller, isPending: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildAllInvitesView(BuildContext context) {
    return Consumer<InviteController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.userInvites.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error != null && controller.userInvites.isEmpty) {
          return _buildErrorView(context, controller);
        }

        if (controller.userInvites.isEmpty) {
          return _buildEmptyView(
            context,
            'No invites yet',
            'When someone invites you to collaborate, it will show here.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadUserInvites(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.userInvites.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.userInvites.length) {
                final invite = controller.userInvites[index];
                return _buildInviteCard(context, invite, controller);
              } else {
                if (controller.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => controller.loadUserInvites(),
                    child: const Text('Load More'),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildInviteCard(
    BuildContext context,
    Invite invite,
    InviteController controller, {
    bool isPending = false,
  }) {
    final statusColor = _getStatusColor(invite.status);
    final statusIcon = _getStatusIcon(invite.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Idea ID: ${invite.ideaId.substring(0, 8)}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From: User ${invite.invitedByUserId.substring(0, 8)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        invite.status.toString().split('.').last.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
            Text(
              _formatDate(invite.createdAt),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 12),

            // Action buttons
            if (isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.declineInvite(
                              ideaId: invite.ideaId,
                              inviteId: invite.id,
                            ),
                    child: const Text('Decline'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.acceptInvite(
                              ideaId: invite.ideaId,
                              inviteId: invite.id,
                            ),
                    child: const Text('Accept'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, InviteController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading invites',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            controller.error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => controller.loadUserInvites(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(InviteStatus status) {
    switch (status) {
      case InviteStatus.pending:
        return Colors.orange;
      case InviteStatus.accepted:
        return Colors.green;
      case InviteStatus.declined:
        return Colors.red;
      case InviteStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(InviteStatus status) {
    switch (status) {
      case InviteStatus.pending:
        return Icons.hourglass_empty;
      case InviteStatus.accepted:
        return Icons.check_circle;
      case InviteStatus.declined:
        return Icons.cancel;
      case InviteStatus.cancelled:
        return Icons.block;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Sent today';
    } else if (difference.inDays == 1) {
      return 'Sent yesterday';
    } else if (difference.inDays < 7) {
      return 'Sent ${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return 'Sent ${(difference.inDays / 7).floor()}w ago';
    } else {
      return 'Sent ${(difference.inDays / 30).floor()}m ago';
    }
  }
}
