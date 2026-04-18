import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';

class CreateIdeaScreen extends StatefulWidget {
  final String? communityId;
  final String? organisationId;

  const CreateIdeaScreen({
    super.key,
    this.communityId,
    this.organisationId,
  });

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<_CriteriaDraft> _criteriaDrafts = [];
  IdeaVisibility _selectedVisibility = IdeaVisibility.private;

  @override
  void initState() {
    super.initState();
    if (widget.communityId != null && widget.communityId!.isNotEmpty) {
      _selectedVisibility = IdeaVisibility.protected;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final draft in _criteriaDrafts) {
      draft.dispose();
    }
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
          'Create Idea',
          style: AppTextStyles.titleLarge,
        ),
      ),
      body: Consumer<IdeaController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.communityId != null) ...[
                    AppCard(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: AppColors.primaryContainer,
                      borderColor: AppColors.primary,
                      child: Row(
                        children: [
                          Icon(
                            Icons.groups,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This idea will be created in a community context.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  AppInput(
                    label: 'Title',
                    hint: 'Summarize your idea in one clear sentence',
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 200,
                    showCounter: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppInput(
                    label: 'Description',
                    hint: 'Describe the idea, its value, and intended impact',
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 6,
                    maxLength: 5000,
                    showCounter: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Visibility',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildVisibilitySelector(),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Evaluation Criteria',
                        style: AppTextStyles.titleMedium,
                      ),
                      AppButton(
                        label: 'Add',
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.outlined,
                        icon: Icons.add,
                        onPressed: _addCriteriaDraft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Optional criteria let reviewers evaluate ideas consistently.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCriteriaSection(),
                  const SizedBox(height: 24),

                  if (controller.error != null) ...[
                    AppCard(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: AppColors.errorContainer,
                      borderColor: AppColors.error,
                      child: Text(
                        controller.error!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  AppButton(
                    label: 'Create Idea',
                    variant: AppButtonVariant.filled,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    isLoading: controller.isLoading,
                    onPressed: controller.isLoading ? null : _submitIdea,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisibilitySelector() {
    return Row(
      children: IdeaVisibility.values
          .map(
            (visibility) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(visibilityToString(visibility)),
                  selected: _selectedVisibility == visibility,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedVisibility = visibility);
                    }
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCriteriaSection() {
    if (_criteriaDrafts.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.all(12),
        backgroundColor: AppColors.surfaceVariant,
        child: Text(
          'No custom criteria added.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: _criteriaDrafts.asMap().entries.map((entry) {
        final index = entry.key;
        final draft = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Criterion ${index + 1}',
                      style: AppTextStyles.labelLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Remove criterion',
                      onPressed: () => _removeCriteriaDraft(index),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                AppInput(
                  label: 'Name',
                  hint: 'e.g. Feasibility',
                  controller: draft.nameController,
                  maxLength: 100,
                  showCounter: true,
                ),
                const SizedBox(height: 12),
                AppInput(
                  label: 'Description',
                  hint: 'How should this criterion be evaluated?',
                  controller: draft.descriptionController,
                  maxLines: 3,
                  maxLength: 500,
                  showCounter: true,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _addCriteriaDraft() {
    setState(() {
      _criteriaDrafts.add(_CriteriaDraft());
    });
  }

  void _removeCriteriaDraft(int index) {
    final draft = _criteriaDrafts.removeAt(index);
    draft.dispose();
    setState(() {});
  }

  Future<void> _submitIdea() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final criteria = <IdeaCriteriaInput>[];
    for (final draft in _criteriaDrafts) {
      final name = draft.nameController.text.trim();
      final description = draft.descriptionController.text.trim();

      if (name.isEmpty && description.isEmpty) {
        continue;
      }

      if (name.length < 2 || description.length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Each criterion needs a name and detailed description.'),
          ),
        );
        return;
      }

      criteria.add(
        IdeaCriteriaInput(
          name: name,
          description: description,
        ),
      );
    }

    final controller = context.read<IdeaController>();
    final success = await controller.createIdea(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      visibility: _selectedVisibility,
      communityId: widget.communityId,
      organisationId: widget.organisationId,
      criteria: criteria,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Idea created successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

class _CriteriaDraft {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
  }
}
