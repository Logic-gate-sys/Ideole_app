import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../controllers/community_controller.dart';

class CreateCommunityScreen extends StatefulWidget {
  final String organisationId;

  const CreateCommunityScreen({
    super.key,
    required this.organisationId,
  });

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late AnimationController _animationController;
  String _selectedVisibility = 'PRIVATE';

  final visibilityOptions = [
    {
      'id': 'PUBLIC',
      'label': 'Public',
      'icon': Icons.public,
      'description': 'Anyone can discover and join',
    },
    {
      'id': 'PROTECTED',
      'label': 'Protected',
      'icon': Icons.lock_open,
      'description': 'Anyone can discover, approval to join',
    },
    {
      'id': 'PRIVATE',
      'label': 'Private',
      'icon': Icons.lock,
      'description': 'Invite only',
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
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = context.read<CommunityController>();
    final success = await controller.createCommunity(
      organisationId: widget.organisationId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      visibility: _selectedVisibility,
    );

    if (mounted && success != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Community created successfully!',
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

              // Visibility selection
              _buildVisibilitySelection(),
              SizedBox(height: AppSpacing.xxxl),

              // Create button
              Consumer<CommunityController>(
                builder: (context, controller, _) {
                  return AppButton(
                    label: 'Create Community',
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
              'Create Community',
              style: AppTextStyles.displayMedium,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Start building a space for your team to collaborate',
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
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            AppInput(
              label: 'Community Name',
              hint: 'e.g., Product Discussions',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Community name is required';
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
            SizedBox(height: AppSpacing.lg),

            // Description field
            AppInput(
              label: 'Description',
              hint: 'What is this community about? (optional)',
              controller: _descriptionController,
              maxLines: 4,
              validator: (value) {
                if ((value?.length ?? 0) > 500) {
                  return 'Description must be less than 500 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community Visibility',
          style: AppTextStyles.headlineSmall,
        ),
        SizedBox(height: AppSpacing.lg),
        Column(
          children: visibilityOptions
              .map(
                (option) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildVisibilityCard(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildVisibilityCard(Map<String, dynamic> option) {
    final isSelected = _selectedVisibility == option['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVisibility = option['id'];
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
        child: Row(
          children: [
            Icon(
              option['icon'],
              color:
                  isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 28,
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['label'],
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    option['description'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.outline,
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
      ),
    );
  }
}
