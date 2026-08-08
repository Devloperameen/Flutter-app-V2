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
        validateStatus: (status) => status != null && status < 500,
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
}
