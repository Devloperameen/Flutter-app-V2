import 'package:riverpod/riverpod.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/analytics/data/repositories/analytics_repository.dart';
import 'package:safe/features/analytics/domain/models/analytics_models.dart';

// ─────────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────────

/// Provides AnalyticsRepository instance
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnalyticsRepository(apiClient);
});

// ─────────────────────────────────────────────────
// MULTI-PERIOD ANALYTICS PROVIDER
// ─────────────────────────────────────────────────

/// Multi-period analytics overview
/// Parameters: period = 'today', 'week', 'month', 'all-time'
final multiPeriodAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, period) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getMultiPeriodAnalytics(period: period);
});

// ─────────────────────────────────────────────────
// HABIT METRICS PROVIDER
// ─────────────────────────────────────────────────

/// Habit completion metrics for a period
final habitMetricsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, period) async {
    final repository = ref.watch(analyticsRepositoryProvider);
    return repository.getHabitMetrics(period: period);
  },
);

// ─────────────────────────────────────────────────
// FOCUS ANALYTICS PROVIDER
// ─────────────────────────────────────────────────

/// Focus session analytics for a period
final focusAnalyticsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, period) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getFocusAnalytics(period: period);
});

// ─────────────────────────────────────────────────
// XP CHART DATA PROVIDER
// ─────────────────────────────────────────────────

/// XP progression chart data
/// Parameters: days = 1-365 (default 30)
final xpChartDataProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, days) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getXPChartData(days: days);
});

// ─────────────────────────────────────────────────
// HEATMAP DATA PROVIDER
// ─────────────────────────────────────────────────

/// Activity heatmap data for calendar view
/// Usage: heatmapProvider(month: 8, year: 2026)
final heatmapDataProvider = FutureProvider.family<
    Map<String, dynamic>,
    ({int? month, int? year})>((ref, params) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getHeatmapData(
    month: params.month,
    year: params.year,
  );
});

// ─────────────────────────────────────────────────
// LEADERBOARD PROVIDER
// ─────────────────────────────────────────────────

/// Global leaderboard rankings
/// Parameters: limit = 1-100 (default 10)
final leaderboardProvider = FutureProvider.family<
    List<Map<String, dynamic>>,
    int>((ref, limit) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getLeaderboard(limit: limit);
});

// ─────────────────────────────────────────────────
// USER RANK PROVIDER
// ─────────────────────────────────────────────────

/// User's rank, percentile, level on leaderboard
final userRankProvider =
    FutureProvider.autoDispose<UserRank>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final rankData = await repository.getMyRank();
  return UserRank.fromJson(rankData);
});

// ─────────────────────────────────────────────────
// INSIGHTS PROVIDER
// ─────────────────────────────────────────────────

/// Personalized insights and suggestions
final insightsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return repository.getInsights();
});

// ─────────────────────────────────────────────────
// SELECTED PERIOD STATE PROVIDER
// ─────────────────────────────────────────────────

/// Tracks selected period for analytics dashboard
/// 'today', 'week', 'month', 'all-time'
final selectedPeriodProvider = StateProvider<String>((ref) => 'week');

// ─────────────────────────────────────────────────
// DASHBOARD DATA PROVIDER (COMBINED)
// ─────────────────────────────────────────────────

/// Combined dashboard data for selected period
/// Automatically updates when period changes
final dashboardDataProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final period = ref.watch(selectedPeriodProvider);
  return ref.watch(multiPeriodAnalyticsProvider(period).future);
});
