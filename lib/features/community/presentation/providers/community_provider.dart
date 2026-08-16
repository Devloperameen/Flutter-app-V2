import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/community/data/repositories/community_repository.dart';
import 'package:safe/features/community/domain/models/post.dart';
import 'package:uuid/uuid.dart';

part 'community_provider.g.dart';

/// Stream provider for backward compatibility — UI screens that use
/// `communityPostsStreamProvider` will get real‑time updates from
/// the repository's broadcast stream.
@riverpod
Stream<List<Post>> communityPostsStream(CommunityPostsStreamRef ref) async* {
  final repository = ref.watch(communityRepositoryProvider);
  
  // ✅ Load initial posts before streaming
  try {
    final initialPosts = await repository.getPosts();
    yield initialPosts;
    log.i('✅ Initial posts loaded: ${initialPosts.length}');
  } catch (e) {
    log.e('❌ Failed to load initial posts: $e');
    yield [];
  }
  
  // Then stream updates from Socket.IO
  yield* repository.livePostsStream.map((posts) {
    log.i('📡 Stream update: ${posts.length} posts');
    return posts;
  });
}

@Riverpod(keepAlive: true)
class CommunityNotifier extends _$CommunityNotifier {
  @override
  FutureOr<List<Post>> build() async {
    final repo = ref.read(communityRepositoryProvider);
    // Load initial posts from the REST endpoint.
    final initial = await repo.getPosts();
    // Subscribe to real‑time updates from Socket.IO.
    repo.livePostsStream.listen((list) {
      if (state.value != list) {
        state = AsyncData(list);
      }
    });
    return initial;
  }

  Future<List<Post>> _fetchPosts() async {
    final repository = ref.read(communityRepositoryProvider);
    return repository.getPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPosts);
  }

  Future<void> toggleLike(String postId) async {
    final previousState = state;
    if (state.value == null) return;

    final currentPosts = state.value!;

    // 1. Optimistic update
    final updatedPosts = currentPosts.map((post) {
      if (post.id == postId) {
        final newIsLiked = !post.isLikedByMe;
        return post.copyWith(
          isLikedByMe: newIsLiked,
          likeCount: newIsLiked ? post.likeCount + 1 : post.likeCount - 1,
        );
      }
      return post;
    }).toList();

    state = AsyncData(updatedPosts);

    // 2. Network request
    try {
      final repository = ref.read(communityRepositoryProvider);
      final postToUpdate = currentPosts.firstWhere((p) => p.id == postId);
      await repository.toggleLike(postId, !postToUpdate.isLikedByMe);
    } catch (e) {
      // 3. Rollback on failure
      state = previousState;
    }
  }

  /// Add a comment to a post
  Future<void> addComment(String postId, String comment) async {
    try {
      final repository = ref.read(communityRepositoryProvider);
      final authUser = ref.read(authNotifierProvider).valueOrNull;
      final userId =
          authUser?.id ?? 'anonymous_${const Uuid().v4().substring(0, 8)}';
      final userName = authUser != null
          ? '${authUser.firstName} ${authUser.lastName}'.trim()
          : 'Anonymous';

      await repository.addComment(
        postId: postId,
        userId: userId,
        userName: userName,
        comment: comment,
      );

      // Refresh posts to show updated comment count
      await refresh();
    } catch (e, st) {
      log.e('❌ addComment failed: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Upload a file to the Express backend.
  /// Returns the download URL on success, or null on failure.
  Future<String?> _uploadFile({
    required File file,
    required String storagePath,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      // ✅ FIXED: Use correct upload endpoints
      final fileName = file.path.split('/').last.toLowerCase();
      final isImage = fileName.endsWith('.jpg') || 
                      fileName.endsWith('.jpeg') || 
                      fileName.endsWith('.png') ||
                      fileName.endsWith('.webp') ||
                      fileName.endsWith('.gif');
      final uploadEndpoint = isImage ? '/uploads/post-image' : '/uploads/post-video';

      final response = await apiClient.dio.post(
        uploadEndpoint,
        data: formData,
      );

      final url =
          (response.data['data']?['url'] ?? response.data['url']) as String?;

      if (url != null) {
        log.i('✅ Media uploaded: $url');
        return url;
      } else {
        log.w('⚠️ Upload response missing URL');
        return null;
      }
    } catch (e) {
      log.w('⚠️ Media upload failed: $e');
      return null;
    }
  }

  /// Create a new post with optional media.
  Future<void> addPost({
    required String message,
    File? imageFile,
    File? videoFile,
  }) async {
    final previousPosts = state.valueOrNull ?? [];

    try {
      final repository = ref.read(communityRepositoryProvider);

      final authUser = ref.read(authNotifierProvider).valueOrNull;
      final userId =
          authUser?.id ?? 'anonymous_${const Uuid().v4().substring(0, 8)}';
      final userName = authUser != null
          ? '${authUser.firstName} ${authUser.lastName}'.trim()
          : 'Anonymous';

      String? uploadedImageUrl;
      String? uploadedVideoUrl;

      if (imageFile != null) {
        uploadedImageUrl = await _uploadFile(
          file: imageFile,
          storagePath: 'community_posts/images/${const Uuid().v4()}.jpg',
        );
      }

      if (videoFile != null) {
        uploadedVideoUrl = await _uploadFile(
          file: videoFile,
          storagePath: 'community_posts/videos/${const Uuid().v4()}.mp4',
        );
      }

      await repository.sendMessage(
        userId: userId,
        userName: userName,
        message: message,
        imageUrl: uploadedImageUrl,
        videoUrl: uploadedVideoUrl,
      );

      // ✅ FIXED: Wait a bit for Socket.IO event, then force refresh from backend
      await Future.delayed(const Duration(milliseconds: 500));
      await refresh();
    } catch (e, st) {
      log.e('❌ addPost failed: $e', stackTrace: st);
      state = AsyncData(previousPosts);
      rethrow;
    }
  }
}
