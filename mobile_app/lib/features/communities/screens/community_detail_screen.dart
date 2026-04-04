import 'package:flutter/material.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../../../shared/models/community_model.dart';

class CommunityDetailScreen extends StatefulWidget {
  final Community community;
  final String organisationId;

  const CommunityDetailScreen({
    super.key,
    required this.community,
    required this.organisationId,
  });

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
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
                // Show community options menu
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
              collapsedHeight: 0,
              expandedHeight: 220,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderSection(),
              ),
            ),

            // About section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.community.description?.isNotEmpty ?? false) ...[
                      Text(
                        'About',
                        style: AppTextStyles.headlineSmall,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        widget.community.description ?? '',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxxl),
                    ],

                    // Stats section
                    _buildStatsSection(),
                    SizedBox(height: AppSpacing.xxxl),

                    // Action buttons
                    _buildActionButtons(),
                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Ideas section placeholder
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Ideas',
                      style: AppTextStyles.headlineSmall,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              size: 48,
                              color: AppColors.outline,
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              'No ideas yet',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
            _getVisibilityColor(widget.community.visibility)
                .withOpacity(0.1),
            _getVisibilityColor(widget.community.visibility)
                .withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _getVisibilityColor(widget.community.visibility)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(
                    _getVisibilityIcon(widget.community.visibility),
                    color:
                        _getVisibilityColor(widget.community.visibility),
                    size: 32,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVisibilityBadge(),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.community.status,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              widget.community.name,
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityBadge() {
    final visibility = widget.community.visibility.toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getVisibilityColor(widget.community.visibility)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: _getVisibilityColor(widget.community.visibility),
          width: 1,
        ),
      ),
      child: Text(
        visibility,
        style: AppTextStyles.labelSmall.copyWith(
          color: _getVisibilityColor(widget.community.visibility),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('0', 'Ideas'),
        _buildStatCard('0', 'Members'),
        _buildStatCard('0', 'Comments'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Card(
        color: AppColors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: AppColors.outline, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: 'Join Community',
          variant: AppButtonVariant.filled,
          size: AppButtonSize.large,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Joined community successfully!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Start an Idea',
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.large,
          onPressed: () {
            // Navigate to create idea screen
          },
        ),
      ],
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
