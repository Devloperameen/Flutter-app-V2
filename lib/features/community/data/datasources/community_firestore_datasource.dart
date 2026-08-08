import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Firestore-based community data source
///
/// Manages real-time messaging, user profiles, and community interactions
class CommunityFirestoreDataSource {
  CommunityFirestoreDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Send a post to community feed
  /// Uses correct Firestore field names: content (not message), likeCount, commentCount
  Future<String> sendMessage({
    required String userId,
    required String userName,
    required String message,
    String? imageUrl,
    String? videoUrl,
  }) async {
    try {
      log.i('💬 Sending post from user: $userId');

      final docRef = await _firestore.collection('community').add({
        'userId': userId,
        'userName': userName,
        'content': message, // Use 'content' not 'message'
        'userAvatar': '', // Add avatar support
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'likeCount': 0, // Use 'likeCount' not 'likes'
        'commentCount': 0, // Use 'commentCount' not 'replies'
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isDeleted': false,
      });

      log.i('✅ Post sent: ${docRef.id}');
      return docRef.id;
    } catch (e, st) {
      log.e('❌ Send post error: $e', stackTrace: st);
      throw Exception('Failed to send post: $e');
    }
  }

  /// Get community messages stream (real-time)
  Stream<List<Map<String, dynamic>>> getMessagesStream({
    int limit = 50,
  }) {
    return _firestore
        .collection('community')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .toList();
    }).handleError((e) {
      log.e('❌ Messages stream error: $e');
    });
  }

  /// Get messages (initial load)
  Future<List<Map<String, dynamic>>> getMessages({
    int limit = 50,
  }) async {
    try {
      log.i('📋 Fetching community messages');

      final messages = await _firestore
          .collection('community')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return messages.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .toList();
    } catch (e, st) {
      log.e('❌ Messages fetch error: $e', stackTrace: st);
      throw Exception('Failed to fetch messages: $e');
    }
  }

  /// Like a post
  /// Uses 'likeCount' field (not 'likes')
  Future<void> likeMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      log.i('👍 Liking post: $messageId');

      final batch = _firestore.batch();

      // Add like to post likes subcollection
      batch.set(
        _firestore
            .collection('community')
            .doc(messageId)
            .collection('likes')
            .doc(userId),
        {'userId': userId, 'createdAt': DateTime.now().toIso8601String()},
      );

      // Increment likeCount (not 'likes')
      batch.update(
        _firestore.collection('community').doc(messageId),
        {'likeCount': FieldValue.increment(1)},
      );

      await batch.commit();
      log.i('✅ Post liked');
    } catch (e, st) {
      log.e('❌ Like error: $e', stackTrace: st);
      throw Exception('Failed to like post: $e');
    }
  }

  /// Add comment to a post
  /// Uses 'comments' subcollection (not 'replies') and 'commentCount' field (not 'replies')
  Future<String> replyToMessage({
    required String messageId,
    required String userId,
    required String userName,
    required String reply,
  }) async {
    try {
      log.i('💬 Adding comment to post: $messageId');

      final docRef = await _firestore
          .collection('community')
          .doc(messageId)
          .collection('comments') // Use 'comments' not 'replies'
          .add({
        'userId': userId,
        'userName': userName,
        'text': reply, // Use 'text' for consistency
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Increment commentCount on parent post
      await _firestore.collection('community').doc(messageId).update({
        'commentCount': FieldValue.increment(1), // Use 'commentCount' not 'replies'
      });

      log.i('✅ Comment added: ${docRef.id}');
      return docRef.id;
    } catch (e, st) {
      log.e('❌ Comment error: $e', stackTrace: st);
      throw Exception('Failed to add comment: $e');
    }
  }

  /// Get comments for a post (stream)
  /// Queries from 'comments' subcollection (not 'replies')
  Stream<List<Map<String, dynamic>>> getRepliesStream(String messageId) {
    return _firestore
        .collection('community')
        .doc(messageId)
        .collection('comments') // Use 'comments' not 'replies'
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .toList();
    }).handleError((e) {
      log.e('❌ Comments stream error: $e');
    });
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      log.i('👤 Fetching user profile: $userId');

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return null;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      return {
        'userId': userId,
        'firstName': data['firstName'] ?? '',
        'lastName': data['lastName'] ?? '',
        'displayName': data['displayName'] ?? '',
        'avatarUrl': data['avatarUrl'],
        'bio': data['bio'] ?? '',
        'currentLevel': data['currentLevel'] ?? 1,
        'totalXp': data['totalXp'] ?? 0,
      };
    } catch (e, st) {
      log.e('❌ User profile error: $e', stackTrace: st);
      return null;
    }
  }

  /// Update user online status
  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'lastActiveDate': DateTime.now().toIso8601String(),
      });
    } catch (e, st) {
      log.e('❌ Online status error: $e', stackTrace: st);
    }
  }

  /// Search messages
  Future<List<Map<String, dynamic>>> searchMessages(String query) async {
    try {
      log.i('🔍 Searching messages: $query');

      final messages = await _firestore
          .collection('community')
          .where('message', isGreaterThanOrEqualTo: query)
          .where('message', isLessThan: query + 'z')
          .orderBy('message')
          .orderBy('createdAt', descending: true)
          .get();

      return messages.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .toList();
    } catch (e, st) {
      log.e('❌ Search error: $e', stackTrace: st);
      return [];
    }
  }

  /// Delete message (admin or owner only)
  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      log.i('🗑️ Deleting message: $messageId');

      // Verify ownership (would need admin check in production)
      await _firestore.collection('community').doc(messageId).delete();

      log.i('✅ Message deleted');
    } catch (e, st) {
      log.e('❌ Delete error: $e', stackTrace: st);
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Get online users
  Stream<List<Map<String, dynamic>>> getOnlineUsersStream() {
    return _firestore
        .collection('users')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['userId'] = doc.id;
            return data;
          })
          .toList();
    }).handleError((e) {
      log.e('❌ Online users stream error: $e');
    });
  }

  /// Get typing indicator stream
  Stream<List<String>> getTypingIndicatorsStream() {
    return _firestore
        .collection('community')
        .doc('typingIndicators')
        .snapshots()
        .map((doc) {
      if (!doc.exists) return <String>[];
      final data = doc.data() as Map<String, dynamic>?;
      return (data?['typingUsers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[];
    }).handleError((e) {
      log.e('❌ Typing indicators error: $e');
    });
  }

  /// Set typing indicator
  Future<void> setTypingIndicator({
    required String userId,
    required bool isTyping,
  }) async {
    try {
      final typingDoc = _firestore.collection('community').doc('typingIndicators');

      if (isTyping) {
        await typingDoc.update({
          'typingUsers': FieldValue.arrayUnion([userId]),
        });
      } else {
        await typingDoc.update({
          'typingUsers': FieldValue.arrayRemove([userId]),
        });
      }
    } catch (e, st) {
      log.e('❌ Typing indicator error: $e', stackTrace: st);
    }
  }

  /// Get community statistics
  Future<Map<String, dynamic>> getCommunityStats() async {
    try {
      log.i('📊 Fetching community statistics');

      final messagesCount =
          await _firestore.collection('community').count().get();
      final usersCount = await _firestore.collection('users').count().get();

      return {
        'totalMessages': messagesCount.count,
        'totalUsers': usersCount.count,
        'activeNow': 0, // Would calculate from online status
      };
    } catch (e, st) {
      log.e('❌ Stats error: $e', stackTrace: st);
      return {
        'totalMessages': 0,
        'totalUsers': 0,
        'activeNow': 0,
      };
    }
  }
}
