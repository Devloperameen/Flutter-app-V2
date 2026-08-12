import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/network/api_response.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/community/domain/models/post.dart';

part 'community_remote_datasource.g.dart';

@riverpod
CommunityRemoteDataSource communityRemoteDataSource(CommunityRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommunityRemoteDataSource(apiClient: apiClient);
}

class CommunityRemoteDataSource {
  CommunityRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<List<Post>> getPosts() async {
    final response = await apiClient.dio.get(ApiEndpoints.posts);
    
    log.d('Posts response status: ${response.statusCode}');
    log.d('Posts response data: ${response.data}');
    
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as List<dynamic>,
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      try {
        final posts = apiResponse.data!
            .map((json) {
              final postMap = Map<String, dynamic>.from(json as Map);
              _sanitizePostData(postMap);
              return Post.fromJson(postMap);
            })
            .toList();
        
        log.i('✅ Fetched ${posts.length} posts');
        return posts;
      } catch (e) {
        log.e('❌ Error parsing posts: $e');
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Error parsing posts: $e',
        );
      }
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to fetch posts',
    );
  }

  /// Sanitize post data from backend response
  void _sanitizePostData(Map<String, dynamic> data) {
    // Handle MongoDB _id
    if (data['_id'] != null && data['id'] == null) {
      data['id'] = data['_id'].toString();
    }
    if (data['id'] == null) data['id'] = '';
    
    // Ensure required fields
    if (data['content'] == null) data['content'] = '';
    if (data['authorName'] == null) data['authorName'] = 'Unknown';
    if (data['authorId'] == null) data['authorId'] = '';
    
    // Ensure timestamps
    if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now().toIso8601String();
    }
    
    // Numeric fields
    if (data['likeCount'] != null && data['likeCount'] is! num) {
      data['likeCount'] = int.tryParse(data['likeCount'].toString()) ?? 0;
    }
    
    // Default empty lists
    if (data['comments'] == null) data['comments'] = [];
    if (data['likes'] == null) data['likes'] = [];
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.postLikes(postId),
      data: {'like': isLiked},
    );
    final apiResponse = ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {},
    );
    
    if (!apiResponse.success) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.error?.message ?? 'Failed to toggle like',
      );
    }
  }
}
