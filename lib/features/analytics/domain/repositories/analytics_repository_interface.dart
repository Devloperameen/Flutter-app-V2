import 'package:safe/features/analytics/domain/models/analytics_data.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';

/// Interface for analytics repository
abstract class IAnalyticsRepository {
  /// Get complete analytics data for a period
  Future<AnalyticsData> getAnalytics({
    required String userId,
    required AnalyticsPeriod period,
    String? categoryFilter,
  });

  /// Get detailed performance for a specific habit
  Future<HabitPerformance> getHabitPerformance({
    required String userId,
    required String habitId,
    required AnalyticsPeriod period,
  });

  /// Refresh cached analytics
  Future<void> refreshCache(String userId);
}
