/// Base failure class for the entire application.
///
/// Every error in SAFE should be represented as a [Failure] subclass.
/// This ensures consistent error handling across all layers.
///
/// Why Failures instead of Exceptions?
/// - Exceptions are for unexpected errors (bugs, crashes)
/// - Failures are expected domain errors (network down, invalid input)
/// - Failures are type-safe, testable, and composable
sealed class Failure {
  const Failure({
    required this.message,
    this.code,
    this.stackTrace,
  });

  /// Human-readable error message
  final String message;

  /// Machine-readable error code (for logging/analytics)
  final String? code;

  /// Stack trace for debugging (never shown to users)
  final StackTrace? stackTrace;
}

/// Server/API errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });

  final int? statusCode;
}

/// Network connectivity errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
    super.stackTrace,
  });
}

/// Local storage/cache errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local data.',
    super.code = 'CACHE_ERROR',
    super.stackTrace,
  });
}

/// Authentication errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.stackTrace,
  });
}

/// Input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.field,
    super.code = 'VALIDATION_ERROR',
    super.stackTrace,
  });

  /// The specific field that failed validation
  final String? field;
}

/// Permission/authorization errors
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission to perform this action.',
    super.code = 'PERMISSION_ERROR',
    super.stackTrace,
  });
}

/// Feature not available (e.g., premium-only content)
class FeatureLockedFailure extends Failure {
  const FeatureLockedFailure({
    super.message = 'This feature requires a premium subscription.',
    super.code = 'FEATURE_LOCKED',
    super.stackTrace,
    this.requiredPlan,
  });

  final String? requiredPlan;
}

/// Unknown/unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN_ERROR',
    super.stackTrace,
  });
}
