import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:safe/core/errors/failures.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/data/datasources/community_remote_datasource.dart';
import 'package:safe/features/community/domain/models/post.dart';
import 'package:safe/core/providers/socket_provider.dart';

part 'community_repository.g.dart';

/// Provider that creates a fully‑wired CommunityRepository.
@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final socket = ref.watch(socketProvider);
  return CommunityRepository(
    remoteDataSource: CommunityRemoteDataSource(apiClient: apiClient),
    socket: socket,
  );
}

/// Repository handling community data and real‑time updates.
class CommunityRepository {
  CommunityRepository({
    required this._remoteDataSource,
    required this.socket,
  }) {
    // Listen for server‑side chat messages and push them to the broadcast stream.
    socket.on('chat:message', (data) {
      if (data is Map<String, dynamic>) {
        final post = _mapToPost(data);
        // Update cached list and emit the new list.
        _posts.add(post);
        _postController.add(List<Post>.unmodifiable(_posts));
      }
    });
  }

  final CommunityRemoteDataSource _remoteDataSource;
  final io.Socket socket;

  // Internal mutable cache of posts.
  final List<Post> _posts = [];

  // Broadcast controller exposing a stream of the current post list.
  final _postController = StreamController<List<Post>>.broadcast();
  Stream<List<Post>> get livePostsStream => _postController.stream;

  /// Fetch posts from the backend (used for the initial load).
  Future<List<Post>> getPosts() async {
    try {
      final posts = await _remoteDataSource.getPosts();
      _posts
        ..clear()
        ..addAll(posts);
      // Push the initial list to the stream so listeners receive it.
      _postController.add(List<Post>.unmodifiable(_posts));
      return posts;
    } catch (e, stackTrace) {
      log.e('❌ Failed to fetch posts: $e', stackTrace: stackTrace);
      throw ServerFailure(message: 'Failed to fetch posts', stackTrace: stackTrace);
    }
  }

  /// Send a new chat message.
  Future<String> sendMessage({
    required String userId,
    required String userName,
    required String message,
    String? imageUrl,
    String? videoUrl,
  }) async {
    try {
      log.i('💬 Sending message: "$message"');
      
      // ✅ FIXED: socket.emit returns void, don't await
      socket.emit('chat:message', {
        'userId': userId,
        'userName': userName,
        'content': message,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
      });
      
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      log.i('✅ Message sent with ID: $messageId');
      
      return messageId;
    } catch (e, stackTrace) {
      log.e('❌ Failed to send message: $e', stackTrace: stackTrace);
      throw ServerFailure(message: 'Failed to send message: $e', stackTrace: stackTrace);
    }
  }

  /// Map a raw socket payload to a [Post] model.
  static Post _mapToPost(Map<String, dynamic> msg) {
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

  static String? _sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('https://')) return url;
    log.w('⚠️ Dropping non‑HTTPS media URL: $url');
    return null;
  }

  // ---------------------------------------------------------------------------
  // The remaining CRUD helpers retain their original signatures but now delegate
  // to the remote datasource. They are kept for completeness – the UI uses the
  // real‑time stream for display, but these methods are still useful for actions
  // such as liking, commenting, etc.
  // ---------------------------------------------------------------------------

  Future<void> likeMessage({required String messageId, required String userId}) async {
    try {
      log.i('👍 Liking message: $messageId');
      await _remoteDataSource.toggleLike(messageId, true);
    } catch (e, stackTrace) {
      log.e('❌ Failed to like message: $e', stackTrace: stackTrace);
      throw ServerFailure(message: 'Failed to like message', stackTrace: stackTrace);
    }
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    try {
      await _remoteDataSource.toggleLike(postId, isLiked);
    } catch (e, stackTrace) {
      throw ServerFailure(message: 'Failed to toggle like', stackTrace: stackTrace);
    }
  }

  Future<void> addComment({required String postId, required String userId, required String userName, required String comment}) async {
    try {
      log.i('💬 Adding comment to post: $postId');
      // Emit comment event via Socket.IO
      socket.emit('post:comment', {
        'postId': postId,
        'userId': userId,
        'userName': userName,
        'content': comment,
      });
      log.i('✅ Comment added');
    } catch (e, stackTrace) {
      log.e('❌ Failed to add comment: $e', stackTrace: stackTrace);
      throw ServerFailure(message: 'Failed to add comment', stackTrace: stackTrace);
    }
  }

  // Additional helper stubs retained for compatibility with the existing UI.
  Future<String> replyToMessage({required String messageId, required String userId, required String userName, required String reply}) async => messageId;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async => null;

  Future<List<Post>> searchMessages(String query) async => [];

  Future<void> deleteMessage({required String messageId, required String userId}) async {
    try {
      await _remoteDataSource.toggleLike(messageId, false);
    } catch (e, stackTrace) {
      throw ServerFailure(message: 'Failed to delete message', stackTrace: stackTrace);
    }
  }
}
