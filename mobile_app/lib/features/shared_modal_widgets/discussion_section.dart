import 'package:flutter/material.dart';
import '../../core/design/colors.dart';
import '../../core/design/typography.dart';

/// Discussion Comment Model
class DiscussionComment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;
  final List<DiscussionComment> replies;

  DiscussionComment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.replies = const [],
  });
}

/// Discussion Section Widget - Display comments and discussion threads
class DiscussionSection extends StatefulWidget {
  final String ideaTitle;
  final List<DiscussionComment> comments;
  final Function(String) onPostComment;

  const DiscussionSection({
    required this.ideaTitle,
    required this.comments,
    required this.onPostComment,
    super.key,
  });

  @override
  State<DiscussionSection> createState() => _DiscussionSectionState();
}

class _DiscussionSectionState extends State<DiscussionSection> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discussion',
                style: SaharaTypography.headlineLarge.copyWith(
                  color: SaharaColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all discussions
                },
                child: Text(
                  'View All Discussions',
                  style: SaharaTypography.labelSmall.copyWith(
                    color: SaharaColors.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Comments list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return _buildCommentThread(widget.comments[index]);
          },
        ),
        // Input area
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: _buildCommentInput(),
        ),
      ],
    );
  }

  Widget _buildCommentThread(DiscussionComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentCard(comment),
          // Replies
          if (comment.replies.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 16),
              child: Column(
                children: comment.replies
                    .map((reply) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: SaharaColors.outlineVariant
                                          .withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: _buildCommentCard(reply, isReply: true),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentCard(DiscussionComment comment, {bool isReply = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isReply ? 16 : 20,
          backgroundColor: SaharaColors.primaryContainer,
          child: Text(
            comment.authorName.substring(0, 1).toUpperCase(),
            style: SaharaTypography.labelSmall.copyWith(
              color: SaharaColors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.authorName,
                    style: SaharaTypography.labelMedium.copyWith(
                      color: SaharaColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatTime(comment.timestamp),
                    style: SaharaTypography.labelSmall.copyWith(
                      color: SaharaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.content,
                style: SaharaTypography.bodyMedium.copyWith(
                  color: SaharaColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildActionButton(Icons.thumb_up, '${comment.likes}'),
                  const SizedBox(width: 24),
                  _buildActionButton(Icons.chat_bubble_outline, 'Reply'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: SaharaColors.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: SaharaTypography.labelSmall.copyWith(
              color: SaharaColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: SaharaColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SaharaColors.outlineVariant.withOpacity(0.5),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Share your perspective...',
                border: InputBorder.none,
                hintStyle: SaharaTypography.bodySmall.copyWith(
                  color: SaharaColors.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_commentController.text.isNotEmpty) {
                widget.onPostComment(_commentController.text);
                _commentController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SaharaColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.send,
                color: SaharaColors.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
