import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/community/data/repositories/community_chat_repository.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';

part 'chat_provider.g.dart';

/// Stream provider for real-time chat messages
@riverpod
Stream<List<ChatMessage>> chatMessagesStream(ChatMessagesStreamRef ref) {
  final repository = ref.watch(communityChatRepositoryProvider);
  return repository.getMessagesStream();
}

/// Notifier for chat operations (send, delete, etc.)
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<void> build() {
    // Initial state - empty
  }

  /// Send a chat message
  Future<void> sendMessage(String message) async {
    try {
      // Validate message
      if (message.trim().isEmpty) {
        throw ArgumentError('Message cannot be empty');
      }

      // Get current user
      final authState = ref.read(authNotifierProvider);
      final currentUser = authState.valueOrNull;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final userId = currentUser.id;
      final userName = '${currentUser.firstName} ${currentUser.lastName}'.trim();
      final profilePhoto = currentUser.avatarUrl;

      log.i('💬 Sending message: "$message"');

      // Get repository and send message
      final repository = ref.read(communityChatRepositoryProvider);
      await repository.sendMessage(
        userId: userId,
        userName: userName,
        message: message.trim(),
        profilePhoto: profilePhoto,
      );

      log.i('✅ Message sent successfully');
    } catch (e, st) {
      log.e('❌ Failed to send message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Delete a chat message (only if current user is sender)
  Future<void> deleteMessage(String messageId) async {
    try {
      // Get current user
      final authState = ref.read(authNotifierProvider);
      final currentUser = authState.valueOrNull;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      log.i('🗑️ Deleting message: $messageId');

      final repository = ref.read(communityChatRepositoryProvider);
      await repository.deleteMessage(
        messageId: messageId,
        userId: currentUser.id,
      );

      log.i('✅ Message deleted successfully');

      // Refresh messages stream by invalidating it
      ref.invalidate(chatMessagesStreamProvider);
    } catch (e, st) {
      log.e('❌ Failed to delete message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get paginated messages (for on-demand loading)
  Future<List<ChatMessage>> getMessagesPaginated({
    int limit = 50,
    DateTime? startAfter,
  }) async {
    try {
      log.i('📋 Fetching paginated messages');

      final repository = ref.read(communityChatRepositoryProvider);
      final stream = repository.getMessagesPaginated(
        limit: limit,
        startAfter: startAfter,
      );
      
      // Convert stream to future by taking first element
      return await stream.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => [],
      );
    } catch (e, st) {
      log.e('❌ Failed to fetch paginated messages: $e', stackTrace: st);
      return [];
    }
  }

  /// Get total message count
  Future<int> getMessageCount() async {
    try {
      final repository = ref.read(communityChatRepositoryProvider);
      return await repository.getMessageCount();
    } catch (e) {
      log.w('⚠️ Failed to get message count: $e');
      return 0;
    }
  }
}

/// Notifier for managing current user info for chat
@riverpod
class ChatUserInfoNotifier extends _$ChatUserInfoNotifier {
  @override
  FutureOr<({String userId, String userName, String? profilePhoto})?>
      build() async {
    // Get current user from auth
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.valueOrNull;

    if (currentUser == null) {
      return null;
    }

    return (
      userId: currentUser.id,
      userName: '${currentUser.firstName} ${currentUser.lastName}'.trim(),
      profilePhoto: currentUser.avatarUrl,
    );
  }
}
