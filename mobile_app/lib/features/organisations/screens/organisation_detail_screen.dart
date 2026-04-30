import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../../../shared/models/organisation_model.dart';
import '../../communities/controllers/community_controller.dart';
import '../../communities/screens/create_community_screen.dart';
import '../../communities/screens/community_detail_screen.dart';

class OrganisationDetailScreen extends StatefulWidget {
  final Organisation organisation;

  const OrganisationDetailScreen({
    super.key,
    required this.organisation,
  });

  @override
  State<OrganisationDetailScreen> createState() =>
      _OrganisationDetailScreenState();
}

class _OrganisationDetailScreenState extends State<OrganisationDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();

    // Load communities for this organisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityController>().listCommunities(widget.organisation.id);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: GestureDetector(
              onTap: () {
                // Show organization options menu
              },
              child: Icon(
                Icons.more_vert,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header section
            SliverAppBar(
              backgroundColor: AppColors.surface,
              toolbarHeight: 0,
              collapsedHeight: 0,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderSection(),
              ),
            ),

            // Communities section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Communities',
                          style: AppTextStyles.headlineSmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateCommunityScreen(
                                      organisationId:
                                          widget.organisation.id,
                                    ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Communities list
            Consumer<CommunityController>(
              builder: (context, controller, _) {
                final communities =
                    controller.communitiesByOrg[widget.organisation.id] ?? [];

                if (controller.isLoading && communities.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (communities.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final community = communities[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommunityDetailScreen(
                                      community: community,
                                      organisationId:
                                          widget.organisation.id,
                                    ),
                              ),
                            );
                          },
                          child: _buildCommunityCard(community),
                        ),
                      );
                    },
                    childCount: communities.length,
                  ),
                );
              },
            ),

            // Bottom padding
            SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryContainer.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                Icons.domain,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              widget.organisation.name,
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.sm),
            _buildTierBadge(widget.organisation.tier),
          ],
        ),
      ),
    );
  }

  Widget _buildTierBadge(String tier) {
    final tierColors = {
      'starter': AppColors.tertiary,
      'professional': AppColors.secondary,
      'enterprise': AppColors.primary,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tierColors[tier]?.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: tierColors[tier] ?? AppColors.outline,
          width: 1,
        ),
      ),
      child: Text(
        tier.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: tierColors[tier] ?? AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCommunityCard(dynamic community) {
    return Card(
      color: AppColors.surfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.outline, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getVisibilityColor(community.visibility)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    _getVisibilityIcon(community.visibility),
                    color: _getVisibilityColor(community.visibility),
                    size: 24,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (community.description?.isNotEmpty ?? false)
                        Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            community.description ?? '',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
            if (community.status != 'ACTIVE')
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: AppChip(
                  label: community.status,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 80,
              color: AppColors.outlineVariant,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'No Communities Yet',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Create your first community to start collaborating',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Create Community',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.medium,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateCommunityScreen(
                      organisationId: widget.organisation.id,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVisibilityIcon(String visibility) {
    switch (visibility.toUpperCase()) {
      case 'PUBLIC':
        return Icons.public;
      case 'PROTECTED':
        return Icons.lock_open;
      case 'PRIVATE':
        return Icons.lock;
      default:
        return Icons.visibility;
    }
  }

  Color _getVisibilityColor(String visibility) {
    switch (visibility.toUpperCase()) {
      case 'PUBLIC':
        return AppColors.primary;
      case 'PROTECTED':
        return AppColors.secondary;
      case 'PRIVATE':
        return AppColors.tertiary;
      default:
        return AppColors.outline;
    }
  }
}
