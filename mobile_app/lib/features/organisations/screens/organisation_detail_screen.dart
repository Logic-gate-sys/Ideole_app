import 'package:flutter/material.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../models/organisation.dart';
import '../../../services/community_service.dart';

/// Organisation Detail Screen - Display organisation details and info
class OrganisationDetailScreen extends StatefulWidget {
  final Organisation organisation;

  const OrganisationDetailScreen({
    required this.organisation,
    super.key,
  });

  @override
  State<OrganisationDetailScreen> createState() =>
      _OrganisationDetailScreenState();
}

class _OrganisationDetailScreenState extends State<OrganisationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with hero image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.organisation.name,
                style: SaharaTypography.headlineSmall.copyWith(
                  color: SaharaColors.onSurface,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SaharaColors.primaryContainer,
                      SaharaColors.primary,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.business,
                    size: 80,
                    color: SaharaColors.onPrimary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            backgroundColor: SaharaColors.surface,
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: SaharaColors.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: SaharaColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Active Organisation',
                      style: SaharaTypography.labelSmall.copyWith(
                        color: SaharaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  if (widget.organisation.description != null) ...[
                    Text(
                      'About',
                      style: SaharaTypography.headlineSmall.copyWith(
                        color: SaharaColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.organisation.description ?? '',
                      style: SaharaTypography.bodyMedium.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  // Stats
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle join/request action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SaharaColors.primary,
                        foregroundColor: SaharaColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Request to Join',
                        style: SaharaTypography.labelMedium.copyWith(
                          color: SaharaColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Secondary actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // View members
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: SaharaColors.outlineVariant,
                            ),
                          ),
                          child: Text(
                            'Members',
                            style: SaharaTypography.labelMedium.copyWith(
                              color: SaharaColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // View guidelines
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: SaharaColors.outlineVariant,
                            ),
                          ),
                          child: Text(
                            'Guidelines',
                            style: SaharaTypography.labelMedium.copyWith(
                              color: SaharaColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateCommunityDialog(context);
        },
        backgroundColor: SaharaColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SaharaColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SaharaColors.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('156', 'Members'),
          _buildStat('42', 'Projects'),
          _buildStat('2021', 'Founded'),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: SaharaTypography.headlineMedium.copyWith(
            color: SaharaColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: SaharaTypography.labelSmall.copyWith(
            color: SaharaColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Show create community dialog
  void _showCreateCommunityDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Community'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Community Name',
                  hintText: 'e.g., Tech Innovation Group',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'What is this community about?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a community name')),
                );
                return;
              }

              Navigator.pop(context);

              try {
                final service = CommunityService();
                final community = await service.createCommunity(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  organisationId: widget.organisation.id,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Community "${community.name}" created!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create community: $e'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
