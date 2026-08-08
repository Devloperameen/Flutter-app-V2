/// Custom exceptions for the data layer.
///
/// These are thrown by data sources and caught by repositories,
/// which convert them into [Failure] objects for the domain layer.
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
    this.code,
  });

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => 'ServerException(message: $message, '
      'statusCode: $statusCode, code: $code)';
}

class CacheException implements Exception {
  const CacheException({
    this.message = 'Cache operation failed',
  });

  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}

class NetworkException implements Exception {
  const NetworkException({
    this.message = 'Network connection failed',
  });

  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}

class AuthException implements Exception {
  const AuthException({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  String toString() => 'AuthException(message: $message, code: $code)';
}
