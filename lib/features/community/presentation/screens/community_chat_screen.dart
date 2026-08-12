import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';
import 'package:safe/features/community/presentation/providers/chat_provider.dart';

/// Real-time community chat screen
class CommunityChatScreen extends ConsumerStatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  ConsumerState<CommunityChatScreen> createState() =>
      _CommunityChatScreenState();
}

class _CommunityChatScreenState extends ConsumerState<CommunityChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll to the bottom of the message list
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Send a message
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty')),
      );
      return;
    }

    try {
      setState(() => _isSending = true);
      _messageController.clear();

      await ref.read(chatNotifierProvider.notifier).sendMessage(message);

      // Scroll to bottom after sending
      _scrollToBottom();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
      // Restore the message if sending failed
      _messageController.text = message;
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  /// Delete a message
  Future<void> _deleteMessage(String messageId) async {
    // Confirm deletion
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(chatNotifierProvider.notifier).deleteMessage(messageId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userInfo = ref.watch(chatUserInfoNotifierProvider);
    final messagesStream = ref.watch(chatMessagesStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesStream.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Auto-scroll to latest message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(chatMessagesStreamProvider);
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: false, // Do NOT reverse - messages are already oldest→newest
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                      vertical: AppSpacing.md,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // Direct index - messages list is already chronologically sorted
                      // Index 0 = oldest, Index N = newest
                      final message = messages[index];
                      final isCurrentUser =
                          userInfo.valueOrNull?.userId == message.userId;

                      return _MessageBubble(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        onDelete: () => _deleteMessage(message.id),
                      );
                    },
                  ),
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Connecting to chat...',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to say hello!',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Connection error',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        error.toString().length > 100
                            ? 'Cannot connect to the backend server'
                            : error.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.tonal(
                      onPressed: () => ref.refresh(chatMessagesStreamProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message input area - Modern style
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: userInfo.when(
              data: (user) {
                if (user == null) {
                  return Center(
                    child: Text(
                      'Please log in to send messages',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Emoji button
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          onPressed: () {
                            setState(() => _showEmojiPicker = !_showEmojiPicker);
                          },
                          color: _showEmojiPicker
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        // Message input
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !_isSending,
                            maxLines: null,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // Send button
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          radius: 20,
                          child: IconButton(
                            onPressed: _isSending ? null : _sendMessage,
                            icon: _isSending
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.send_rounded,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    // Emoji Picker
                    if (_showEmojiPicker)
                      SizedBox(
                        height: 250,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            _messageController.text += emoji.emoji;
                          },
                          onBackspacePressed: () {
                            if (_messageController.text.isNotEmpty) {
                              _messageController.text = _messageController.text
                                  .substring(0, _messageController.text.length - 1);
                            }
                          },
                          config: Config(
                            height: 250,
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Message bubble widget - Telegram/Instagram style
class _MessageBubble extends ConsumerWidget {

  const _MessageBubble({
    required this.message,
    required this.isCurrentUser,
    required this.onDelete,
  });
  final ChatMessage message;
  final bool isCurrentUser;
  final VoidCallback onDelete;

  /// Generate a consistent color based on user ID
  static Color _getUserColor(String userId) {
    final colors = [
      const Color(0xFF2196F3), // Blue
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFF9800), // Orange
      const Color(0xFFE91E63), // Pink
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFF44336), // Red
      const Color(0xFF795548), // Brown
    ];
    final hash = userId.hashCode.abs();
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userColor = _getUserColor(message.userId);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: isCurrentUser ? 48 : 0,
          right: isCurrentUser ? 0 : 48,
          bottom: 12,
          top: 2,
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  bottom: 6,
                ),
                child: Text(
                  message.userName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: userColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            GestureDetector(
              onLongPress: isCurrentUser ? onDelete : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? theme.colorScheme.primary
                      : userColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isCurrentUser ? 18 : 6),
                    bottomRight: Radius.circular(isCurrentUser ? 6 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // Message text with emoji support
                    Text(
                      message.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCurrentUser
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Time in compact format
                    Text(
                      _formatTime(message.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isCurrentUser
                            ? theme.colorScheme.onPrimary.withValues(alpha: 0.75)
                            : userColor.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Format: HH:MM (compact like TG/Instagram)
    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return timeStr;
  }
}
