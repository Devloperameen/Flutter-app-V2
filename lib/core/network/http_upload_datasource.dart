/// ============================================
/// HTTP Upload Datasource
/// ============================================
/// 
/// Handles file uploads to Express backend
/// - Profile images
/// - Post images & videos
/// - Message attachments

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';

/// File upload response
class UploadResponse {
  final String url;
  final String filename;

  UploadResponse({
    required this.url,
    required this.filename,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      url: json['url'] as String,
      filename: json['filename'] as String,
    );
  }
}

/// HTTP file upload datasource
class HttpUploadDatasource {
  final ApiClient apiClient;

  HttpUploadDatasource({required this.apiClient});

  // ─── Profile Upload ────────────────────────────

  /// Upload user avatar/profile image
  /// 
  /// Supported formats: JPEG, PNG, WebP
  /// Max size: 5MB
  /// 
  /// @param filePath: Path to image file on device
  /// @returns: UploadResponse with image URL
  Future<UploadResponse> uploadAvatar({required String filePath}) async {
    try {
      log.i('📤 Uploading avatar: $filePath');

      // Verify file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      // Create FormData
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      // Upload to backend
      final response = await apiClient.post(
        '${ApiEndpoints.baseUrl}/uploads/avatar',
        data: formData,
      );

      final uploadResponse = UploadResponse.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Avatar uploaded: ${uploadResponse.url}');
      return uploadResponse;
    } catch (e) {
      log.e('❌ Error uploading avatar: $e');
      rethrow;
    }
  }

  // ─── Post Upload ───────────────────────────────

  /// Upload post image
  /// 
  /// Supported formats: JPEG, PNG, WebP, GIF
  /// Max size: 10MB
  /// 
  /// @param filePath: Path to image file
  /// @returns: UploadResponse with image URL
  Future<UploadResponse> uploadPostImage({required String filePath}) async {
    try {
      log.i('📤 Uploading post image: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      final response = await apiClient.post(
        '${ApiEndpoints.baseUrl}/uploads/post-image',
        data: formData,
      );

      final uploadResponse = UploadResponse.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Image uploaded: ${uploadResponse.url}');
      return uploadResponse;
    } catch (e) {
      log.e('❌ Error uploading post image: $e');
      rethrow;
    }
  }

  /// Upload post video
  /// 
  /// Supported formats: MP4, WebM, MOV
  /// Max size: 100MB
  /// 
  /// @param filePath: Path to video file
  /// @param onProgress: Callback for upload progress (0-100)
  /// @returns: UploadResponse with video URL
  Future<UploadResponse> uploadPostVideo({
    required String filePath,
    Function(double)? onProgress,
  }) async {
    try {
      log.i('📤 Uploading post video: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      final response = await apiClient.post(
        '${ApiEndpoints.baseUrl}/uploads/post-video',
        data: formData,
        onSendProgress: (count, total) {
          if (onProgress != null) {
            final progress = (count / total) * 100;
            onProgress(progress);
            log.i('Upload progress: ${progress.toStringAsFixed(2)}%');
          }
        },
      );

      final uploadResponse = UploadResponse.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Video uploaded: ${uploadResponse.url}');
      return uploadResponse;
    } catch (e) {
      log.e('❌ Error uploading post video: $e');
      rethrow;
    }
  }

  // ─── Message Attachment Upload ──────────────────

  /// Upload message attachment
  /// 
  /// Supported: Images, videos, PDFs, documents
  /// Max size: 20MB
  /// 
  /// @param filePath: Path to file
  /// @param onProgress: Callback for upload progress
  /// @returns: UploadResponse with file URL
  Future<UploadResponse> uploadAttachment({
    required String filePath,
    Function(double)? onProgress,
  }) async {
    try {
      log.i('📤 Uploading attachment: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      final response = await apiClient.post(
        '${ApiEndpoints.baseUrl}/uploads/attachment',
        data: formData,
        onSendProgress: onProgress != null
            ? (count, total) {
                final progress = (count / total) * 100;
                onProgress(progress);
              }
            : null,
      );

      final uploadResponse = UploadResponse.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Attachment uploaded: ${uploadResponse.url}');
      return uploadResponse;
    } catch (e) {
      log.e('❌ Error uploading attachment: $e');
      rethrow;
    }
  }

  // ─── Batch Upload ───────────────────────────────

  /// Upload multiple images (e.g., gallery post)
  /// 
  /// @param filePaths: List of image paths
  /// @param onProgress: Callback for overall progress
  /// @returns: List of upload responses
  Future<List<UploadResponse>> uploadMultipleImages({
    required List<String> filePaths,
    Function(int, int)? onProgress,
  }) async {
    try {
      log.i('📤 Uploading ${filePaths.length} images');

      final results = <UploadResponse>[];

      for (int i = 0; i < filePaths.length; i++) {
        final response = await uploadPostImage(filePath: filePaths[i]);
        results.add(response);

        onProgress?.call(i + 1, filePaths.length);
        log.i('✅ Image ${i + 1}/${filePaths.length} uploaded');
      }

      log.i('✅ All images uploaded');
      return results;
    } catch (e) {
      log.e('❌ Error uploading multiple images: $e');
      rethrow;
    }
  }

  // ─── Helper Methods ────────────────────────────

  /// Check file size
  /// 
  /// @param filePath: Path to file
  /// @param maxSizeMB: Maximum size in MB
  /// @returns: true if file is within size limit
  Future<bool> isFileSizeValid({
    required String filePath,
    required int maxSizeMB,
  }) async {
    try {
      final file = File(filePath);
      final sizeInBytes = await file.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);
      return sizeInMB <= maxSizeMB;
    } catch (e) {
      log.e('Error checking file size: $e');
      return false;
    }
  }

  /// Get file size in MB
  /// 
  /// @param filePath: Path to file
  /// @returns: File size in MB
  Future<double> getFileSizeMB({required String filePath}) async {
    try {
      final file = File(filePath);
      final sizeInBytes = await file.length();
      return sizeInBytes / (1024 * 1024);
    } catch (e) {
      log.e('Error getting file size: $e');
      return 0;
    }
  }

  /// Get file extension
  /// 
  /// @param filePath: Path to file
  /// @returns: File extension (e.g., "jpg")
  String getFileExtension({required String filePath}) {
    return filePath.split('.').last.toLowerCase();
  }
}
