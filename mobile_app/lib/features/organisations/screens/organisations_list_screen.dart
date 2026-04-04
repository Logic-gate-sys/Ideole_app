import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../controllers/organisation_controller.dart';
import 'create_organisation_screen.dart';
import 'organisation_detail_screen.dart';

class OrganisationsListScreen extends StatefulWidget {
  const OrganisationsListScreen({super.key});

  @override
  State<OrganisationsListScreen> createState() =>
      _OrganisationsListScreenState();
}

class _OrganisationsListScreenState extends State<OrganisationsListScreen>
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

    // Load organisations on screen init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrganisationController>().listOrganisations();
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
        title: Text(
          'My Organizations',
          style: AppTextStyles.headlineMedium,
        ),
        leading: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryContainer,
            child: Icon(
              Icons.domain,
              color: AppColors.primary,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateOrganisationScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<OrganisationController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.organisations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Loading organizations...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.organisations.isEmpty) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSpacing.xxxl),
                    Icon(
                      Icons.domain_disabled,
                      size: 80,
                      color: AppColors.outlineVariant,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      'No Organizations Yet',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Create your first organization to get started',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxxl),
                    AppButton(
                      label: 'Create Organization',
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.large,
                      isFullWidth: true,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const CreateOrganisationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<OrganisationController>().listOrganisations(),
            child: ListView.separated(
              padding: EdgeInsets.all(AppSpacing.lg),
              itemCount: controller.organisations.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final org = controller.organisations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            OrganisationDetailScreen(organisation: org),
                      ),
                    );
                  },
                  child: _buildOrganisationCard(org),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrganisationCard(dynamic org) {
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
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.domain,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        org.tier.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
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
            SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                  Icons.groups,
                  'Communities',
                  '${org.maxCommunities}',
                ),
                _buildInfoChip(
                  Icons.calendar_today,
                  'Created',
                  _formatDate(org.createdAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.onSurfaceVariant,
        ),
        SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
