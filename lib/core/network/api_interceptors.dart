import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:safe/core/storage/secure_storage_service.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';

// ═══════════════════════════════════════════════════════
// AUTH INTERCEPTOR — Attaches JWT, handles 401 refresh
// ═══════════════════════════════════════════════════════

/// Automatically attaches the access token to every request
/// and transparently refreshes it when a 401 is received.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  final SecureStorageService secureStorage;
  final Dio dio;

  /// Tracks whether a token refresh is in progress to prevent
  /// multiple concurrent refresh requests.
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints
    final publicPaths = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      ApiEndpoints.forgotPassword,
    ];

    final isPublic = publicPaths.any((p) => options.path.contains(p));

    if (!isPublic) {
      final token = await secureStorage.read(StorageKeys.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshed = await _refreshToken();
        _isRefreshing = false;

        if (refreshed) {
          // Retry the original request with the new token
          final token = await secureStorage.read(StorageKeys.accessToken);
          err.requestOptions.headers['Authorization'] = 'Bearer $token';

          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (_) {
        _isRefreshing = false;
      }

      // Refresh failed — clear tokens (force re-login)
      await secureStorage.deleteAll();
    }

    handler.next(err);
  }

  /// Attempt to refresh the access token using the stored refresh token.
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.read(StorageKeys.refreshToken);
      if (refreshToken == null) return false;

      // Use a separate Dio instance to avoid interceptor loops
      final freshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final response = await freshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        await secureStorage.write(
          StorageKeys.accessToken,
          data['accessToken'] as String,
        );
        await secureStorage.write(
          StorageKeys.refreshToken,
          data['refreshToken'] as String,
        );
        return true;
      }
    } catch (e) {
      log.e('Token refresh failed: $e');
    }
    return false;
  }
}

// ═══════════════════════════════════════════════════════
// SECURITY INTERCEPTOR — Security headers and validation
// ═══════════════════════════════════════════════════════

/// Adds security headers and validates responses
class SecurityInterceptor extends Interceptor {
  final Map<String, int> _requestCounts = {};
  final Duration _windowDuration = const Duration(minutes: 1);
  DateTime _lastReset = DateTime.now();
  static const int _maxRequestsPerMinute = 100;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Rate limiting
    final now = DateTime.now();
    if (now.difference(_lastReset) > _windowDuration) {
      _requestCounts.clear();
      _lastReset = now;
    }

    final endpoint = options.path;
    _requestCounts[endpoint] = (_requestCounts[endpoint] ?? 0) + 1;

    if (_requestCounts[endpoint]! > _maxRequestsPerMinute) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Rate limit exceeded',
          type: DioExceptionType.cancel,
        ),
      );
    }

    // Add security headers
    options.headers.addAll({
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Referrer-Policy': 'strict-origin-when-cross-origin',
    });

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Validate response headers for security
    final contentType = response.headers.value('content-type');
    if (contentType != null && !contentType.startsWith('application/json')) {
      log.w('⚠️ Unexpected content type: $contentType');
    }

    handler.next(response);
  }
}

// ═══════════════════════════════════════════════════════
// LOGGING INTERCEPTOR — Dev-only request/response logs
// ═══════════════════════════════════════════════════════

/// Pretty-prints HTTP traffic in debug mode.
/// Disabled in release builds for performance.
/// **SECURITY:** Filters sensitive data from logs
class LoggingInterceptor extends Interceptor {
  final Set<String> _sensitiveFields = {
    'password',
    'token',
    'accessToken',
    'refreshToken',
    'authorization',
    'secret',
    'key',
    'credential',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log.d('→ ${options.method} ${options.uri}');
      if (options.data != null) {
        final sanitizedData = _sanitizeData(options.data);
        log.d('  Body: $sanitizedData');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log.e('✘ ${err.response?.statusCode} ${err.requestOptions.uri}');
      log.e('  ${err.message}');
    }
    handler.next(err);
  }

  /// Remove sensitive data from logs
  dynamic _sanitizeData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final sanitized = <String, dynamic>{};
      for (final entry in data.entries) {
        if (_sensitiveFields.any((field) => 
            entry.key.toLowerCase().contains(field.toLowerCase()))) {
          sanitized[entry.key] = '[REDACTED]';
        } else {
          sanitized[entry.key] = entry.value;
        }
      }
      return sanitized;
    }
    return data;
  }
}

// ═══════════════════════════════════════════════════════
// RETRY INTERCEPTOR — Auto-retry on transient failures
// ═══════════════════════════════════════════════════════

/// Retries failed requests up to [maxRetries] times for
/// transient errors (timeouts, 500/502/503).
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      await Future<void>.delayed(retryDelay * (retryCount + 1));

      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // Fall through to handler.next
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    final status = err.response?.statusCode;
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        status == 500 ||
        status == 502 ||
        status == 503;
  }
}
