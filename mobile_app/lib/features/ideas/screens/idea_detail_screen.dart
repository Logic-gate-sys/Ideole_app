import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/idea_controller.dart';
import '../models/idea.dart';
import '../../ratings/controllers/rating_controller.dart';
import '../../comments/controllers/comment_controller.dart';
import '../../comments/screens/comments_section.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load idea details
      context.read<IdeaController>().loadIdeaDetails(widget.ideaId);

      // Load ratings and comments
      context.read<RatingController>().loadIdeaRatingData(widget.ideaId);
      context.read<CommentController>().loadComments(widget.ideaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Details'),
        elevation: 0,
      ),
      body: Consumer<IdeaController>(
        builder: (context, ideaController, _) {
          if (ideaController.isLoading && ideaController.selectedIdea == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ideaController.error != null && ideaController.selectedIdea == null) {
            return _buildErrorView(context, ideaController);
          }

          final idea = ideaController.selectedIdea;
          if (idea == null) {
            return const Center(child: Text('Idea not found'));
          }

          return _buildDetailView(context, idea);
        },
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, Idea idea) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            idea.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),

          // Meta info
          _buildMetaInfo(context, idea),
          const SizedBox(height: 24),

          // Problem section
          _buildSection(
            context,
            title: 'Problem',
            content: idea.problemText,
          ),
          const SizedBox(height: 16),

          // Solution section
          _buildSection(
            context,
            title: 'Solution',
            content: idea.solutionText,
          ),
          const SizedBox(height: 24),

          // Ratings section
          _buildRatingsSection(context, idea.id),
          const SizedBox(height: 24),

          // Comments section
          _buildCommentsSection(context, idea.id),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context, Idea idea) {
    return Row(
      children: [
        Chip(
          label: Text(idea.category),
        ),
        const SizedBox(width: 8),
        Icon(
          idea.visibility == IdeaVisibility.public
              ? Icons.public
              : Icons.lock_outline,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          idea.visibility.toString().split('.').last.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Spacer(),
        Text(
          _formatDate(idea.createdAt),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingsSection(BuildContext context, String ideaId) {
    return Consumer<RatingController>(
      builder: (context, ratingController, _) {
        final stats = ratingController.getRatingStats(ideaId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ratings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            if (stats != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Average: ${stats.getAverageRating().toStringAsFixed(1)}⭐',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${stats.getRatingCount()} ratings',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Originality: ${stats.averageOriginality.toStringAsFixed(1)}/10 • '
                      'Feasibility: ${stats.averageFeasibility.toStringAsFixed(1)}/10 • '
                      'Impact: ${stats.averageImpact.toStringAsFixed(1)}/10',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            else
              const Text('No ratings yet'),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showRatingDialog(context, ideaId),
              icon: const Icon(Icons.star_outline),
              label: const Text('Rate This Idea'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentsSection(BuildContext context, String ideaId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discussion',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        CommentsSection(ideaId: ideaId),
      ],
    );
  }

  void _showRatingDialog(BuildContext context, String ideaId) {
    int originality = 5;
    int feasibility = 5;
    int impact = 5;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate This Idea'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Originality slider
                    Text('Originality: $originality / 10'),
                    Slider(
                      value: originality.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() => originality = value.toInt());
                      },
                    ),
                    const SizedBox(height: 16),

                    // Feasibility slider
                    Text('Feasibility: $feasibility / 10'),
                    Slider(
                      value: feasibility.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() => feasibility = value.toInt());
                      },
                    ),
                    const SizedBox(height: 16),

                    // Impact slider
                    Text('Impact: $impact / 10'),
                    Slider(
                      value: impact.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() => impact = value.toInt());
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<RatingController>().rateIdea(
                          ideaId: ideaId,
                          originality: originality,
                          feasibility: feasibility,
                          impact: impact,
                        );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  }

  Widget _buildErrorView(BuildContext context, IdeaController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            controller.error ?? 'Error loading idea',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
