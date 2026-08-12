import 'package:riverpod/riverpod.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/activity/data/repositories/activity_repository.dart';

// ─────────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────────

/// Provides ActivityRepository instance
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ActivityRepository(apiClient);
});

// ─────────────────────────────────────────────────
// ACTIVITY FEED PROVIDER
// ─────────────────────────────────────────────────

/// Paginated activity feed
/// Usage: activityFeedProvider(page: 1, limit: 20, type: 'all')
final activityFeedProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({int page, int limit, String type})>((ref, params) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getActivityFeed(
    page: params.page,
    limit: params.limit,
    type: params.type,
  );
});

// ─────────────────────────────────────────────────
// TODAY ACTIVITIES PROVIDER
// ─────────────────────────────────────────────────

/// Activities from today only
final todayActivitiesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getTodayActivities();
});

// ─────────────────────────────────────────────────
// ACTIVITIES BY TYPE PROVIDER
// ─────────────────────────────────────────────────

/// Activities filtered by type
/// Types: 'habit-completion', 'focus-completed', 'streak-milestone', 'level-up', etc.
final activitiesByTypeProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    ({String type, int limit})>((ref, params) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getActivitiesByType(
    type: params.type,
    limit: params.limit,
  );
});

// ─────────────────────────────────────────────────
// ACTIVITY SUMMARY PROVIDER
// ─────────────────────────────────────────────────

/// Activity counts by type and total XP
final activitySummaryProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getActivitySummary();
});

// ─────────────────────────────────────────────────
// ACHIEVEMENTS PROVIDER
// ─────────────────────────────────────────────────

/// User's achievements/badges with unlock status
final achievementsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  return repository.getAchievements();
});

// ─────────────────────────────────────────────────
// SHARE ACTIVITY PROVIDER
// ─────────────────────────────────────────────────

/// Share an activity to community
/// Usage: ref.read(shareActivityProvider(activityId).future)
final shareActivityProvider = FutureProvider.family<
    Map<String, dynamic>,
    String>((ref, activityId) async {
  final repository = ref.watch(activityRepositoryProvider);
  final result = await repository.shareActivity(activityId);
  
  // Invalidate feed to show updated status
  ref.invalidate(activityFeedProvider);
  ref.invalidate(todayActivitiesProvider);
  
  return result;
});

// ─────────────────────────────────────────────────
// SELECTED ACTIVITY TYPE FILTER
// ─────────────────────────────────────────────────

/// Tracks selected activity type filter
/// 'all', 'habit-completion', 'focus-completed', etc.
final selectedActivityTypeProvider = StateProvider<String>((ref) => 'all');

// ─────────────────────────────────────────────────
// CURRENT PAGE FOR ACTIVITY FEED
// ─────────────────────────────────────────────────

/// Tracks current page for pagination
final activityFeedPageProvider = StateProvider<int>((ref) => 1);

// ─────────────────────────────────────────────────
// FILTERED ACTIVITY FEED
// ─────────────────────────────────────────────────

/// Activity feed filtered by selected type
/// Automatically updates when type or page changes
final filteredActivityFeedProvider = FutureProvider.autoDispose<
    List<Map<String, dynamic>>>((ref) async {
  final activityType = ref.watch(selectedActivityTypeProvider);
  final page = ref.watch(activityFeedPageProvider);

  return ref.watch(activityFeedProvider((
    page: page,
    limit: 20,
    type: activityType,
  )).future);
});
