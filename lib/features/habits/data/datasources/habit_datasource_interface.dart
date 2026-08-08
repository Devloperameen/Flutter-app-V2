import 'package:safe/features/habits/domain/models/habit.dart';

/// Common interface for habit datasources (Firestore or Mock)
abstract class IHabitDatasource {
  Stream<List<Habit>> getHabitsStream(String userId);
  Future<Habit> getHabit(String userId, String habitId);
  Future<Habit> createHabit(String userId, Habit habit);
  Future<void> updateHabit(String userId, Habit habit);
  Future<Habit> markHabitComplete(String userId, String habitId);
  Future<Habit> undoHabitComplete(String userId, String habitId);
  Future<void> archiveHabit(String userId, String habitId);
  Future<void> restoreHabit(String userId, String habitId);
  Future<void> deleteHabit(String userId, String habitId);
  Future<Habit> duplicateHabit(String userId, String habitId);
  Future<void> reorderHabits(String userId, List<String> habitIds);
  Future<List<DateTime>> getCompletionHistory(String userId, String habitId);
}
