import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/habits/data/datasources/habit_datasource_interface.dart';
import 'package:safe/features/habits/data/datasources/firestore_habit_datasource.dart';
import 'package:safe/features/habits/data/datasources/mock_habit_datasource.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/core/utils/app_logger.dart';

part 'habit_repository.g.dart';

/// Riverpod provider for HabitRepository
/// Using Firestore datasource with production security rules
@riverpod
HabitRepository habitRepository(HabitRepositoryRef ref) {
  return HabitRepository(
    datasource: FirestoreHabitDatasource(),
  );
}

/// Repository for Habit operations.
/// Delegates all operations to either Firestore or Mock datasource.
/// No duplicate logic, no caching, datasource is the only source of truth.
class HabitRepository {
  HabitRepository({
    required IHabitDatasource datasource,
  }) : _datasource = datasource;

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
      // If permission denied, log and rethrow with helpful message
      if (e.toString().contains('permission-denied')) {
        log.e('❌ Firestore permission denied. Check security rules.');
        throw Exception(
          'Permission denied. Please ensure Firestore rules allow authenticated users to create habits.\n\nRequired rules:\n'
          'match /users/{userId}/habits/{habitId} {\n'
          '  allow read, write: if request.auth.uid == userId;\n'
          '}'
        );
      }
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
