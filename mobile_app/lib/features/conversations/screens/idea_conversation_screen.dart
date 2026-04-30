import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/environment.dart';
import '../../../core/services/realtime_socket_service.dart';
import '../../../core/services/token_storage.dart';
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
  final ScrollController _messagesScrollController = ScrollController();
  final RealtimeSocketService _socketService = RealtimeSocketService();

  Conversation? _conversation;
  List<ConversationMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _socketConnected = false;
  String? _error;
  Timer? _pollingTimer;

  static const Duration _pollingInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _socketService.disconnect();
    _messagesScrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final conversation = await _conversationService
          .getOrCreateIdeaConversation(widget.ideaId);
      final messages = await _conversationService.getMessages(conversation.id);
      messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

      if (!mounted) {
        return;
      }

      setState(() {
        _conversation = conversation;
        _messages = messages;
      });

      _scrollToLatestMessage();
      await _startRealtimeUpdates();
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
        _messages = _mergeMessages(_messages, [sentMessage]);
        _messageController.clear();
      });

      _scrollToLatestMessage();
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
        title: Text('Conversation', style: AppTextStyles.titleLarge),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(
                  _socketConnected ? Icons.wifi_tethering : Icons.sync,
                  size: 14,
                  color: _socketConnected
                      ? AppColors.secondary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _socketConnected
                      ? 'Live updates: socket connected'
                      : 'Live updates: polling every 5s',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _socketConnected
                        ? AppColors.secondary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildMessageList(currentUserId)),
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
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
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
      controller: _messagesScrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: _messages.length,
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message.senderId == currentUserId;

        return Align(
          alignment: isCurrentUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
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
                Text(message.content, style: AppTextStyles.bodyMedium),
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
                    borderSide: BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outlineVariant),
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

  Future<void> _startRealtimeUpdates() async {
    final conversation = _conversation;
    if (conversation == null) {
      return;
    }

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
      _pollingTimer?.cancel();
      if (token != null && token.isNotEmpty) {
        _socketService.send({'type': 'auth', 'token': token});
      }
      _socketService.send({
        'type': 'subscribe',
        'channel': 'idea.conversation',
        'conversationId': conversation.id,
      });
    } else {
      _startPolling();
    }

    setState(() {
      _socketConnected = connected;
    });
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
      _syncMessages();
    });
  }

  Future<void> _syncMessages() async {
    final conversation = _conversation;
    if (!mounted || conversation == null || _isLoading) {
      return;
    }

    try {
      final latest = await _conversationService.getMessages(conversation.id);
      latest.sort((a, b) => a.sentAt.compareTo(b.sentAt));

      if (!mounted || _sameMessages(_messages, latest)) {
        return;
      }

      setState(() {
        _messages = _mergeMessages(const [], latest);
      });
      _scrollToLatestMessage();
    } catch (_) {
      // Keep silent for background sync.
    }
  }

  bool _sameMessages(
    List<ConversationMessage> current,
    List<ConversationMessage> incoming,
  ) {
    if (current.length != incoming.length) {
      return false;
    }

    for (var i = 0; i < current.length; i++) {
      if (current[i].id != incoming[i].id) {
        return false;
      }
    }

    return true;
  }

  void _handleRealtimeEvent(Map<String, dynamic> event) {
    if (!mounted || _conversation == null) {
      return;
    }

    final payload = _extractPayload(event);
    final type = (event['type'] ?? event['event'] ?? '').toString();
    if (payload == null) {
      return;
    }

    final payloadConversationId = payload['conversationId']?.toString();
    if (payloadConversationId != null &&
        payloadConversationId.isNotEmpty &&
        payloadConversationId != _conversation!.id) {
      return;
    }

    final isCreateEvent =
        type == 'message.created' ||
        type == 'conversation.message.created' ||
        type == 'message:new';

    if (isCreateEvent ||
        (payload.containsKey('content') && payload.containsKey('sentAt'))) {
      final incoming = ConversationMessage.fromJson(payload);

      setState(() {
        _messages = _mergeMessages(_messages, [incoming]);
      });
      _scrollToLatestMessage();
    }
  }

  List<ConversationMessage> _mergeMessages(
    List<ConversationMessage> existing,
    List<ConversationMessage> incoming,
  ) {
    final byIdentity = <String, ConversationMessage>{};
    for (final message in [...existing, ...incoming]) {
      byIdentity[_messageIdentity(message)] = message;
    }

    final merged = byIdentity.values.toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    return merged;
  }

  String _messageIdentity(ConversationMessage message) {
    if (message.id.isNotEmpty) {
      return 'id:${message.id}';
    }

    return [
      'fallback',
      message.conversationId,
      message.senderId,
      message.sentAt.toUtc().millisecondsSinceEpoch,
      message.content.trim(),
    ].join('|');
  }

  Map<String, dynamic>? _extractPayload(Map<String, dynamic> event) {
    final payload = event['data'];
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (event.containsKey('content') && event.containsKey('sentAt')) {
      return event;
    }

    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }

    return null;
  }

  void _scrollToLatestMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_messagesScrollController.hasClients) {
        return;
      }

      final position = _messagesScrollController.position;
      _messagesScrollController.animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }
}
