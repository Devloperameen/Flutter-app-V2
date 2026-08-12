/// SAFE — Unified API Response Wrapper
///
/// Every Spring Boot endpoint returns this shape:
/// ```json
/// {
///   "success": true,
///   "message": "Habits fetched",
///   "data": { ... },
///   "error": null,
///   "meta": { "page": 0, "size": 20, "totalElements": 42, ... }
/// }
/// ```
///
/// We avoid Freezed here because generic + JSON code-gen
/// is fragile. Plain Dart gives us full control.
library;

class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
    this.meta,
  });

  /// Parse from JSON with a custom data deserialiser.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool success;
  final String? message;
  final T? data;
  final ApiError? error;
  final PaginationMeta? meta;
}

/// Structured API error returned by the backend.
class ApiError {
  const ApiError({
    required this.code,
    required this.message,
    this.fieldErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String? ?? 'UNKNOWN',
      message: json['message'] as String? ?? 'An error occurred',
      fieldErrors: json['fieldErrors'] != null
          ? (json['fieldErrors'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value as List<dynamic>).cast<String>(),
              ),
            )
          : null,
    );
  }

  final String code;
  final String message;
  final Map<String, List<String>>? fieldErrors;
}

/// Pagination metadata from Spring Boot's `Page<T>`.
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 20,
      totalElements: json['totalElements'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }

  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
