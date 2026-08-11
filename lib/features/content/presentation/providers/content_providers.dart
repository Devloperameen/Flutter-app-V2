import 'package:riverpod/riverpod.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/content/data/repositories/content_repository.dart';

// ─────────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────────

/// Provides ContentRepository instance
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ContentRepository(apiClient);
});

// ─────────────────────────────────────────────────
// QUOTE PROVIDERS
// ─────────────────────────────────────────────────

/// Random quote (refresh to get new one)
/// Optional category filter
final randomQuoteProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String?>((ref, category) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getRandomQuote(category: category);
});

/// Today's featured quote (same for all users)
final todayQuoteProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getTodayQuote();
});

/// Quotes by category with pagination
/// Usage: quotesByCategoryProvider(category: 'motivation', page: 1, limit: 10)
final quotesByCategoryProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({String? category, int page, int limit})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getQuotesByCategory(
    category: params.category,
    page: params.page,
    limit: params.limit,
  );
});

/// Create quote (admin only)
final createQuoteProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({
      String text,
      String author,
      String category,
      List<String>? tags
    })>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.createQuote(
    text: params.text,
    author: params.author,
    category: params.category,
    tags: params.tags,
  );
  
  // Invalidate quotes cache
  ref.invalidate(quotesByCategoryProvider);
  ref.invalidate(randomQuoteProvider);
  
  return result;
});

/// Update quote (admin/creator only)
final updateQuoteProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({
      String quoteId,
      String? text,
      String? author,
      String? category
    })>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.updateQuote(
    quoteId: params.quoteId,
    text: params.text,
    author: params.author,
    category: params.category,
  );
  
  ref.invalidate(quotesByCategoryProvider);
  return result;
});

/// Delete quote (admin/creator only)
final deleteQuoteProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, quoteId) async {
    final repository = ref.watch(contentRepositoryProvider);
    final result = await repository.deleteQuote(quoteId);
    
    ref.invalidate(quotesByCategoryProvider);
    return result;
  },
);

/// Toggle quote active (admin only)
final toggleQuoteActiveProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({String quoteId, bool isActive})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.toggleQuoteActive(
    params.quoteId,
    params.isActive,
  );
  
  ref.invalidate(quotesByCategoryProvider);
  return result;
});

// ─────────────────────────────────────────────────
// VIDEO PROVIDERS
// ─────────────────────────────────────────────────

/// Random video (refresh to get new one)
/// Optional category filter
final randomVideoProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String?>((ref, category) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getRandomVideo(category: category);
});

/// Videos by category with pagination
final videosByCategoryProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({String? category, int page, int limit})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getVideosByCategory(
    category: params.category,
    page: params.page,
    limit: params.limit,
  );
});

/// Create video (admin only)
final createVideoProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({
      String title,
      String description,
      String youtubeUrl,
      String category,
      List<String>? tags
    })>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.createVideo(
    title: params.title,
    description: params.description,
    youtubeUrl: params.youtubeUrl,
    category: params.category,
    tags: params.tags,
  );
  
  ref.invalidate(videosByCategoryProvider);
  ref.invalidate(randomVideoProvider);
  
  return result;
});

/// Update video (admin/creator only)
final updateVideoProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({
      String videoId,
      String? title,
      String? description,
      String? category
    })>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.updateVideo(
    videoId: params.videoId,
    title: params.title,
    description: params.description,
    category: params.category,
  );
  
  ref.invalidate(videosByCategoryProvider);
  return result;
});

/// Delete video (admin/creator only)
final deleteVideoProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, videoId) async {
    final repository = ref.watch(contentRepositoryProvider);
    final result = await repository.deleteVideo(videoId);
    
    ref.invalidate(videosByCategoryProvider);
    return result;
  },
);

/// Toggle video active (admin only)
final toggleVideoActiveProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({String videoId, bool isActive})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.toggleVideoActive(
    params.videoId,
    params.isActive,
  );
  
  ref.invalidate(videosByCategoryProvider);
  return result;
});

// ─────────────────────────────────────────────────
// REPORT/MODERATION PROVIDERS
// ─────────────────────────────────────────────────

/// Report content (user-facing)
final reportContentProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({
      String targetId,
      String targetType,
      String reason,
      String description
    })>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.reportContent(
    targetId: params.targetId,
    targetType: params.targetType,
    reason: params.reason,
    description: params.description,
  );
});

/// Moderation queue (admin only)
final moderationQueueProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({String status, int limit})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getModerationQueue(
    status: params.status,
    limit: params.limit,
  );
});

/// Resolve report (admin only)
final resolveReportProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({String reportId, String action, String? notes})>((ref, params) async {
  final repository = ref.watch(contentRepositoryProvider);
  final result = await repository.resolveReport(
    reportId: params.reportId,
    action: params.action,
    notes: params.notes,
  );
  
  // Refresh moderation queue
  ref.invalidate(moderationQueueProvider);
  
  return result;
});

// ─────────────────────────────────────────────────
// UI STATE PROVIDERS
// ─────────────────────────────────────────────────

/// Selected quote category filter
final selectedQuoteCategoryProvider = StateProvider<String?>((ref) => null);

/// Selected video category filter
final selectedVideoCategoryProvider = StateProvider<String?>((ref) => null);

/// Current page for quotes
final quotePageProvider = StateProvider<int>((ref) => 1);

/// Current page for videos
final videoPageProvider = StateProvider<int>((ref) => 1);
