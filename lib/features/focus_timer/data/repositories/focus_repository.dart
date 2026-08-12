import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';

/// Repository for focus session operations
/// Acts as intermediary between data sources and domain layer
/// All API calls go through ApiClient for centralized error handling
/// 
/// ✅ FRESH BUILD - Start, Pause, Resume, Stop fully implemented
class FocusRepository {
  const FocusRepository(this._apiClient);

  final ApiClient _apiClient;

  // ════════════════════════════════════════════════════
  // ✅ START SESSION - Create new focus session
  // ════════════════════════════════════════════════════
  
  /// Start a new focus session
  /// 
  /// Parameters:
  /// - sessionType: '25min', '50min', or 'custom'
  /// - duration: Duration in minutes (1-300)
  /// 
  /// Returns: FocusSession with id, status='active', startedAt timestamp
  /// Throws: DioException on network errors
  Future<FocusSession> startSession({
    required String sessionType,
    required int duration,
  }) async {
    try {
      log.i('🚀 STARTING focus session: $sessionType for $duration minutes');
      
      final response = await _apiClient.post(
        ApiEndpoints.focusSessions,
        data: {
          'sessionType': sessionType,
          'duration': duration,
        },
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Focus session STARTED: ${session.id} | Status: ${session.status}');
      return session;
    } catch (e) {
      log.e('❌ Error starting focus session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ PAUSE SESSION - Pause active session
  // ════════════════════════════════════════════════════
  
  /// Pause the active focus session
  /// 
  /// Parameters:
  /// - sessionId: ID of the active session
  /// 
  /// Returns: FocusSession with status='paused', pausedAt timestamp
  Future<FocusSession> pauseSession(String sessionId) async {
    try {
      log.i('⏸️ PAUSING focus session: $sessionId');
      
      final response = await _apiClient.post(
        '/focus/$sessionId/pause',
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Focus session PAUSED: ${session.id} | Elapsed: ${session.elapsedSeconds}s');
      return session;
    } catch (e) {
      log.e('❌ Error pausing focus session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ RESUME SESSION - Resume paused session
  // ════════════════════════════════════════════════════
  
  /// Resume a paused focus session
  /// 
  /// Parameters:
  /// - sessionId: ID of the paused session
  /// 
  /// Returns: FocusSession with status='active', updated timestamps
  Future<FocusSession> resumeSession(String sessionId) async {
    try {
      log.i('▶️ RESUMING focus session: $sessionId');
      
      final response = await _apiClient.post(
        '/focus/$sessionId/resume',
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Focus session RESUMED: ${session.id} | Status: ${session.status}');
      return session;
    } catch (e) {
      log.e('❌ Error resuming focus session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ STOP SESSION - End current session
  // ════════════════════════════════════════════════════
  
  /// Stop/end the active focus session
  /// 
  /// Parameters:
  /// - sessionId: ID of the session to stop
  /// 
  /// Returns: FocusSession with status='stopped', completedAt timestamp
  Future<FocusSession> stopSession(String sessionId) async {
    try {
      log.i('⏹️ STOPPING focus session: $sessionId');
      
      final response = await _apiClient.post(
        '/focus/$sessionId/stop',
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Focus session STOPPED: ${session.id} | Total: ${session.elapsedSeconds}s');
      return session;
    } catch (e) {
      log.e('❌ Error stopping focus session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // GET ACTIVE SESSION - Fetch current session
  // ════════════════════════════════════════════════════
  
  /// Get user's currently active focus session
  /// 
  /// Returns: FocusSession if active, null if none
  /// Used to initialize UI on app start
  Future<FocusSession?> getActiveSession() async {
    try {
      log.i('📍 Fetching active focus session');
      
      final response = await _apiClient.get(ApiEndpoints.focusActive);
      
      if (response['data'] == null) {
        log.i('⚠️ No active focus session');
        return null;
      }

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Active session retrieved: ${session.id} | Status: ${session.status}');
      return session;
    } catch (e) {
      log.e('❌ Error fetching active session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // SESSION HISTORY
  // ════════════════════════════════════════════════════
  
  /// Get user's focus session history with pagination
  /// 
  /// Parameters:
  /// - page: Page number (1-indexed)
  /// - limit: Items per page (1-100)
  /// 
  /// Returns: List of FocusSession objects
  Future<List<FocusSession>> getSessionHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      log.i('📋 Fetching focus session history: page=$page, limit=$limit');
      
      final response = await _apiClient.get(
        ApiEndpoints.focusHistory,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final list = response['data'] as List<dynamic>;
      final sessions = list
          .map((item) => FocusSession.fromJson(item as Map<String, dynamic>))
          .toList();
      
      log.i('✅ Retrieved ${sessions.length} sessions from history');
      return sessions;
    } catch (e) {
      log.e('❌ Error fetching session history', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // SESSION COMPLETION (Legacy - kept for compatibility)
  // ════════════════════════════════════════════════════
  
  /// Mark a focus session as completed and award XP
  /// 
  /// Parameters:
  /// - sessionId: ID of the session to complete
  /// 
  /// Returns: FocusSession with xpEarned, new level, etc.
  Future<FocusSession> completeSession(String sessionId) async {
    try {
      log.i('🏁 Completing focus session: $sessionId');
      
      final response = await _apiClient.post(
        ApiEndpoints.focusComplete(sessionId),
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('✅ Session completed. XP earned: ${session.xpReward}');
      return session;
    } catch (e) {
      log.e('❌ Error completing session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // SESSION ABANDONMENT (Legacy - kept for compatibility)
  // ════════════════════════════════════════════════════
  
  /// Abandon a focus session without earning XP
  /// 
  /// Parameters:
  /// - sessionId: ID of the session to abandon
  /// 
  /// Returns: FocusSession with status='abandoned'
  Future<FocusSession> abandonSession(String sessionId) async {
    try {
      log.i('❌ Abandoning focus session: $sessionId');
      
      final response = await _apiClient.post(
        ApiEndpoints.focusAbandon(sessionId),
      );

      final session = FocusSession.fromJson(response['data'] as Map<String, dynamic>);
      log.i('⚠️ Session abandoned');
      return session;
    } catch (e) {
      log.e('❌ Error abandoning session', error: e);
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // STATISTICS
  // ════════════════════════════════════════════════════
  
  /// Get today's focus statistics
  /// 
  /// Returns: Object containing totalSessions, completedSessions, totalMinutes, totalXP
  Future<Map<String, dynamic>> getDailyStats() async {
    try {
      log.i("📊 Fetching today's focus statistics");
      
      final response = await _apiClient.get(ApiEndpoints.focusDailyStats);
      
      log.i('✅ Daily stats retrieved');
      
      // Handle null or empty response
      if (response['data'] == null) {
        return {
          'completedSessions': 0,
          'totalMinutes': 0,
          'totalXP': 0,
        };
      }
      
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching daily stats', error: e);
      // Return default values on error instead of throwing
      return {
        'completedSessions': 0,
        'totalMinutes': 0,
        'totalXP': 0,
      };
    }
  }

  /// Get this week's focus statistics
  /// 
  /// Returns: Object with weekly stats including daily breakdown
  Future<Map<String, dynamic>> getWeeklyStats() async {
    try {
      log.i("📊 Fetching this week's focus statistics");
      
      final response = await _apiClient.get(ApiEndpoints.focusWeeklyStats);
      
      log.i('✅ Weekly stats retrieved');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.e('❌ Error fetching weekly stats', error: e);
      rethrow;
    }
  }
}
