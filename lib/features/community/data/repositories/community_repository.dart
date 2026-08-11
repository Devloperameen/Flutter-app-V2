import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/errors/failures.dart';
import 'package:safe/features/community/data/datasources/community_remote_datasource.dart';
import 'package:safe/features/community/domain/models/post.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/providers/core_providers.dart';

part 'community_repository.g.dart';

@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommunityRepository(
    remoteDataSource: CommunityRemoteDataSource(apiClient: apiClient),
  );
}

class CommunityRepository {
  CommunityRepository({
    required CommunityRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CommunityRemoteDataSource _remoteDataSource;

  /// Maps a raw message map to a [Post].
  /// Media URLs are passed through as-is — the UI's Image.network errorBuilder
  /// handles any broken/missing URLs gracefully without crashing the feed.
  static Post _mapToPost(Map<String, dynamic> msg) {
    // Handle DateTime conversion
    DateTime parseCreatedAt(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return Post(
      id: (msg['id'] ?? '') as String,
      authorId: (msg['userId'] ?? msg['authorId'] ?? '') as String,
      authorName: (msg['userName'] ?? msg['authorName'] ?? 'Unknown') as String,
      authorRole: (msg['authorRole'] ?? 'Member') as String,
      content: (msg['content'] ?? msg['message'] ?? '') as String,
      likeCount: ((msg['likeCount'] ?? msg['likes'] ?? 0) as num).toInt(),
      commentCount: ((msg['commentCount'] ?? msg['replies'] ?? 0) as num).toInt(),
      createdAt: parseCreatedAt(msg['createdAt']),
      isLikedByMe: (msg['isLikedByMe'] ?? false) as bool,
      imageUrl: _sanitizeUrl(msg['imageUrl'] as String?),
      videoUrl: _sanitizeUrl(msg['videoUrl'] as String?),
    );
  }

  /// Returns [url] if it is an HTTPS URL, otherwise null.
  static String? _sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('https://')) return url;
    log.w('⚠️ Dropping non-HTTPS media URL: $url');
    return null;
  }

  /// Get community posts/messages (from Express.js backend)
  Future<List<Post>> getPosts() async {
    try {
      log.i('📋 Fetching community posts');
      final messages = await _remoteDataSource.getMessages();

      final posts = messages.map((msg) {
        try {
          return _mapToPost(msg);
        } catch (e) {
          log.w('⚠️ Skipping post ${msg['id']} due to mapping error: $e');
          return Post(
            id: (msg['id'] ?? '') as String,
            authorId: (msg['userId'] ?? msg['authorId'] ?? '') as String,
            authorName: (msg['userName'] ?? msg['authorName'] ?? 'Unknown') as String,
            authorRole: (msg['authorRole'] ?? 'Member') as String,
            content: (msg['message'] ?? msg['content'] ?? '') as String,
            likeCount: ((msg['likes'] ?? msg['likeCount'] ?? 0) as num).toInt(),
            commentCount: ((msg['replies'] ?? msg['commentCount'] ?? 0) as num).toInt(),
            createdAt: DateTime.tryParse((msg['createdAt'] ?? '') as String) ?? DateTime.now(),
            isLikedByMe: (msg['isLikedByMe'] ?? false) as bool,
            imageUrl: msg['imageUrl'] as String?,
            videoUrl: msg['videoUrl'] as String?,
          );
        }
      }).toList();

      return posts;
    } catch (e, stackTrace) {
      log.e('❌ Failed to fetch posts: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to fetch posts',
        stackTrace: stackTrace,
      );
    }
  }

  /// Send a new message
  Future<String> sendMessage({
    required String userId,
    required String userName,
    required String message,
    String? imageUrl,
    String? videoUrl,
  }) async {
    try {
      log.i('💬 Sending message');
      return await _remoteDataSource.sendMessage(
        userId: userId,
        userName: userName,
        message: message,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );
    } catch (e, stackTrace) {
      log.e('❌ Failed to send message: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to send message',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get real-time messages stream
  Stream<List<Post>> getMessagesStream() {
    return _remoteDataSource
        .getMessagesStream()
        .handleError((error) {
          log.e('❌ Stream error: $error');
        })
        .map((messages) {
          final posts = messages.map((msg) {
            try {
              return _mapToPost(msg);
            } catch (e) {
              log.w('⚠️ Skipping post ${msg['id']} in stream: $e');
              return Post(
                id: (msg['id'] ?? '') as String,
                authorId: (msg['userId'] ?? msg['authorId'] ?? '') as String,
                authorName: (msg['userName'] ?? msg['authorName'] ?? 'Unknown') as String,
                authorRole: (msg['authorRole'] ?? 'Member') as String,
                content: (msg['message'] ?? msg['content'] ?? '') as String,
                likeCount: ((msg['likes'] ?? msg['likeCount'] ?? 0) as num).toInt(),
                commentCount: ((msg['replies'] ?? msg['commentCount'] ?? 0) as num).toInt(),
                createdAt: DateTime.tryParse((msg['createdAt'] ?? '') as String) ?? DateTime.now(),
                isLikedByMe: (msg['isLikedByMe'] ?? false) as bool,
                imageUrl: msg['imageUrl'] as String?,
                videoUrl: msg['videoUrl'] as String?,
              );
            }
          }).toList();
          return posts;
        });
  }

  /// Like a message
  Future<void> likeMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      log.i('👍 Liking message: $messageId');
      await _remoteDataSource.likeMessage(messageId: messageId, userId: userId);
    } catch (e, stackTrace) {
      log.e('❌ Failed to like message: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to like message',
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggle like on post (legacy method)
  Future<void> toggleLike(String postId, bool isLiked) async {
    try {
      if (isLiked) {
        // Handled by likeMessage method
      }
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: 'Failed to like post',
        stackTrace: stackTrace,
      );
    }
  }

  /// Add a comment to a post
  Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String comment,
  }) async {
    try {
      log.i('💬 Adding comment to post: $postId');
      await _remoteDataSource.addComment(
        postId: postId,
        userId: userId,
        userName: userName,
        comment: comment,
      );
    } catch (e, stackTrace) {
      log.e('❌ Failed to add comment: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to add comment',
        stackTrace: stackTrace,
      );
    }
  }

  /// Reply to a message
  Future<String> replyToMessage({
    required String messageId,
    required String userId,
    required String userName,
    required String reply,
  }) async {
    try {
      log.i('💬 Replying to message');
      return await _remoteDataSource.replyToMessage(
        messageId: messageId,
        userId: userId,
        userName: userName,
        reply: reply,
      );
    } catch (e, stackTrace) {
      log.e('❌ Failed to reply: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to reply',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get replies for a message (stream)
  Stream<List<Map<String, dynamic>>> getRepliesStream(String messageId) {
    return _remoteDataSource.getRepliesStream(messageId).handleError((e) {
      log.e('❌ Replies stream error: $e');
      return <Map<String, dynamic>>[];
    });
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      return await _remoteDataSource.getUserProfile(userId);
    } catch (e) {
      log.e('❌ Failed to fetch user profile: $e');
      return null;
    }
  }

  /// Search messages
  Future<List<Post>> searchMessages(String query) async {
    try {
      log.i('🔍 Searching messages');
      final messages = await _remoteDataSource.searchMessages(query);

      final posts = messages.map((msg) {
        try {
          return _mapToPost(msg);
        } catch (e) {
          log.w('⚠️ Skipping search result ${msg['id']}: $e');
          return Post(
            id: (msg['id'] ?? '') as String,
            authorId: (msg['userId'] ?? msg['authorId'] ?? '') as String,
            authorName: (msg['userName'] ?? msg['authorName'] ?? 'Unknown') as String,
            authorRole: (msg['authorRole'] ?? 'Member') as String,
            content: (msg['message'] ?? msg['content'] ?? '') as String,
            likeCount: ((msg['likes'] ?? msg['likeCount'] ?? 0) as num).toInt(),
            commentCount: ((msg['replies'] ?? msg['commentCount'] ?? 0) as num).toInt(),
            createdAt: DateTime.tryParse((msg['createdAt'] ?? '') as String) ?? DateTime.now(),
            isLikedByMe: false,
            imageUrl: msg['imageUrl'] as String?,
            videoUrl: msg['videoUrl'] as String?,
          );
        }
      }).toList();
      return posts;
    } catch (e, stackTrace) {
      log.e('❌ Search error: $e', stackTrace: stackTrace);
      return [];
    }
  }

  /// Delete message
  Future<void> deleteMessage({
    required String messageId,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.deleteMessage(messageId: messageId, userId: userId);
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: 'Failed to delete message',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get online users stream
  Stream<List<Map<String, dynamic>>> getOnlineUsersStream() {
    return _remoteDataSource.getOnlineUsersStream().handleError((e) {
      log.e('❌ Online users stream error: $e');
      return <Map<String, dynamic>>[];
    });
  }

  /// Get community statistics
  Future<Map<String, dynamic>> getCommunityStats() async {
    try {
      return await _remoteDataSource.getCommunityStats();
    } catch (e) {
      return {
        'totalMessages': 0,
        'totalUsers': 0,
        'activeNow': 0,
      };
    }
  }
}
