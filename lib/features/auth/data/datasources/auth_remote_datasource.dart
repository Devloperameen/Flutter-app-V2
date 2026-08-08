import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/network/api_response.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/auth/domain/models/auth_response.dart';
import 'package:safe/features/auth/domain/models/user.dart' as safe;

part 'auth_remote_datasource.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient: apiClient);
}

class AuthRemoteDataSource {
  AuthRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<AuthResponse> login(String email, String password) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final apiResponse = ApiResponse<AuthResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => AuthResponse.fromJson(data as Map<String, dynamic>),
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to login',
    );
  }

  Future<AuthResponse> register(String firstName, String lastName, String email, String password) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.register,
      data: {'firstName': firstName, 'lastName': lastName, 'email': email, 'password': password},
    );
    final apiResponse = ApiResponse<AuthResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => AuthResponse.fromJson(data as Map<String, dynamic>),
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to register',
    );
  }

  Future<safe.User> getProfile() async {
    final response = await apiClient.dio.get(ApiEndpoints.me);
    final apiResponse = ApiResponse<safe.User>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => safe.User.fromJson(data as Map<String, dynamic>),
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to get profile',
    );
  }

  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiEndpoints.logout);
    } catch (e) {
      // Ignore network errors on logout
    }
  }
}

