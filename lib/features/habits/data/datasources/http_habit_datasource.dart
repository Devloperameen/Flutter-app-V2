/// ============================================
/// HTTP Habit Datasource
/// ============================================
/// 
/// Connects to Express.js backend via HTTP
/// Replaces Firebase/Firestore implementation
/// 
/// Handles:
/// - HTTP requests to backend API
/// - JSON serialization/deserialization
/// - Error handling & logging
library;

import 'package:dio/dio.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/data/datasources/habit_datasource_interface.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

/// HTTP-based implementation of habit datasource
/// Uses Express.js backend with MongoDB
class HttpHabitDatasource implements IHabitDatasource {

  HttpHabitDatasource({required this.apiClient});
  /// Dependency: API client (Dio HTTP client)
  final ApiClient apiClient;

  /// Get all habits for user as stream
  /// 
  /// Note: HTTP doesn't support real-time streams like Firestore
  /// So we convert Future to Stream by polling
  /// For production, consider WebSockets for real-time updates
  @override
  Stream<List<Habit>> getHabitsStream(String userId) async* {
    try {
      log.i('📡 Fetching habits stream from backend');

      // Get initial list
      final response = await apiClient.get(ApiEndpoints.habits);
      final habits = _parseHabitsFromResponse(response);

      yield habits;
      log.i('✅ Habits stream fetched: ${habits.length} habits');
    } catch (e, st) {
      log.e('❌ Error fetching habits stream: $e');
      // Propagate error so UI can show offline state instead of empty
      yield* Stream.error(e, st);
    }
  }

  /// Get single habit by ID
  @override
  Future<Habit> getHabit(String userId, String habitId) async {
    try {
      log.i('🔍 Fetching habit: $habitId');
      
      final response = await apiClient.get(
        ApiEndpoints.habit(habitId),
      );

      // Extract habit from 'data' field in response
      final habitData = response['data'] as Map<String, dynamic>;
      if (habitData.containsKey('_id') && !habitData.containsKey('id')) {
        habitData['id'] = habitData['_id'];
      }
      _sanitizeHabitData(habitData);
      final habit = Habit.fromJson(habitData);

      log.i('✅ Habit fetched: ${habit.title}');
      return habit;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching habit: $e');
      rethrow;
    }
  }

  /// Create a new habit
  @override
  @override
  Future<Habit> createHabit(String userId, Habit habit) async {
    try {
      log.i('➕ Creating habit: ${habit.title}');

      // Convert habit to JSON for API
      final habitJson = habit.toJson();
      
      log.d('Sending habit data: ${habitJson.toString()}');

      // Make POST request to backend
      final response = await apiClient.post(
        ApiEndpoints.habits,
        data: habitJson,
      );

      // Parse response
      final habitData = response['data'] as Map<String, dynamic>;
      if (habitData.containsKey('_id') && !habitData.containsKey('id')) {
        habitData['id'] = habitData['_id'];
      }
      
      // Sanitize data before parsing
      _sanitizeHabitData(habitData);
      
      final createdHabit = Habit.fromJson(habitData);

      log.i('✅ Habit created: ${createdHabit.title}');
      return createdHabit;
    } on DioException catch (e) {
      log.e('❌ Dio error creating habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error creating habit: $e');
      rethrow;
    }
  }

  /// Update habit metadata
  @override
  Future<void> updateHabit(String userId, Habit habit) async {
    try {
      log.i('✏️ Updating habit: ${habit.id}');

      final habitJson = habit.toJson();

      await apiClient.put(
        ApiEndpoints.habit(habit.id),
        data: habitJson,
      );

      log.i('✅ Habit updated: ${habit.title}');
    } on DioException catch (e) {
      log.e('❌ Dio error updating habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error updating habit: $e');
      rethrow;
    }
  }

  /// Mark habit as completed for today
  @override
  Future<Habit> markHabitComplete(String userId, String habitId) async {
    try {
      log.i('✅ Marking habit complete: $habitId');

      // POST to /habits/:id/complete endpoint
      final response = await apiClient.post(
        ApiEndpoints.habitComplete(habitId),
      );

      // Parse updated habit from response
      final habitData = response['data'] as Map<String, dynamic>;
      
      // Debug: Log the exact response data
      log.d('Habit response: ${habitData.toString()}');
      
      // Sanitize data: ensure all required fields have proper types
      _sanitizeHabitData(habitData);
      
      final habit = Habit.fromJson(habitData);

      log.i('✅ Habit marked complete - Streak: ${habit.currentStreak}');
      return habit;
    } on DioException catch (e) {
      log.e('❌ Dio error marking habit complete: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error marking habit complete: $e');
      rethrow;
    }
  }

  /// Sanitize habit data from backend response
  void _sanitizeHabitData(Map<String, dynamic> data) {
    // Ensure required String fields are not null
    if (data['id'] == null) data['id'] = '';
    if (data['title'] == null) data['title'] = 'Untitled Habit';
    if (data['emoji'] == null) data['emoji'] = '✨';
    if (data['color'] == null) data['color'] = '#FF6B6B';
    if (data['category'] == null) data['category'] = 'other';
    
    // Ensure numeric fields are numbers
    if (data['targetMinutes'] != null && data['targetMinutes'] is! num) {
      data['targetMinutes'] = int.tryParse(data['targetMinutes'].toString()) ?? 0;
    }
    if (data['currentStreak'] != null && data['currentStreak'] is! num) {
      data['currentStreak'] = int.tryParse(data['currentStreak'].toString()) ?? 0;
    }
    if (data['longestStreak'] != null && data['longestStreak'] is! num) {
      data['longestStreak'] = int.tryParse(data['longestStreak'].toString()) ?? 0;
    }
    if (data['totalCompletions'] != null && data['totalCompletions'] is! num) {
      data['totalCompletions'] = int.tryParse(data['totalCompletions'].toString()) ?? 0;
    }
    if (data['order'] != null && data['order'] is! num) {
      data['order'] = int.tryParse(data['order'].toString()) ?? 0;
    }
    
    // Ensure boolean fields are booleans
    if (data['reminderEnabled'] != null && data['reminderEnabled'] is! bool) {
      data['reminderEnabled'] = data['reminderEnabled'].toString().toLowerCase() == 'true';
    }
    if (data['completedToday'] != null && data['completedToday'] is! bool) {
      data['completedToday'] = data['completedToday'].toString().toLowerCase() == 'true';
    }
    if (data['archived'] != null && data['archived'] is! bool) {
      data['archived'] = data['archived'].toString().toLowerCase() == 'true';
    }
  }

  /// Undo habit completion for today
  @override
  Future<Habit> undoHabitComplete(String userId, String habitId) async {
    try {
      log.i('↩️ Undoing habit completion: $habitId');

      // POST to /habits/:id/undo endpoint
      final response = await apiClient.post(
        ApiEndpoints.habitUndo(habitId),
      );

      // Parse updated habit from response
      final habitData = response['data'] as Map<String, dynamic>;
      
      // Debug: Log the exact response data
      log.d('Undo habit response: ${habitData.toString()}');
      
      // Sanitize data
      _sanitizeHabitData(habitData);
      
      final habit = Habit.fromJson(habitData);

      log.i('✅ Habit completion undone - Streak: ${habit.currentStreak}');
      return habit;
    } on DioException catch (e) {
      log.e('❌ Dio error undoing habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error undoing habit completion: $e');
      rethrow;
    }
  }

  /// Archive a habit (soft delete)
  @override
  Future<void> archiveHabit(String userId, String habitId) async {
    try {
      log.i('📦 Archiving habit: $habitId');

      await apiClient.patch(
        '${ApiEndpoints.habit(habitId)}/archive',
      );

      log.i('✅ Habit archived');
    } on DioException catch (e) {
      log.e('❌ Dio error archiving habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error archiving habit: $e');
      rethrow;
    }
  }

  /// Restore an archived habit
  @override
  Future<void> restoreHabit(String userId, String habitId) async {
    try {
      log.i('♻️ Restoring habit: $habitId');

      await apiClient.patch(
        '${ApiEndpoints.habit(habitId)}/restore',
      );

      log.i('✅ Habit restored');
    } on DioException catch (e) {
      log.e('❌ Dio error restoring habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error restoring habit: $e');
      rethrow;
    }
  }

  /// Delete a habit permanently
  @override
  Future<void> deleteHabit(String userId, String habitId) async {
    try {
      log.i('🗑️ Deleting habit: $habitId');

      await apiClient.delete(
        ApiEndpoints.habit(habitId),
      );

      log.i('✅ Habit deleted');
    } on DioException catch (e) {
      log.e('❌ Dio error deleting habit: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error deleting habit: $e');
      rethrow;
    }
  }

  /// Duplicate a habit
  @override
  Future<Habit> duplicateHabit(String userId, String habitId) async {
    try {
      log.i('📋 Duplicating habit: $habitId');

      // First get the habit
      final original = await getHabit(userId, habitId);

      // Create copy with new title
      final copy = original.copyWith(
        id: _generateUniqueId(),
        title: '${original.title} (Copy)',
        currentStreak: 0,
        longestStreak: 0,
        totalCompletions: 0,
        completedToday: false,
        lastCompletedDate: null,
      );

      // Create the duplicate
      return await createHabit(userId, copy);
    } catch (e) {
      log.e('❌ Error duplicating habit: $e');
      rethrow;
    }
  }

  /// Reorder habits
  @override
  Future<void> reorderHabits(String userId, List<String> habitIds) async {
    try {
      log.i('🔄 Reordering ${habitIds.length} habits');

      await apiClient.post(
        '${ApiEndpoints.habits}/reorder',
        data: {'habitIds': habitIds},
      );

      log.i('✅ Habits reordered');
    } on DioException catch (e) {
      log.e('❌ Dio error reordering habits: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error reordering habits: $e');
      rethrow;
    }
  }

  /// Get completion history for a habit
  /// 
  /// Note: Backend doesn't have this endpoint yet
  /// For now, returns empty list
  @override
  Future<List<DateTime>> getCompletionHistory(
    String userId,
    String habitId,
  ) async {
    try {
      log.i('📅 Fetching completion history: $habitId');
      
      // TODO: Implement in backend if needed
      // For now, return empty list
      // You can get this data from the Habit model's lastCompletedDate
      
      final habit = await getHabit(userId, habitId);
      final history = <DateTime>[];
      
      if (habit.lastCompletedDate != null) {
        history.add(habit.lastCompletedDate!);
      }
      
      log.i('✅ Completion history fetched: ${history.length} dates');
      return history;
    } catch (e) {
      log.e('❌ Error fetching completion history: $e');
      return [];
    }
  }

  // ─── Helper Methods ────────────────────────────────

  /// Parse habits list from API response
  List<Habit> _parseHabitsFromResponse(dynamic response) {
    try {
      // Handle different response formats
      final dataList = response['data'] as List;
      
      return dataList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        if (map.containsKey('_id') && !map.containsKey('id')) {
          map['id'] = map['_id'];
        }
        _sanitizeHabitData(map);
        return Habit.fromJson(map);
      }).toList();
    } catch (e) {
      log.e('Error parsing habits response: $e');
      return [];
    }
  }

  /// Generate unique ID for habits
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
