import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/network/api_response.dart';
import 'package:safe/core/providers/core_providers.dart';
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
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => data as List<dynamic>,
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to fetch posts',
    );
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.postLikes(postId),
      data: {'like': isLiked},
    );
    final apiResponse = ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => null,
    );
    
    if (!apiResponse.success) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.error?.message ?? 'Failed to toggle like',
      );
    }
  }
}
