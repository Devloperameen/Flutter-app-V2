import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Repository for analytics operations
/// Provides dashboard data, charts, leaderboards, and insights
class AnalyticsRepository {
  const AnalyticsRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Get multi-period analytics overview
  /// 
  /// Parameters:
  /// - period: 'today', 'week', 'month', or 'all-time'
  /// 
  /// Returns: Analytics data including habits, focus, XP, streaks
  Future<Map<String, dynamic>> getMultiPeriodAnalytics({
    String period = 'week',
  }) async {
    try {
      log.i('Fetching $period analytics');
      
      final response = await _apiClient.get(
        ApiEndpoints.analytics,
        queryParameters: {'period': period},
      );
      
      log.i('✅ $period analytics retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching $period analytics', error: e);
      rethrow;
    }
  }

  /// Get habit completion metrics for a period
  /// 
  /// Parameters:
  /// - period: 'week' by default, can be 'today', 'month', 'all-time'
  /// 
  /// Returns: List of habits with completion rates, streaks, XP
  Future<List<Map<String, dynamic>>> getHabitMetrics({
    String period = 'week',
  }) async {
    try {
      log.i('Fetching habit metrics for $period');
      
      final response = await _apiClient.get(
        ApiEndpoints.analyticsHabits,
        queryParameters: {'period': period},
      );
      
      final list = response['data'] as List<dynamic>;
      final metrics = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${metrics.length} habit metrics');
      return metrics;
    } catch (e) {
      log.e('❌ Error fetching habit metrics', error: e);
      rethrow;
    }
  }

  /// Get focus session analytics
  /// 
  /// Parameters:
  /// - period: 'week' by default
  /// 
  /// Returns: Focus analytics with sessions, minutes, XP, daily breakdown
  Future<Map<String, dynamic>> getFocusAnalytics({
    String period = 'week',
  }) async {
    try {
      log.i('Fetching focus analytics for $period');
      
      final response = await _apiClient.get(
        ApiEndpoints.analyticsFocus,
        queryParameters: {'period': period},
      );
      
      log.i('✅ Focus analytics retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching focus analytics', error: e);
      rethrow;
    }
  }

  /// Get XP progression chart data
  /// 
  /// Parameters:
  /// - days: Number of days to retrieve (1-365, default 30)
  /// 
  /// Returns: Chart data with labels, daily XP data, current level, XP to next level
  Future<Map<String, dynamic>> getXPChartData({
    int days = 30,
  }) async {
    try {
      log.i('Fetching XP chart data for $days days');
      
      final response = await _apiClient.get(
        ApiEndpoints.analyticsXpChart,
        queryParameters: {'days': days},
      );
      
      log.i('✅ XP chart data retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching XP chart data', error: e);
      rethrow;
    }
  }

  /// Get activity heatmap data (calendar view)
  /// 
  /// Parameters:
  /// - month: Month number (1-12)
  /// - year: Year number
  /// 
  /// Returns: Heatmap data with activity counts and intensity per day
  Future<Map<String, dynamic>> getHeatmapData({
    int? month,
    int? year,
  }) async {
    try {
      log.i('Fetching heatmap data for $month/$year');
      
      final params = <String, dynamic>{};
      if (month != null) params['month'] = month;
      if (year != null) params['year'] = year;
      
      final response = await _apiClient.get(
        ApiEndpoints.analyticsHeatmap,
        queryParameters: params.isNotEmpty ? params : null,
      );
      
      log.i('✅ Heatmap data retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching heatmap data', error: e);
      rethrow;
    }
  }

  /// Get global leaderboard
  /// 
  /// Parameters:
  /// - limit: Number of top users (1-100, default 10)
  /// 
  /// Returns: List of top users with ranks, levels, XP
  Future<List<Map<String, dynamic>>> getLeaderboard({
    int limit = 10,
  }) async {
    try {
      log.i('Fetching leaderboard (limit: $limit)');
      
      final response = await _apiClient.get(
        ApiEndpoints.analyticsLeaderboard,
        queryParameters: {'limit': limit},
      );
      
      final list = response['data'] as List<dynamic>;
      final leaderboard = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Leaderboard retrieved');
      return leaderboard;
    } catch (e) {
      log.e('❌ Error fetching leaderboard', error: e);
      rethrow;
    }
  }

  /// Get user's rank in leaderboard
  /// 
  /// Returns: User's rank, percentile, level, total XP
  Future<Map<String, dynamic>> getMyRank() async {
    try {
      log.i('Fetching user rank');
      
      final response = await _apiClient.get(ApiEndpoints.analyticsMyRank);
      
      log.i('✅ User rank retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching user rank', error: e);
      rethrow;
    }
  }

  /// Get personalized insights and suggestions
  /// 
  /// Returns: List of insight objects with messages and priorities
  Future<List<Map<String, dynamic>>> getInsights() async {
    try {
      log.i('Fetching personalized insights');
      
      final response = await _apiClient.get(ApiEndpoints.analyticsInsights);
      
      final list = response['data'] as List<dynamic>;
      final insights = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${insights.length} insights');
      return insights;
    } catch (e) {
      log.e('❌ Error fetching insights', error: e);
      rethrow;
    }
  }
}
