import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../shared/widgets/sahara_text_field.dart';
import '../../../shared/widgets/sahara_buttons.dart';
import '../controllers/create_idea_controller.dart';

/// Create Idea Screen - Allows users to submit new ideas
class CreateIdeaScreen extends StatefulWidget {
  const CreateIdeaScreen({Key? key}) : super(key: key);

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  String _selectedVisibility = 'PUBLIC';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _submit(CreateIdeaController controller) async {
    // Validate inputs
    if (_titleController.text.isEmpty) {
      controller.setError('Title is required');
      return;
    }
    if (_descriptionController.text.isEmpty) {
      controller.setError('Description is required');
      return;
    }
    if (_titleController.text.length < 5) {
      controller.setError('Title must be at least 5 characters');
      return;
    }
    if (_descriptionController.text.length < 20) {
      controller.setError('Description must be at least 20 characters');
      return;
    }

    // Clear errors and submit
    controller.setError(null);
    final success = await controller.createIdea(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      visibility: _selectedVisibility,
    );

    if (mounted && success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Idea created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Idea'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CreateIdeaController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                Text(
                  'What\'s your idea?',
                  style: SaharaTypography.headlineSmall.copyWith(
                    color: SaharaColors.onSurface,
                  ),
                ),
                const SizedBox(height: 24),

                // Title field
                SaharaTextField(
                  controller: _titleController,
                  label: 'Idea Title',
                  hint: 'Give your idea a catchy title',
                  maxLines: 1,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // Description field
                SaharaTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Describe your idea in detail...',
                  maxLines: 6,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),

                // Visibility section
                Text(
                  'Who can see this?',
                  style: SaharaTypography.bodyLarge.copyWith(
                    color: SaharaColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Visibility options
                Column(
                  children: [
                    _buildVisibilityOption(
                      title: 'Public',
                      description: 'Anyone can see and comment',
                      value: 'PUBLIC',
                    ),
                    const SizedBox(height: 12),
                    _buildVisibilityOption(
                      title: 'Protected',
                      description: 'Only community members can see',
                      value: 'PROTECTED',
                    ),
                    const SizedBox(height: 12),
                    _buildVisibilityOption(
                      title: 'Private',
                      description: 'Only you can see this',
                      value: 'PRIVATE',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Error message
                if (controller.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.errorMessage!,
                      style: SaharaTypography.bodySmall.copyWith(
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Create Idea',
                    isLoading: controller.isLoading,
                    onPressed: () => _submit(controller),
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build visibility option card
  Widget _buildVisibilityOption({
    required String title,
    required String description,
    required String value,
  }) {
    final isSelected = _selectedVisibility == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVisibility = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? SaharaColors.primary.withOpacity(0.1)
              : SaharaColors.surfaceContainer,
          border: Border.all(
            color: isSelected ? SaharaColors.primary : SaharaColors.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedVisibility,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedVisibility = val;
                  });
                }
              },
              activeColor: SaharaColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SaharaTypography.bodyLarge.copyWith(
                      color: SaharaColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: SaharaTypography.bodySmall.copyWith(
                      color: SaharaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
