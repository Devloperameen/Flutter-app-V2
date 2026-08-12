import 'package:dio/dio.dart';

import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/network/api_interceptors.dart';
import 'package:safe/core/storage/secure_storage_service.dart';

/// SAFE — Secure API Client
///
/// **SECURITY FEATURES:**
/// - Network security configuration for production endpoints
/// - JWT authentication via [AuthInterceptor]
/// - Request/response logging via [LoggingInterceptor]
/// - Automatic retry on transient failures via [RetryInterceptor]
/// - Rate limiting and security headers via [SecurityInterceptor]
///
/// **Certificate Pinning:**
/// Implement via Android network_security_config.xml and iOS Info.plist
/// for production deployments.
///
/// Usage via Riverpod:
/// ```dart
/// final apiClient = ref.read(apiClientProvider);
/// final response = await apiClient.dio.get(ApiEndpoints.habits);
/// ```
class ApiClient {
  ApiClient({required SecureStorageService secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Security headers
          'X-Requested-With': 'XMLHttpRequest',
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    // Order matters: Auth → Security → Retry → Logging
    _dio.interceptors.addAll([
      AuthInterceptor(secureStorage: secureStorage, dio: _dio),
      SecurityInterceptor(),
      RetryInterceptor(dio: _dio),
      LoggingInterceptor(),
    ]);
  }

  late final Dio _dio;

  /// The configured [Dio] instance. Use this for all API calls.
  Dio get dio => _dio;

  /// Convenience method for GET requests
  /// 
  /// Usage:
  /// ```dart
  /// final response = await apiClient.get(
  ///   '/endpoint',
  ///   queryParameters: {'key': 'value'},
  /// );
  /// ```
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return response.data ?? {};
  }

  /// Convenience method for POST requests
  /// 
  /// Usage:
  /// ```dart
  /// final response = await apiClient.post(
  ///   '/endpoint',
  ///   data: {'key': 'value'},
  /// );
  /// ```
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    void Function(int, int)? onSendProgress,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
    );
    return response.data ?? {};
  }

  /// Convenience method for PUT requests
  /// 
  /// Usage:
  /// ```dart
  /// final response = await apiClient.put(
  ///   '/endpoint',
  ///   data: {'key': 'value'},
  /// );
  /// ```
  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data ?? {};
  }

  /// Convenience method for DELETE requests
  /// 
  /// Usage:
  /// ```dart
  /// final response = await apiClient.delete('/endpoint');
  /// ```
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return response.data ?? {};
  }

  /// Convenience method for PATCH requests
  /// 
  /// Usage:
  /// ```dart
  /// final response = await apiClient.patch(
  ///   '/endpoint',
  ///   data: {'key': 'value'},
  /// );
  /// ```
  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data ?? {};
  }
}
