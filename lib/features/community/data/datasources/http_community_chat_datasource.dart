/// ============================================
/// HTTP Community Chat Datasource
/// ============================================
/// 
/// Connects to Express.js backend via HTTP
/// Handles direct & group messaging
/// 
/// Features:
/// - Direct 1-on-1 messaging
/// - Group room-based chat
/// - Unread message tracking
/// - Emoji reactions

import 'package:dio/dio.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';

/// HTTP-based implementation of community chat datasource
class HttpCommunityChatDatasource {
  final ApiClient apiClient;

  HttpCommunityChatDatasource({required this.apiClient});

  // ─── Direct Messaging ───────────────────────────

  /// Send direct message to another user
  /// 
  /// @param receiverId: ID of user to send message to
  /// @param message: Message text
  /// @returns: Created message object
  Future<ChatMessage> sendDirectMessage({
    required String receiverId,
    required String message,
    List<String>? attachmentUrls,
  }) async {
    try {
      log.i('💬 Sending direct message to $receiverId');

      final response = await apiClient.post(
        ApiEndpoints.messages,
        data: {
          'receiverId': receiverId,
          'message': message,
          'attachments': attachmentUrls ?? [],
        },
      );

      final messageData = response['data'] as Map<String, dynamic>;
      final chatMessage = ChatMessage.fromJson(messageData);

      log.i('✅ Direct message sent');
      return chatMessage;
    } on DioException catch (e) {
      log.e('❌ Dio error sending message: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error sending direct message: $e');
      rethrow;
    }
  }

  /// Get direct message conversation with another user
  /// 
  /// @param userId: ID of other user
  /// @param limit: Max messages to fetch (default: 50)
  /// @param page: Page number for pagination (default: 1)
  /// @returns: List of messages in conversation
  Future<List<ChatMessage>> getConversation({
    required String userId,
    int limit = 50,
    int page = 1,
  }) async {
    try {
      log.i('🔍 Fetching conversation with $userId');

      final response = await apiClient.get(
        ApiEndpoints.conversation(userId),
        queryParameters: {
          'limit': limit,
          'page': page,
        },
      );

      final messagesList = response['data']['messages'] as List;
      final messages = messagesList
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList();

      log.i('✅ Fetched ${messages.length} messages');
      return messages;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching conversation: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching conversation: $e');
      rethrow;
    }
  }

  // ─── Group Chat (Room-based) ──────────────────────

  /// Send message to a group room
  /// 
  /// @param roomId: Room identifier (e.g., "community", "general")
  /// @param message: Message text
  /// @returns: Created message object
  Future<ChatMessage> sendRoomMessage({
    required String roomId,
    required String message,
    List<String>? attachmentUrls,
  }) async {
    try {
      log.i('💬 Sending room message to $roomId');

      final response = await apiClient.post(
        ApiEndpoints.roomMessages(roomId),
        data: {
          'message': message,
          'attachments': attachmentUrls ?? [],
        },
      );

      final messageData = response['data'] as Map<String, dynamic>;
      final chatMessage = ChatMessage.fromJson(messageData);

      log.i('✅ Room message sent');
      return chatMessage;
    } on DioException catch (e) {
      log.e('❌ Dio error sending room message: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error sending room message: $e');
      rethrow;
    }
  }

  /// Get messages from a group room
  /// 
  /// @param roomId: Room identifier
  /// @param limit: Max messages (default: 50)
  /// @param page: Page number (default: 1)
  /// @returns: List of room messages
  Future<List<ChatMessage>> getRoomMessages({
    required String roomId,
    int limit = 50,
    int page = 1,
  }) async {
    try {
      log.i('🔍 Fetching room messages from $roomId');

      final response = await apiClient.get(
        ApiEndpoints.roomMessages(roomId),
        queryParameters: {
          'limit': limit,
          'page': page,
        },
      );

      final messagesList = response['data'] as List;
      final messages = messagesList
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList();

      log.i('✅ Fetched ${messages.length} room messages');
      return messages;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching room messages: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching room messages: $e');
      rethrow;
    }
  }

  // ─── Unread Messages ────────────────────────────

  /// Get count of unread messages
  /// 
  /// @returns: Number of unread messages for current user
  Future<int> getUnreadCount() async {
    try {
      log.i('📬 Fetching unread message count');

      final response = await apiClient.get(ApiEndpoints.unreadCount);
      final unreadCount = response['data']['unreadCount'] as int;

      log.i('✅ Unread count: $unreadCount');
      return unreadCount;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching unread count: ${e.message}');
      return 0;
    } catch (e) {
      log.e('❌ Error fetching unread count: $e');
      return 0;
    }
  }

  /// Get list of all unread messages
  /// 
  /// @returns: List of unread messages
  Future<List<ChatMessage>> getUnreadMessages() async {
    try {
      log.i('📨 Fetching unread messages');

      final response = await apiClient.get(ApiEndpoints.unreadMessages);
      final messagesList = response['data'] as List;
      
      final messages = messagesList
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList();

      log.i('✅ Fetched ${messages.length} unread messages');
      return messages;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching unread messages: ${e.message}');
      return [];
    } catch (e) {
      log.e('❌ Error fetching unread messages: $e');
      return [];
    }
  }

  // ─── Reactions ──────────────────────────────────

  /// Add emoji reaction to a message
  /// 
  /// @param messageId: Message to react to
  /// @param emoji: Emoji character (e.g., "👍", "❤️", "😂")
  Future<void> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      log.i('😊 Adding reaction $emoji to message $messageId');

      await apiClient.post(
        '${ApiEndpoints.messages}/$messageId/reactions',
        data: {'emoji': emoji},
      );

      log.i('✅ Reaction added');
    } on DioException catch (e) {
      log.e('❌ Dio error adding reaction: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error adding reaction: $e');
      rethrow;
    }
  }

  /// Remove emoji reaction from a message
  /// 
  /// @param messageId: Message to remove reaction from
  /// @param emoji: Emoji to remove
  Future<void> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      log.i('😔 Removing reaction $emoji from message $messageId');

      await apiClient.delete(
        '${ApiEndpoints.messages}/$messageId/reactions/$emoji',
      );

      log.i('✅ Reaction removed');
    } on DioException catch (e) {
      log.e('❌ Dio error removing reaction: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error removing reaction: $e');
      rethrow;
    }
  }

  // ─── Message Management ────────────────────────

  /// Delete a message
  /// 
  /// Only the sender can delete their own messages
  /// 
  /// @param messageId: Message to delete
  Future<void> deleteMessage({required String messageId}) async {
    try {
      log.i('🗑️ Deleting message $messageId');

      await apiClient.delete(
        '${ApiEndpoints.messages}/$messageId',
      );

      log.i('✅ Message deleted');
    } on DioException catch (e) {
      log.e('❌ Dio error deleting message: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error deleting message: $e');
      rethrow;
    }
  }
}
