import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../controllers/organisation_controller.dart';

class CreateOrganisationScreen extends StatefulWidget {
  const CreateOrganisationScreen({super.key});

  @override
  State<CreateOrganisationScreen> createState() =>
      _CreateOrganisationScreenState();
}

class _CreateOrganisationScreenState extends State<CreateOrganisationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late AnimationController _animationController;
  String _selectedTier = 'starter';

  final tiers = [
    {
      'id': 'starter',
      'label': 'Starter',
      'description': 'Perfect for small teams',
      'features': ['Up to 5 communities', 'Basic features', 'Community support'],
    },
    {
      'id': 'professional',
      'label': 'Professional',
      'description': 'For growing organizations',
      'features': ['Up to 20 communities', 'Advanced features', 'Priority support'],
    },
    {
      'id': 'enterprise',
      'label': 'Enterprise',
      'description': 'Complete solution',
      'features': ['Unlimited communities', 'All features', 'Dedicated support'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = context.read<OrganisationController>();
    final success = await controller.createOrganisation(
      name: _nameController.text.trim(),
      tier: _selectedTier,
    );

    if (mounted && success != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Organization created successfully!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted && controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.error!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onError,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: AppSpacing.xxxl),

              // Form
              _buildForm(),
              SizedBox(height: AppSpacing.xxxl),

              // Tier selection
              _buildTierSelection(),
              SizedBox(height: AppSpacing.xxxl),

              // Create button
              Consumer<OrganisationController>(
                builder: (context, controller, _) {
                  return AppButton(
                    label: 'Create Organization',
                    variant: AppButtonVariant.filled,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    isLoading: controller.isLoading,
                    onPressed:
                        controller.isLoading ? null : _handleCreate,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Opacity(
        opacity: _animationController.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Organization',
              style: AppTextStyles.displayMedium,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Build and manage your community of innovators',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: AppInput(
        label: 'Organization Name',
        hint: 'e.g., TechStartup Co.',
        controller: _nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Organization name is required';
          }
          if (value.length < 3) {
            return 'Name must be at least 3 characters';
          }
          if (value.length > 100) {
            return 'Name must be less than 100 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTierSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: AppTextStyles.headlineSmall,
        ),
        SizedBox(height: AppSpacing.lg),
        Column(
          children: tiers
              .map(
                (tier) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildTierCard(tier),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTierCard(Map<String, dynamic> tier) {
    final isSelected = _selectedTier == tier['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTier = tier['id'];
        });
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier['label'],
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      tier['description'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outline,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: (tier['features'] as List<String>)
                  .map(
                    (feature) => Chip(
                      label: Text(
                        feature,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                      backgroundColor: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surface,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : AppColors.outlineVariant,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
