import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/community/data/repositories/community_repository.dart';
import 'package:safe/features/community/domain/models/post.dart';

part 'community_provider.g.dart';

@riverpod
Stream<List<Post>> communityPostsStream(CommunityPostsStreamRef ref) {
  final repository = ref.watch(communityRepositoryProvider);
  return repository.getMessagesStream();
}

@riverpod
class CommunityNotifier extends _$CommunityNotifier {
  @override
  FutureOr<List<Post>> build() async {
    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    final repository = ref.read(communityRepositoryProvider);
    return repository.getPosts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPosts());
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

    // 2. Network Request
    try {
      final repository = ref.read(communityRepositoryProvider);
      final postToUpdate = currentPosts.firstWhere((p) => p.id == postId);
      await repository.toggleLike(postId, !postToUpdate.isLikedByMe);
    } catch (e, st) {
      // 3. Rollback on failure — restore posts, not a full error state
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

  /// Uploads a file to Firebase Storage.
  /// Returns the download URL on success, or null if Storage is unavailable.
  Future<String?> _uploadFile({
    required File file,
    required String storagePath,
  }) async {
    try {
      // Use backend API instead of Firebase Storage
      final apiClient = ref.read(apiClientProvider);
      
      // Create FormData for multipart upload
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      // Upload to backend
      final response = await apiClient.dio.post(
        '/uploads/community',
        data: formData,
      );

      // Extract URL from response
      final url = (response.data['data']?['url'] ?? response.data['url']) as String?;
      
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

  Future<void> addPost({
    required String message,
    File? imageFile,
    File? videoFile,
  }) async {
    // Capture current posts so we can restore on failure
    final previousPosts = state.valueOrNull ?? [];

    try {
      final repository = ref.read(communityRepositoryProvider);

      // Get real user info from auth state
      final authUser = ref.read(authNotifierProvider).valueOrNull;
      final userId =
          authUser?.id ?? 'anonymous_${const Uuid().v4().substring(0, 8)}';
      final userName = authUser != null
          ? '${authUser.firstName} ${authUser.lastName}'.trim()
          : 'Anonymous';

      // Upload media — failures are silently swallowed, post goes through without media
      String? uploadedImageUrl;
      String? uploadedVideoUrl;

      if (imageFile != null) {
        uploadedImageUrl = await _uploadFile(
          file: imageFile,
          storagePath:
              'community_posts/images/${const Uuid().v4()}.jpg',
        );
      }

      if (videoFile != null) {
        uploadedVideoUrl = await _uploadFile(
          file: videoFile,
          storagePath:
              'community_posts/videos/${const Uuid().v4()}.mp4',
        );
      }

      await repository.sendMessage(
        userId: userId,
        userName: userName,
        message: message,
        imageUrl: uploadedImageUrl,
        videoUrl: uploadedVideoUrl,
      );

      // Refresh feed after posting — errors here fall to catch below
      await refresh();
    } catch (e, st) {
      log.e('❌ addPost failed: $e', stackTrace: st);
      // Restore previous posts so the feed doesn't go blank
      // Re-throw so the UI can show a snackbar
      state = AsyncData(previousPosts);
      rethrow;
    }
  }
}
