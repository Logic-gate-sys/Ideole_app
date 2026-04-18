import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comment_controller.dart';

class CommentsSection extends StatefulWidget {
  final String ideaId;

  const CommentsSection({
    super.key,
    required this.ideaId,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, commentController, _) {
        final comments = commentController.getComments(widget.ideaId);
        final isLoading = commentController.isLoading;
        final error = commentController.error;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment input field
            _buildCommentInput(context, commentController),
            const SizedBox(height: 16),

            // Comments list
            if (isLoading && comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else if (error != null && comments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $error'),
              )
            else if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No comments yet. Be the first to comment!',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _formatDate(comment.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            comment.content,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),
            if (comments.length > 3)
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      commentController.loadMoreComments(widget.ideaId),
                  child: const Text('Load More Comments'),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(
    BuildContext context,
    CommentController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              border: InputBorder.none,
              counterText: '',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _commentController.clear(),
                child: const Text('Clear'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await controller.createComment(
                          ideaId: widget.ideaId,
                          text: _commentController.text,
                        );
                        if (success) {
                          _commentController.clear();
                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Comment posted!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                child: controller.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
