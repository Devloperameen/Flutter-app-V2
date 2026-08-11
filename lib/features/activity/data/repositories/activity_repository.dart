import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Repository for activity feed and achievements
class ActivityRepository {
  const ActivityRepository(this._apiClient);

  final ApiClient _apiClient;

  /// Get user's activity feed with pagination
  /// 
  /// Parameters:
  /// - page: Page number (1-indexed)
  /// - limit: Items per page (1-100)
  /// - type: Filter by activity type ('all', 'habit-completion', 'focus-completed', etc.)
  /// 
  /// Returns: List of activities
  Future<List<Map<String, dynamic>>> getActivityFeed({
    int page = 1,
    int limit = 20,
    String type = 'all',
  }) async {
    try {
      log.i('Fetching activity feed: page=$page, limit=$limit, type=$type');
      
      final response = await _apiClient.get(
        ApiEndpoints.activityFeed,
        queryParameters: {
          'page': page,
          'limit': limit,
          'type': type,
        },
      );
      
      final list = response['data'] as List<dynamic>;
      final activities = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${activities.length} activities');
      return activities;
    } catch (e) {
      log.e('❌ Error fetching activity feed', error: e);
      rethrow;
    }
  }

  /// Get today's activities
  /// 
  /// Returns: List of activities from today
  Future<List<Map<String, dynamic>>> getTodayActivities() async {
    try {
      log.i('Fetching today\'s activities');
      
      final response = await _apiClient.get(ApiEndpoints.activityToday);
      
      final list = response['data'] as List<dynamic>;
      final activities = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${activities.length} activities from today');
      return activities;
    } catch (e) {
      log.e('❌ Error fetching today\'s activities', error: e);
      rethrow;
    }
  }

  /// Get activities filtered by type
  /// 
  /// Parameters:
  /// - type: Activity type ('habit-completion', 'focus-completed', 'streak-milestone', 'level-up', etc.)
  /// - limit: Maximum items to retrieve (1-100)
  /// 
  /// Returns: List of activities matching the type
  Future<List<Map<String, dynamic>>> getActivitiesByType({
    required String type,
    int limit = 10,
  }) async {
    try {
      log.i('Fetching activities of type: $type (limit: $limit)');
      
      final response = await _apiClient.get(
        ApiEndpoints.activityByType(type),
        queryParameters: {'limit': limit},
      );
      
      final list = response['data'] as List<dynamic>;
      final activities = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${activities.length} $type activities');
      return activities;
    } catch (e) {
      log.e('❌ Error fetching activities by type', error: e);
      rethrow;
    }
  }

  /// Get activity summary (counts by type)
  /// 
  /// Returns: Object with totalActivities, counts by type, total XP
  Future<Map<String, dynamic>> getActivitySummary() async {
    try {
      log.i('Fetching activity summary');
      
      final response = await _apiClient.get(ApiEndpoints.activitySummary);
      
      log.i('✅ Activity summary retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching activity summary', error: e);
      rethrow;
    }
  }

  /// Get user's achievements and badges
  /// 
  /// Returns: List of achievements with unlock status, progress
  Future<List<Map<String, dynamic>>> getAchievements() async {
    try {
      log.i('Fetching achievements');
      
      final response = await _apiClient.get(ApiEndpoints.activityAchievements);
      
      final list = response['data'] as List<dynamic>;
      final achievements = list.map((item) => item as Map<String, dynamic>).toList();
      
      log.i('✅ Retrieved ${achievements.length} achievements');
      return achievements;
    } catch (e) {
      log.e('❌ Error fetching achievements', error: e);
      rethrow;
    }
  }

  /// Share an activity to community
  /// 
  /// Parameters:
  /// - activityId: ID of the activity to share
  /// 
  /// Returns: Activity with shared status
  Future<Map<String, dynamic>> shareActivity(String activityId) async {
    try {
      log.i('Sharing activity: $activityId');
      
      final response = await _apiClient.post(
        ApiEndpoints.activityShare(activityId),
      );
      
      log.i('✅ Activity shared');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error sharing activity', error: e);
      rethrow;
    }
  }
}
