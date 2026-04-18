import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/index.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/conversation.dart';
import '../services/conversation_service.dart';

class IdeaConversationScreen extends StatefulWidget {
  final String ideaId;
  final String ideaTitle;

  const IdeaConversationScreen({
    super.key,
    required this.ideaId,
    required this.ideaTitle,
  });

  @override
  State<IdeaConversationScreen> createState() => _IdeaConversationScreenState();
}

class _IdeaConversationScreenState extends State<IdeaConversationScreen> {
  final ConversationService _conversationService = ConversationService();
  final TextEditingController _messageController = TextEditingController();

  Conversation? _conversation;
  List<ConversationMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final conversation =
          await _conversationService.getOrCreateIdeaConversation(widget.ideaId);
      final messages = await _conversationService.getMessages(conversation.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _conversation = conversation;
        _messages = messages;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _conversation == null || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final sentMessage = await _conversationService.sendMessage(
        conversationId: _conversation!.id,
        content: content,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _messages = [..._messages, sentMessage];
        _messageController.clear();
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to send message: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<AuthController>().currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Conversation',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _loadConversation,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.ideaTitle,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildMessageList(currentUserId),
          ),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageList(String? currentUserId) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _error ?? 'Unable to load conversation.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet. Start the conversation.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _messages.length,
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message.senderId == currentUserId;

        return Align(
          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              label: _isSending ? '...' : 'Send',
              variant: AppButtonVariant.filled,
              size: AppButtonSize.small,
              onPressed: _isSending ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
