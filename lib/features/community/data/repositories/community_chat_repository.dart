import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/data/datasources/community_chat_firestore_datasource.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';

part 'community_chat_repository.g.dart';

@riverpod
CommunityChatRepository communityChatRepository(CommunityChatRepositoryRef ref) {
  return CommunityChatRepository();
}

/// Repository for real-time community chat operations
class CommunityChatRepository {
  final CommunityChatFirestoreDataSource _datasource;

  CommunityChatRepository({CommunityChatFirestoreDataSource? datasource})
      : _datasource = datasource ?? CommunityChatFirestoreDataSource();

  /// Send a chat message
  /// Returns the message ID on success
  Future<String> sendMessage({
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

      final messageId = await _datasource.sendMessage(
        userId: userId,
        userName: userName,
        message: message,
        profilePhoto: profilePhoto,
      );

      return messageId;
    } catch (e, st) {
      log.e('❌ Failed to send message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get real-time stream of messages
  /// Messages are ordered by creation timestamp (oldest to newest)
  Stream<List<ChatMessage>> getMessagesStream() {
    try {
      return _datasource.getMessagesStream();
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
      await _datasource.deleteMessage(messageId: messageId, userId: userId);
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
      log.i('📋 Fetching paginated messages (limit: $limit)');
      return await _datasource.getMessagesPaginated(
        limit: limit,
        startAfter: startAfter,
      );
    } catch (e, st) {
      log.e('❌ Failed to fetch paginated messages: $e', stackTrace: st);
      return [];
    }
  }

  /// Get total message count in chat
  Future<int> getMessageCount() async {
    try {
      return await _datasource.getMessageCount();
    } catch (e) {
      log.w('⚠️ Failed to get message count: $e');
      return 0;
    }
  }
}
