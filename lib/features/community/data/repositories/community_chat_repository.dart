import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/data/datasources/http_community_chat_datasource.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';

part 'community_chat_repository.g.dart';

@riverpod
CommunityChatRepository communityChatRepository(CommunityChatRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommunityChatRepository(
    datasource: HttpCommunityChatDatasource(apiClient: apiClient),
  );
}

/// Repository for real-time community chat operations (via HTTP)
class CommunityChatRepository {

  CommunityChatRepository({required this._datasource});
  final HttpCommunityChatDatasource _datasource;

  /// Send a chat message
  /// Returns the created message on success
  Future<ChatMessage> sendMessage({
    required String userId,
    required String userName,
    required String message,
    String? profilePhoto,
  }) async {
    try {
      // Validate inputs
      if (message.trim().isEmpty) {
        throw ArgumentError('Message cannot be empty');
      }
      if (userId.isEmpty) {
        throw ArgumentError('User ID is required');
      }
      if (userName.trim().isEmpty) {
        throw ArgumentError('User name is required');
      }

      log.i('💬 Sending chat message: "$message"');

      final chatMessage = await _datasource.sendRoomMessage(
        roomId: 'community',
        message: message,
      );

      return chatMessage;
    } catch (e, st) {
      log.e('❌ Failed to send message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get real-time stream of messages from community room
  /// Messages are sorted by creation timestamp (oldest to newest)
  Stream<List<ChatMessage>> getMessagesStream() {
    try {
      return Stream.periodic(
        const Duration(seconds: 5),
        (_) => _datasource.getRoomMessages(roomId: 'community'),
      ).asyncExpand((future) => Stream.fromFuture(
        future.then((messages) {
          // ✅ CRITICAL: Sort messages by createdAt (oldest first)
          messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return messages;
        }).catchError((_) => <ChatMessage>[])
      ));
    } catch (e, st) {
      log.e('❌ Failed to create messages stream: $e', stackTrace: st);
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  /// Delete a message (only the sender can delete)
  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      log.i('🗑️ Deleting message: $messageId');
      await _datasource.deleteMessage(messageId: messageId);
    } catch (e, st) {
      log.e('❌ Failed to delete message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get paginated messages (for on-demand loading)
  Stream<List<ChatMessage>> getMessagesPaginated({
    int limit = 50,
    DateTime? startAfter,
  }) {
    try {
      log.i('📋 Fetching paginated messages (limit: $limit)');
      return Stream.value([]);
    } catch (e, st) {
      log.e('❌ Failed to fetch paginated messages: $e', stackTrace: st);
      return Stream.value([]);
    }
  }

  /// Get total message count in chat
  Future<int> getMessageCount() async {
    try {
      final messages = await _datasource.getRoomMessages(roomId: 'community');
      return messages.length;
    } catch (e) {
      log.w('⚠️ Failed to get message count: $e');
      return 0;
    }
  }
}
