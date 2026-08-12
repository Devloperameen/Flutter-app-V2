import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Repository for content management (quotes, videos, reports)
class ContentRepository {
  const ContentRepository(this._apiClient);

  final ApiClient _apiClient;

  // ─────────────────────────────────────────────────
  // QUOTE OPERATIONS
  // ─────────────────────────────────────────────────

  /// Get a random motivational quote
  /// 
  /// Parameters:
  /// - category: Filter by category ('motivation', 'fitness', 'productivity', etc.)
  /// 
  /// Returns: Quote object with text, author, category
  Future<Map<String, dynamic>> getRandomQuote({String? category}) async {
    try {
      log.i('Fetching random quote${category != null ? ' ($category)' : ''}');
      
      final response = await _apiClient.get(
        ApiEndpoints.contentQuote,
        queryParameters: category != null ? {'category': category} : null,
      );
      
      log.i('✅ Random quote retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching random quote', error: e);
      rethrow;
    }
  }

  /// Get today's featured quote (same for all users)
  /// 
  /// Returns: Quote object
  Future<Map<String, dynamic>> getTodayQuote() async {
    try {
      log.i("Fetching today's featured quote");
      
      final response = await _apiClient.get(ApiEndpoints.contentQuoteToday);
      
      log.i("✅ Today's quote retrieved");
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e("❌ Error fetching today's quote", error: e);
      rethrow;
    }
  }

  /// Get quotes by category with pagination
  /// 
  /// Parameters:
  /// - category: Quote category
  /// - page: Page number (1-indexed)
  /// - limit: Items per page (1-100)
  /// 
  /// Returns: List of quotes
  Future<List<Map<String, dynamic>>> getQuotesByCategory({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      log.i('Fetching quotes${category != null ? ' ($category)' : ''}: page=$page, limit=$limit');
      
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (category != null) params['category'] = category;
      
      final response = await _apiClient.get(
        ApiEndpoints.contentQuotes,
        queryParameters: params,
      );
      
      final list = response['data'] as List<dynamic>;
      final quotes = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${quotes.length} quotes');
      return quotes;
    } catch (e) {
      log.e('❌ Error fetching quotes', error: e);
      rethrow;
    }
  }

  /// Create a new quote (admin only)
  /// 
  /// Parameters:
  /// - text: Quote text
  /// - author: Quote author
  /// - category: Quote category
  /// - tags: Optional tags
  /// 
  /// Returns: Created quote
  Future<Map<String, dynamic>> createQuote({
    required String text,
    required String author,
    required String category,
    List<String>? tags,
  }) async {
    try {
      log.i('Creating quote by $author');
      
      final response = await _apiClient.post(
        ApiEndpoints.contentQuote,
        data: {
          'text': text,
          'author': author,
          'category': category,
          'tags': tags ?? [],
        },
      );
      
      log.i('✅ Quote created');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error creating quote', error: e);
      rethrow;
    }
  }

  /// Update a quote (admin/creator only)
  /// 
  /// Parameters:
  /// - quoteId: ID of quote to update
  /// - text: New text (optional)
  /// - author: New author (optional)
  /// - category: New category (optional)
  /// 
  /// Returns: Updated quote
  Future<Map<String, dynamic>> updateQuote({
    required String quoteId,
    String? text,
    String? author,
    String? category,
  }) async {
    try {
      log.i('Updating quote: $quoteId');
      
      final data = <String, dynamic>{};
      if (text != null) data['text'] = text;
      if (author != null) data['author'] = author;
      if (category != null) data['category'] = category;
      
      final response = await _apiClient.put(
        ApiEndpoints.contentUpdateQuote(quoteId),
        data: data,
      );
      
      log.i('✅ Quote updated');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error updating quote', error: e);
      rethrow;
    }
  }

  /// Delete a quote (admin/creator only)
  /// 
  /// Parameters:
  /// - quoteId: ID of quote to delete
  /// 
  /// Returns: Deletion confirmation
  Future<Map<String, dynamic>> deleteQuote(String quoteId) async {
    try {
      log.i('Deleting quote: $quoteId');
      
      final response = await _apiClient.delete(
        ApiEndpoints.contentDeleteQuote(quoteId),
      );
      
      log.i('✅ Quote deleted');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error deleting quote', error: e);
      rethrow;
    }
  }

  /// Toggle quote active status (admin only)
  /// 
  /// Parameters:
  /// - quoteId: ID of quote
  /// - isActive: New active status
  /// 
  /// Returns: Updated quote
  Future<Map<String, dynamic>> toggleQuoteActive(
    String quoteId,
    bool isActive,
  ) async {
    try {
      log.i('Toggling quote active: $quoteId -> $isActive');
      
      final response = await _apiClient.patch(
        ApiEndpoints.contentToggleQuote(quoteId),
        data: {'isActive': isActive},
      );
      
      log.i('✅ Quote toggled');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error toggling quote', error: e);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────
  // VIDEO OPERATIONS
  // ─────────────────────────────────────────────────

  /// Get a random YouTube video
  /// 
  /// Parameters:
  /// - category: Filter by category ('motivation', 'fitness-training', etc.)
  /// 
  /// Returns: Video object with title, embedUrl, category
  Future<Map<String, dynamic>> getRandomVideo({String? category}) async {
    try {
      log.i('Fetching random video${category != null ? ' ($category)' : ''}');
      
      final response = await _apiClient.get(
        ApiEndpoints.contentVideo,
        queryParameters: category != null ? {'category': category} : null,
      );
      
      log.i('✅ Random video retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching random video', error: e);
      rethrow;
    }
  }

  /// Get videos by category with pagination
  /// 
  /// Parameters:
  /// - category: Video category
  /// - page: Page number (1-indexed)
  /// - limit: Items per page (1-50)
  /// 
  /// Returns: List of videos
  Future<List<Map<String, dynamic>>> getVideosByCategory({
    String? category,
    int page = 1,
    int limit = 5,
  }) async {
    try {
      log.i('Fetching videos${category != null ? ' ($category)' : ''}: page=$page, limit=$limit');
      
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (category != null) params['category'] = category;
      
      final response = await _apiClient.get(
        ApiEndpoints.contentVideos,
        queryParameters: params,
      );
      
      final list = response['data'] as List<dynamic>;
      final videos = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${videos.length} videos');
      return videos;
    } catch (e) {
      log.e('❌ Error fetching videos', error: e);
      rethrow;
    }
  }

  /// Create a new video (admin only)
  /// 
  /// Parameters:
  /// - title: Video title
  /// - description: Video description
  /// - youtubeUrl: YouTube URL
  /// - category: Video category
  /// - tags: Optional tags
  /// 
  /// Returns: Created video
  Future<Map<String, dynamic>> createVideo({
    required String title,
    required String description,
    required String youtubeUrl,
    required String category,
    List<String>? tags,
  }) async {
    try {
      log.i('Creating video: $title');
      
      final response = await _apiClient.post(
        ApiEndpoints.contentVideo,
        data: {
          'title': title,
          'description': description,
          'youtubeUrl': youtubeUrl,
          'category': category,
          'tags': tags ?? [],
        },
      );
      
      log.i('✅ Video created');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error creating video', error: e);
      rethrow;
    }
  }

  /// Update a video (admin/creator only)
  /// 
  /// Parameters:
  /// - videoId: ID of video to update
  /// - title: New title (optional)
  /// - description: New description (optional)
  /// - category: New category (optional)
  /// 
  /// Returns: Updated video
  Future<Map<String, dynamic>> updateVideo({
    required String videoId,
    String? title,
    String? description,
    String? category,
  }) async {
    try {
      log.i('Updating video: $videoId');
      
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (category != null) data['category'] = category;
      
      final response = await _apiClient.put(
        ApiEndpoints.contentUpdateVideo(videoId),
        data: data,
      );
      
      log.i('✅ Video updated');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error updating video', error: e);
      rethrow;
    }
  }

  /// Delete a video (admin/creator only)
  /// 
  /// Parameters:
  /// - videoId: ID of video to delete
  /// 
  /// Returns: Deletion confirmation
  Future<Map<String, dynamic>> deleteVideo(String videoId) async {
    try {
      log.i('Deleting video: $videoId');
      
      final response = await _apiClient.delete(
        ApiEndpoints.contentDeleteVideo(videoId),
      );
      
      log.i('✅ Video deleted');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error deleting video', error: e);
      rethrow;
    }
  }

  /// Toggle video active status (admin only)
  /// 
  /// Parameters:
  /// - videoId: ID of video
  /// - isActive: New active status
  /// 
  /// Returns: Updated video
  Future<Map<String, dynamic>> toggleVideoActive(
    String videoId,
    bool isActive,
  ) async {
    try {
      log.i('Toggling video active: $videoId -> $isActive');
      
      final response = await _apiClient.patch(
        ApiEndpoints.contentToggleVideo(videoId),
        data: {'isActive': isActive},
      );
      
      log.i('✅ Video toggled');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error toggling video', error: e);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────
  // REPORT/MODERATION OPERATIONS
  // ─────────────────────────────────────────────────

  /// Report inappropriate content
  /// 
  /// Parameters:
  /// - targetId: ID of content being reported
  /// - targetType: Type of content ('post', 'message', 'user', 'comment')
  /// - reason: Reason for report ('harassment', 'spam', 'inappropriate-content')
  /// - description: Detailed description
  /// 
  /// Returns: Report confirmation
  Future<Map<String, dynamic>> reportContent({
    required String targetId,
    required String targetType,
    required String reason,
    required String description,
  }) async {
    try {
      log.i('Reporting $targetType: $targetId ($reason)');
      
      final response = await _apiClient.post(
        ApiEndpoints.contentReport,
        data: {
          'targetId': targetId,
          'targetType': targetType,
          'reason': reason,
          'description': description,
        },
      );
      
      log.i('✅ Report submitted');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error reporting content', error: e);
      rethrow;
    }
  }

  /// Get moderation queue (admin only)
  /// 
  /// Parameters:
  /// - status: Filter by status ('pending', 'resolved', etc.)
  /// - limit: Maximum items (1-100)
  /// 
  /// Returns: List of pending reports
  Future<List<Map<String, dynamic>>> getModerationQueue({
    String status = 'pending',
    int limit = 20,
  }) async {
    try {
      log.i('Fetching moderation queue (status: $status, limit: $limit)');
      
      final response = await _apiClient.get(
        ApiEndpoints.contentReportQueue,
        queryParameters: {
          'status': status,
          'limit': limit,
        },
      );
      
      final list = response['data'] as List<dynamic>;
      final reports = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${reports.length} reports');
      return reports;
    } catch (e) {
      log.e('❌ Error fetching moderation queue', error: e);
      rethrow;
    }
  }

  /// Resolve a report (admin only)
  /// 
  /// Parameters:
  /// - reportId: ID of report to resolve
  /// - action: Resolution action ('content-removed', 'user-warned', 'dismissed')
  /// - notes: Optional notes
  /// 
  /// Returns: Updated report
  Future<Map<String, dynamic>> resolveReport({
    required String reportId,
    required String action,
    String? notes,
  }) async {
    try {
      log.i('Resolving report: $reportId (action: $action)');
      
      final data = {
        'action': action,
      };
      if (notes != null) data['notes'] = notes;
      
      final response = await _apiClient.post(
        ApiEndpoints.contentResolveReport(reportId),
        data: data,
      );
      
      log.i('✅ Report resolved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error resolving report', error: e);
      rethrow;
    }
  }
}
