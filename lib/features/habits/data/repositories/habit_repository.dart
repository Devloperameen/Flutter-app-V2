import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/data/datasources/habit_datasource_interface.dart';
import 'package:safe/features/habits/data/datasources/http_habit_datasource.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

part 'habit_repository.g.dart';

/// Riverpod provider for HabitRepository
/// Using HTTP datasource (Express.js backend with MongoDB)
@riverpod
HabitRepository habitRepository(HabitRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HabitRepository(
    datasource: HttpHabitDatasource(apiClient: apiClient),
  );
}

/// Repository for Habit operations.
/// Delegates all operations to either Firestore or Mock datasource.
/// No duplicate logic, no caching, datasource is the only source of truth.
class HabitRepository {
  HabitRepository({
    required this._datasource,
  });

  final IHabitDatasource _datasource;

  /// Stream all habits for user
  Stream<List<Habit>> getHabitsStream(String userId) {
    return _datasource.getHabitsStream(userId);
  }

  /// Get single habit
  Future<Habit> getHabit(String userId, String habitId) {
    return _datasource.getHabit(userId, habitId);
  }

  /// Create a new habit
  Future<Habit> createHabit(String userId, Habit habit) async {
    try {
      return await _datasource.createHabit(userId, habit);
    } catch (e) {
      // If permission denied or server error, log and rethrow
      log.e('❌ Failed to create habit: $e');
      rethrow;
    }
  }

  /// Update habit metadata
  Future<void> updateHabit(String userId, Habit habit) {
    return _datasource.updateHabit(userId, habit);
  }

  /// Mark habit as completed for today
  Future<Habit> markHabitComplete(String userId, String habitId) {
    return _datasource.markHabitComplete(userId, habitId);
  }

  /// Undo habit completion for today
  Future<Habit> undoHabitComplete(String userId, String habitId) {
    return _datasource.undoHabitComplete(userId, habitId);
  }

  /// Archive a habit
  Future<void> archiveHabit(String userId, String habitId) {
    return _datasource.archiveHabit(userId, habitId);
  }

  /// Restore an archived habit
  Future<void> restoreHabit(String userId, String habitId) {
    return _datasource.restoreHabit(userId, habitId);
  }

  /// Delete a habit permanently
  Future<void> deleteHabit(String userId, String habitId) {
    return _datasource.deleteHabit(userId, habitId);
  }

  /// Duplicate a habit
  Future<Habit> duplicateHabit(String userId, String habitId) {
    return _datasource.duplicateHabit(userId, habitId);
  }

  /// Reorder habits
  Future<void> reorderHabits(String userId, List<String> habitIds) {
    return _datasource.reorderHabits(userId, habitIds);
  }

  /// Get completion history
  Future<List<DateTime>> getCompletionHistory(
    String userId,
    String habitId,
  ) {
    return _datasource.getCompletionHistory(userId, habitId);
  }
}
