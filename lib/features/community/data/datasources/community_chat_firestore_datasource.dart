import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/domain/models/chat_message.dart';

/// Firestore datasource for real-time community chat
class CommunityChatFirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _messagesCollection = 'community_chat';
  static const String _messagesSubcollection = 'messages';

  /// Send a chat message to Firestore
  Future<String> sendMessage({
    required String userId,
    required String userName,
    required String message,
    String? profilePhoto,
  }) async {
    try {
      log.i('💬 Sending chat message to Firestore');

      // Validate required fields
      if (message.trim().isEmpty) {
        throw ArgumentError('Message cannot be empty');
      }
      if (userId.isEmpty) {
        throw ArgumentError('User ID is required');
      }

      final docRef = _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection(_messagesSubcollection)
          .doc();

      await docRef.set({
        'userId': userId,
        'userName': userName,
        'profilePhoto': profilePhoto,
        'message': message.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      log.i('✅ Message sent: ${docRef.id}');
      return docRef.id;
    } catch (e, st) {
      log.e('❌ Failed to send message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get real-time stream of chat messages (ordered by timestamp)
  Stream<List<ChatMessage>> getMessagesStream() {
    log.i('💬 Opening real-time messages stream');

    try {
      return _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection(_messagesSubcollection)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        log.i('📨 Received ${snapshot.docs.length} messages from Firestore');
        
        return snapshot.docs.map((doc) {
          try {
            return ChatMessage.fromFirestore(doc.data(), doc.id);
          } catch (e) {
            log.w('⚠️ Failed to parse message ${doc.id}: $e');
            return ChatMessage(
              id: doc.id,
              userId: '',
              userName: 'Error loading message',
              message: 'Failed to load',
              createdAt: DateTime.now(),
            );
          }
        }).toList();
      }).handleError((error) {
        log.e('❌ Stream error: $error');
      });
    } catch (e, st) {
      log.e('❌ Failed to create stream: $e', stackTrace: st);
      return Stream.value([]);
    }
  }

  /// Delete a chat message (only by sender or admin)
  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      log.i('🗑️ Deleting message: $messageId');

      final msgDoc = await _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection(_messagesSubcollection)
          .doc(messageId)
          .get();

      if (!msgDoc.exists) {
        throw Exception('Message not found');
      }

      final msgData = msgDoc.data() as Map<String, dynamic>;
      if (msgData['userId'] != userId) {
        throw Exception('Only message sender can delete');
      }

      await msgDoc.reference.delete();
      log.i('✅ Message deleted');
    } catch (e, st) {
      log.e('❌ Failed to delete message: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get paginated messages
  Future<List<ChatMessage>> getMessagesPaginated({
    int limit = 50,
    DateTime? startAfter,
  }) async {
    try {
      log.i('📋 Fetching paginated messages');

      Query query = _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection(_messagesSubcollection)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfter([startAfter.toIso8601String()]);
      }

      final snapshot = await query.get();

      final messages = snapshot.docs.map((doc) {
        try {
          return ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        } catch (e) {
          log.w('⚠️ Failed to parse message ${doc.id}: $e');
          return ChatMessage(
            id: doc.id,
            userId: '',
            userName: 'Error',
            message: 'Failed to load',
            createdAt: DateTime.now(),
          );
        }
      }).toList();

      return messages;
    } catch (e, st) {
      log.e('❌ Failed to fetch paginated messages: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get total message count
  Future<int> getMessageCount() async {
    try {
      final snapshot = await _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection(_messagesSubcollection)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      log.w('⚠️ Failed to get message count: $e');
      return 0;
    }
  }

  /// Listen to typing indicator
  Stream<Map<String, dynamic>> getTypingIndicatorStream() {
    try {
      return _firestore
          .collection(_messagesCollection)
          .doc('main')
          .collection('typingIndicators')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.fold({}, (prev, doc) {
          prev[doc.id] = doc.data();
          return prev;
        });
      });
    } catch (e) {
      log.e('❌ Typing indicator stream error: $e');
      return Stream.value({});
    }
  }
}
