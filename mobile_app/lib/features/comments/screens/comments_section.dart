import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/environment.dart';
import '../../../core/services/realtime_socket_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/widgets/index.dart';
import '../controllers/comment_controller.dart';
import '../models/comment.dart';

class CommentsSection extends StatefulWidget {
  final String ideaId;

  const CommentsSection({super.key, required this.ideaId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _commentListController = ScrollController();
  final RealtimeSocketService _socketService = RealtimeSocketService();

  Timer? _pollingTimer;
  bool _socketConnected = false;
  bool _initialized = false;

  static const Duration _pollingInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSection();
    });
  }

  @override
  void didUpdateWidget(covariant CommentsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ideaId == widget.ideaId) {
      return;
    }

    _stopRealtimeUpdates();
    _initialized = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSection();
    });
  }

  @override
  void dispose() {
    _stopRealtimeUpdates();
    _commentListController.dispose();
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
            _buildRealtimeStatus(),
            const SizedBox(height: 10),
            _buildCommentFeed(
              context: context,
              comments: comments,
              isLoading: isLoading,
              error: error,
            ),
            const SizedBox(height: 12),
            _buildCommentInput(context, commentController),
            const SizedBox(height: 12),
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
    return AppCard(
      padding: const EdgeInsets.all(12),
      backgroundColor: AppColors.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _commentController,
            minLines: 1,
            maxLines: 4,
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
                        final rawText = _commentController.text.trim();
                        if (rawText.isEmpty) {
                          return;
                        }

                        final messenger = ScaffoldMessenger.of(context);
                        final success = await controller.createComment(
                          ideaId: widget.ideaId,
                          text: rawText,
                        );

                        if (!mounted) {
                          return;
                        }

                        if (success) {
                          _commentController.clear();
                          _jumpToLatestComment();
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Comment posted!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (controller.error != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(controller.error!),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                child: controller.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeStatus() {
    final statusText = _socketConnected
        ? 'Live updates: socket connected'
        : 'Live updates: polling every 5s';

    final statusColor = _socketConnected
        ? AppColors.secondary
        : AppColors.onSurfaceVariant;

    return Row(
      children: [
        Icon(
          _socketConnected ? Icons.wifi_tethering : Icons.sync,
          size: 14,
          color: statusColor,
        ),
        const SizedBox(width: 6),
        Text(
          statusText,
          style: AppTextStyles.labelSmall.copyWith(color: statusColor),
        ),
      ],
    );
  }

  Widget _buildCommentFeed({
    required BuildContext context,
    required List<Comment> comments,
    required bool isLoading,
    required String? error,
  }) {
    if (isLoading && comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }

    if (error != null && comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: $error',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
        ),
      );
    }

    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No comments yet. Start the discussion.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    final estimatedHeight = (comments.length * 112.0).clamp(180.0, 420.0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 180, maxHeight: estimatedHeight),
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<CommentController>().refreshComments(widget.ideaId),
          child: Scrollbar(
            controller: _commentListController,
            thumbVisibility: comments.length > 4,
            child: ListView.separated(
              controller: _commentListController,
              padding: const EdgeInsets.all(12),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: comments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              comment.userName,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(comment.createdAt),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comment.content, style: AppTextStyles.bodySmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeSection() async {
    if (!mounted || _initialized) {
      return;
    }

    _initialized = true;

    final controller = context.read<CommentController>();
    if (controller.getComments(widget.ideaId).isEmpty) {
      await controller.loadComments(widget.ideaId);
    }

    await _startRealtimeUpdates();
    _jumpToLatestComment();
  }

  Future<void> _startRealtimeUpdates() async {
    final token = TokenStorage().getToken();
    final wsUri = Uri.parse(Environment.socketBaseUrl);

    final connected = await _socketService.connect(
      uri: wsUri,
      onEvent: _handleRealtimeEvent,
      onError: (error, stackTrace) {
        _fallbackToPolling();
      },
      onDone: _fallbackToPolling,
    );

    if (!mounted) {
      return;
    }

    if (connected) {
      _stopPolling();
      if (token != null && token.isNotEmpty) {
        _socketService.send({'type': 'auth', 'token': token});
      }
      _socketService.send({
        'type': 'subscribe',
        'channel': 'idea.comments',
        'ideaId': widget.ideaId,
      });
    } else {
      _startPolling();
    }

    setState(() {
      _socketConnected = connected;
    });
  }

  void _handleRealtimeEvent(Map<String, dynamic> event) {
    if (!mounted) {
      return;
    }

    final payload = _extractPayload(event);
    final type = (event['type'] ?? event['event'] ?? '').toString();

    if (payload == null) {
      return;
    }

    final payloadIdeaId = (payload['ideaId'] ?? '').toString();
    if (payloadIdeaId.isNotEmpty && payloadIdeaId != widget.ideaId) {
      return;
    }

    final commentController = context.read<CommentController>();

    final isCreateEvent =
        type == 'comment.created' ||
        type == 'comment:new' ||
        type == 'idea.comment.created';
    final isDeleteEvent =
        type == 'comment.deleted' ||
        type == 'comment:deleted' ||
        type == 'idea.comment.deleted';

    if (isCreateEvent) {
      commentController.upsertCommentRealtime(
        widget.ideaId,
        Comment.fromJson(payload),
      );
      _jumpToLatestComment();
      return;
    }

    if (isDeleteEvent) {
      final commentId = (payload['commentId'] ?? payload['id'] ?? '')
          .toString();
      if (commentId.isNotEmpty) {
        commentController.removeCommentRealtime(widget.ideaId, commentId);
      }
    }
  }

  Map<String, dynamic>? _extractPayload(Map<String, dynamic> event) {
    final payload = event['data'];
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (event.containsKey('content') && event.containsKey('createdAt')) {
      return event;
    }

    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }

    return null;
  }

  void _fallbackToPolling() {
    if (!mounted) {
      return;
    }

    _startPolling();
    if (_socketConnected) {
      setState(() {
        _socketConnected = false;
      });
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      if (!mounted) {
        return;
      }

      context.read<CommentController>().syncComments(widget.ideaId);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _stopRealtimeUpdates() {
    _stopPolling();
    _socketService.disconnect();
  }

  void _jumpToLatestComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_commentListController.hasClients) {
        return;
      }

      final position = _commentListController.position;
      _commentListController.animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
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
