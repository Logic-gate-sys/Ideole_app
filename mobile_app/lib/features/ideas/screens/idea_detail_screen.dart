import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../comments/controllers/comment_controller.dart';
import '../../comments/screens/comments_section.dart';
import '../../conversations/screens/idea_conversation_screen.dart';
import '../../ratings/controllers/rating_controller.dart';
import '../../ratings/models/rating.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';

class IdeaDetailScreen extends StatefulWidget {
  final String ideaId;

  const IdeaDetailScreen({
    super.key,
    required this.ideaId,
  });

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  double _originalityScore = 7;
  double _feasibilityScore = 7;
  double _impactScore = 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllSections();
    });
  }

  void _loadAllSections() {
    context.read<IdeaController>().loadIdeaDetails(widget.ideaId);
    context.read<RatingController>().loadIdeaRatingData(widget.ideaId);
    context.read<CommentController>().loadComments(widget.ideaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Idea Details',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllSections,
          ),
        ],
      ),
      body: Consumer2<IdeaController, AuthController>(
        builder: (context, ideaController, authController, _) {
          if (ideaController.isLoading && ideaController.selectedIdea == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ideaController.error != null && ideaController.selectedIdea == null) {
            return _buildErrorView(context, ideaController);
          }

          final idea = ideaController.selectedIdea;
          if (idea == null) {
            return Center(
              child: Text(
                'Idea not found',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            );
          }

          final currentUserId = authController.currentUser?.id;
          final canManage = idea.isOwnedBy(currentUserId);
          return _buildDetailView(
            context,
            ideaController,
            idea,
            canManage,
            currentUserId,
          );
        },
      ),
    );
  }

  Widget _buildDetailView(
    BuildContext context,
    IdeaController controller,
    Idea idea,
    bool canManage,
    String? currentUserId,
  ) {
    final canManageCriteria = canManage && idea.stage == IdeaStage.inception;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(
                label: idea.visibilityLabel,
                variant: AppBadgeVariant.outlined,
              ),
              AppBadge(
                label: idea.stageLabel,
                variant: AppBadgeVariant.tonal,
              ),
              AppBadge(
                label: '${idea.ratingCount} Ratings',
                variant: AppBadgeVariant.filled,
              ),
              AppBadge(
                label: '${idea.commentCount} Comments',
                variant: AppBadgeVariant.filled,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            idea.title,
            style: AppTextStyles.headlineLarge.copyWith(
              fontSize: 30,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              AppAvatar(
                initials: idea.authorName.isNotEmpty
                    ? idea.authorName[0].toUpperCase()
                    : '?',
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      idea.authorName,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Posted ${_formatDate(idea.createdAt)}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (canManage) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Edit Idea',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.outlined,
                    icon: Icons.edit_outlined,
                    onPressed: () => _showEditIdeaSheet(idea),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Delete',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.outlined,
                    icon: Icons.delete_outline,
                    onPressed: () => _handleDeleteIdea(idea.id),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          AppButton(
            label: 'Open Conversation',
            variant: AppButtonVariant.outlined,
            size: AppButtonSize.small,
            icon: Icons.forum_outlined,
            onPressed: () => _openConversation(idea),
          ),

          const SizedBox(height: 24),

          _buildSection(
            title: 'Description',
            content: idea.description,
            icon: Icons.description_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),

          if (idea.belongsToCommunity || idea.belongsToOrganisation)
            _buildContextSection(idea),

          if (idea.belongsToCommunity || idea.belongsToOrganisation)
            const SizedBox(height: 20),

          _buildCriteriaSection(
            controller: controller,
            idea: idea,
            canManageCriteria: canManageCriteria,
            canManage: canManage,
          ),

          const SizedBox(height: 24),

          _buildRatingSection(
            idea.id,
            currentUserId,
            canManage,
          ),

          const SizedBox(height: 24),

          _buildCommentsSection(idea.id),
        ],
      ),
    );
  }

  Widget _buildRatingSection(
    String ideaId,
    String? currentUserId,
    bool isOwner,
  ) {
    return Consumer<RatingController>(
      builder: (context, ratingController, _) {
        final RatingStats? stats = ratingController.getRatingStats(ideaId);
        final hasUserRated =
            ratingController.hasUserRatedIdea(ideaId, currentUserId);

        final metricEntries = (stats?.averageScores ?? {}).entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ratings',
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppCard(
              backgroundColor: AppColors.surfaceContainerLowest,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall score: ${stats?.averageOverall.toStringAsFixed(1) ?? '0.0'} / 10',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total ratings: ${stats?.totalRatings ?? 0}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (metricEntries.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: metricEntries
                          .map(
                            (entry) => AppBadge(
                              label:
                                  '${entry.key}: ${entry.value.toStringAsFixed(1)}',
                              variant: AppBadgeVariant.tonal,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (isOwner)
              Text(
                'Owners cannot rate their own ideas.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else if (hasUserRated)
              Text(
                'You have already rated this idea. Submit again to update your rating.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              const SizedBox.shrink(),
            if (!isOwner) ...[
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSlider(
                      label: 'Originality',
                      min: 1,
                      max: 10,
                      divisions: 9,
                      value: _originalityScore,
                      labelBuilder: (value) => value.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _originalityScore = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    AppSlider(
                      label: 'Feasibility',
                      min: 1,
                      max: 10,
                      divisions: 9,
                      value: _feasibilityScore,
                      labelBuilder: (value) => value.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _feasibilityScore = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    AppSlider(
                      label: 'Impact',
                      min: 1,
                      max: 10,
                      divisions: 9,
                      value: _impactScore,
                      labelBuilder: (value) => value.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _impactScore = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Submit Rating',
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.medium,
                      isFullWidth: true,
                      onPressed: ratingController.isLoading
                          ? null
                          : () => _submitRating(ideaId),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCommentsSection(String ideaId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.forum_outlined,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Discussion',
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CommentsSection(ideaId: ideaId),
      ],
    );
  }

  Future<void> _submitRating(String ideaId) async {
    final ratingController = context.read<RatingController>();
    final success = await ratingController.rateIdea(
      ideaId: ideaId,
      originality: _originalityScore.round(),
      feasibility: _feasibilityScore.round(),
      impact: _impactScore.round(),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? ratingController.successMessage ?? 'Rating submitted.'
              : ratingController.error ?? 'Unable to submit rating.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  void _openConversation(Idea idea) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IdeaConversationScreen(
          ideaId: idea.id,
          ideaTitle: idea.title,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AppCard(
          backgroundColor: AppColors.surfaceContainerLowest,
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onSurface,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContextSection(Idea idea) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Context',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 10),
          if (idea.belongsToCommunity)
            Text(
              'Community ID: ${idea.communityId}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          if (idea.belongsToOrganisation)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Organisation ID: ${idea.organisationId}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCriteriaSection({
    required IdeaController controller,
    required Idea idea,
    required bool canManageCriteria,
    required bool canManage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Evaluation Criteria',
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
            const Spacer(),
            if (canManageCriteria)
              AppButton(
                label: 'Add',
                size: AppButtonSize.small,
                variant: AppButtonVariant.outlined,
                icon: Icons.add,
                onPressed: () => _handleCreateCriteria(idea),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (canManage && !canManageCriteria)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Criteria can be managed only during INCEPTION stage.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        if (idea.criteria.isEmpty)
          AppCard(
            backgroundColor: AppColors.surfaceContainerLowest,
            padding: const EdgeInsets.all(16),
            child: Text(
              'No custom criteria were added for this idea.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          )
        else
          ...(() {
            final sortedCriteria = idea.criteria.toList()
              ..sort((a, b) => a.order.compareTo(b.order));
            return sortedCriteria.map(
                (criterion) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                criterion.name,
                                style: AppTextStyles.labelLarge,
                              ),
                            ),
                            AppBadge(
                              label: '#${criterion.order + 1}',
                              variant: AppBadgeVariant.tonal,
                            ),
                          ],
                        ),
                        if (criterion.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            criterion.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (canManageCriteria) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              AppButton(
                                label: 'Up',
                                size: AppButtonSize.small,
                                variant: AppButtonVariant.outlined,
                                icon: Icons.arrow_upward,
                                onPressed: () => _handleReorderCriteria(
                                  idea,
                                  criterion,
                                  true,
                                ),
                              ),
                              AppButton(
                                label: 'Down',
                                size: AppButtonSize.small,
                                variant: AppButtonVariant.outlined,
                                icon: Icons.arrow_downward,
                                onPressed: () => _handleReorderCriteria(
                                  idea,
                                  criterion,
                                  false,
                                ),
                              ),
                              AppButton(
                                label: 'Edit',
                                size: AppButtonSize.small,
                                variant: AppButtonVariant.outlined,
                                icon: Icons.edit_outlined,
                                onPressed: () =>
                                    _handleEditCriteria(idea, criterion),
                              ),
                              AppButton(
                                label: 'Delete',
                                size: AppButtonSize.small,
                                variant: AppButtonVariant.outlined,
                                icon: Icons.delete_outline,
                                onPressed: () =>
                                    _handleDeleteCriteria(idea, criterion),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
          })(),
      ],
    );
  }

  Future<void> _showEditIdeaSheet(Idea idea) async {
    final titleController = TextEditingController(text: idea.title);
    final descriptionController = TextEditingController(text: idea.description);

    IdeaVisibility selectedVisibility = idea.visibility;
    IdeaStage selectedStage = idea.stage;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 18,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Idea',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    AppInput(
                      label: 'Title',
                      hint: 'Idea title',
                      controller: titleController,
                      maxLength: 200,
                      showCounter: true,
                    ),
                    const SizedBox(height: 12),
                    AppInput(
                      label: 'Description',
                      hint: 'Idea description',
                      controller: descriptionController,
                      maxLines: 5,
                      maxLength: 5000,
                      showCounter: true,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Visibility',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: IdeaVisibility.values.map((visibility) {
                        return ChoiceChip(
                          label: Text(visibilityToString(visibility)),
                          selected: selectedVisibility == visibility,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            setModalState(() {
                              selectedVisibility = visibility;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Stage',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: IdeaStage.values.map((stage) {
                        return ChoiceChip(
                          label: Text(stageToString(stage)),
                          selected: selectedStage == stage,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            setModalState(() {
                              selectedStage = stage;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.outlined,
                            onPressed: () => Navigator.of(sheetContext).pop(false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppButton(
                            label: 'Save',
                            variant: AppButtonVariant.filled,
                            onPressed: () => Navigator.of(sheetContext).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    final updatedTitle = titleController.text.trim();
    final updatedDescription = descriptionController.text.trim();
    titleController.dispose();
    descriptionController.dispose();

    if (saved != true || !mounted) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.updateIdea(
      idea.id,
      title: updatedTitle,
      description: updatedDescription,
      visibility: selectedVisibility,
      stage: selectedStage,
    );

    if (!mounted) {
      return;
    }

    _showControllerMessage(
      controller: controller,
      success: success,
      successFallback: 'Idea updated successfully.',
      errorFallback: 'Unable to update idea.',
    );
  }

  Future<void> _handleCreateCriteria(Idea idea) async {
    final result = await _showCriteriaDialog();
    if (result == null || !mounted) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.createCriteria(
      ideaId: idea.id,
      name: result.name,
      description: result.description,
    );

    if (!mounted) {
      return;
    }

    _showControllerMessage(
      controller: controller,
      success: success,
      successFallback: 'Criteria created successfully.',
      errorFallback: 'Unable to create criteria.',
    );
  }

  Future<void> _handleEditCriteria(Idea idea, EvaluationCriteria criteria) async {
    final result = await _showCriteriaDialog(
      initialName: criteria.name,
      initialDescription: criteria.description,
    );

    if (result == null || !mounted) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.updateCriteria(
      ideaId: idea.id,
      criteriaId: criteria.id,
      name: result.name,
      description: result.description,
    );

    if (!mounted) {
      return;
    }

    _showControllerMessage(
      controller: controller,
      success: success,
      successFallback: 'Criteria updated successfully.',
      errorFallback: 'Unable to update criteria.',
    );
  }

  Future<void> _handleDeleteCriteria(
    Idea idea,
    EvaluationCriteria criteria,
  ) async {
    final confirm = await showAppAlertDialog(
      context,
      title: 'Delete Criteria',
      message: 'Delete "${criteria.name}" from this idea?',
      positiveLabel: 'Delete',
      negativeLabel: 'Cancel',
      type: AlertType.warning,
    );

    if (confirm != true || !mounted) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.deleteCriteria(
      ideaId: idea.id,
      criteriaId: criteria.id,
    );

    if (!mounted) {
      return;
    }

    _showControllerMessage(
      controller: controller,
      success: success,
      successFallback: 'Criteria deleted successfully.',
      errorFallback: 'Unable to delete criteria.',
    );
  }

  Future<void> _handleReorderCriteria(
    Idea idea,
    EvaluationCriteria criteria,
    bool moveUp,
  ) async {
    final controller = context.read<IdeaController>();
    final success = await controller.reorderCriteria(
      ideaId: idea.id,
      criteriaId: criteria.id,
      moveUp: moveUp,
    );

    if (!mounted) {
      return;
    }

    _showControllerMessage(
      controller: controller,
      success: success,
      successFallback: 'Criteria order updated.',
      errorFallback: 'Unable to update criteria order.',
    );
  }

  Future<void> _handleDeleteIdea(String ideaId) async {
    final confirm = await showAppAlertDialog(
      context,
      title: 'Delete Idea',
      message: 'Are you sure you want to permanently delete this idea?',
      positiveLabel: 'Delete',
      negativeLabel: 'Cancel',
      type: AlertType.warning,
    );

    if (confirm != true || !mounted) {
      return;
    }

    final controller = context.read<IdeaController>();
    final success = await controller.deleteIdea(ideaId);

    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? controller.successMessage ?? 'Idea deleted.'
              : controller.error ?? 'Unable to delete idea.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );

    if (success) {
      navigator.pop();
    }
  }

  Future<_CriteriaDialogResult?> _showCriteriaDialog({
    String? initialName,
    String? initialDescription,
  }) {
    final nameController = TextEditingController(text: initialName ?? '');
    final descriptionController =
        TextEditingController(text: initialDescription ?? '');

    return showDialog<_CriteriaDialogResult>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            initialName == null ? 'Add Criteria' : 'Edit Criteria',
            style: AppTextStyles.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Criteria Name',
                    hintText: 'e.g. Feasibility',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe how this criterion should be assessed',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();

                if (name.length < 2 || description.length < 5) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  _CriteriaDialogResult(
                    name: name,
                    description: description,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      descriptionController.dispose();
    });
  }

  void _showControllerMessage({
    required IdeaController controller,
    required bool success,
    required String successFallback,
    required String errorFallback,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? controller.successMessage ?? successFallback
              : controller.error ?? errorFallback,
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, IdeaController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            controller.error ?? 'Error loading idea',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Retry',
            variant: AppButtonVariant.filled,
            size: AppButtonSize.medium,
            onPressed: () =>
                context.read<IdeaController>().loadIdeaDetails(widget.ideaId),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        final minutes = difference.inMinutes;
        return minutes <= 0 ? 'just now' : '$minutes minutes ago';
      }
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CriteriaDialogResult {
  final String name;
  final String description;

  const _CriteriaDialogResult({
    required this.name,
    required this.description,
  });
}
