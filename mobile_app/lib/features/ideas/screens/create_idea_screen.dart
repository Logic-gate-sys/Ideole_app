import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';

class CreateIdeaScreen extends StatefulWidget {
  const CreateIdeaScreen({super.key});

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();

  String _selectedCategory = 'Technology';
  IdeaVisibility _selectedVisibility = IdeaVisibility.private;

  static const List<String> categories = [
    'Technology',
    'Health',
    'Education',
    'Environment',
    'Business',
    'Social',
    'Entertainment',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Your Idea'),
        elevation: 0,
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
                  // Title field
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Give your idea a catchy title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Title is required';
                      }
                      if (value!.length < 5) {
                        return 'Title must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category dropdown
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Problem field
                  Text(
                    'Problem',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _problemController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'What problem does this idea solve?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Problem description is required';
                      }
                      if (value!.length < 20) {
                        return 'Problem description should be at least 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Solution field
                  Text(
                    'Solution',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _solutionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'How does your idea solve the problem?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Solution description is required';
                      }
                      if (value!.length < 20) {
                        return 'Solution description should be at least 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Visibility selector
                  Text(
                    'Visibility',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildVisibilitySelector(context),
                  const SizedBox(height: 8),
                  Text(
                    _getVisibilityDescription(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (controller.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Text(
                        controller.error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  if (controller.error != null) const SizedBox(height: 16),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : _submitIdea,
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Share Idea'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisibilitySelector(BuildContext context) {
    return Row(
      children: IdeaVisibility.values
          .map(
            (visibility) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    visibility.toString().split('.').last.toUpperCase(),
                  ),
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

  String _getVisibilityDescription() {
    switch (_selectedVisibility) {
      case IdeaVisibility.private:
        return 'Only you can see this idea. Keep it private until you\'re ready to share.';
      case IdeaVisibility.community:
        return 'Shared with community members. Limited visibility.';
      case IdeaVisibility.public:
        return 'Everyone can see and rate your idea. Open for collaboration.';
    }
  }

  Future<void> _submitIdea() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.createIdea(
      title: _titleController.text.trim(),
      problemText: _problemController.text.trim(),
      solutionText: _solutionController.text.trim(),
      category: _selectedCategory,
      visibility: _selectedVisibility,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Idea shared successfully! 🎉'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back after delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
