import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/data/datasources/habit_datasource_interface.dart';

/// Mock habit datasource for testing without Firebase.
/// Use this while Firestore security rules are being configured.
class MockHabitDatasource implements IHabitDatasource {
  static final MockHabitDatasource _instance = MockHabitDatasource._internal();

  factory MockHabitDatasource() {
    return _instance;
  }

  MockHabitDatasource._internal();

  final Map<String, List<Habit>> _habitsMap = {};
  final Map<String, Map<String, List<DateTime>>> _completionsMap = {};

  /// Stream all habits for user (mock version)
  Stream<List<Habit>> getHabitsStream(String userId) {
    log.i('🔄 Fetching habits from mock datasource for user: $userId');
    _initializeUserHabits(userId);
    
    // Return initial data as a stream
    return Stream.value(_habitsMap[userId] ?? []);
  }

  /// Get single habit (mock version)
  Future<Habit> getHabit(String userId, String habitId) async {
    _initializeUserHabits(userId);
    final habits = _habitsMap[userId] ?? [];
    final habit = habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => throw Exception('Habit not found: $habitId'),
    );
    return habit;
  }

  /// Create a new habit (mock version)
  Future<Habit> createHabit(String userId, Habit habit) async {
    log.i('➕ [MOCK] Creating habit: ${habit.title}');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    habits.add(habit);
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit created: ${habit.id}');
    return habit;
  }

  /// Update habit metadata (mock version)
  Future<void> updateHabit(String userId, Habit habit) async {
    log.i('✏️ [MOCK] Updating habit: ${habit.id}');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    final index = habits.indexWhere((h) => h.id == habit.id);
    
    if (index == -1) {
      throw Exception('Habit not found: ${habit.id}');
    }
    
    habits[index] = habit;
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit updated');
  }

  /// Mark habit as completed for today (mock version)
  Future<Habit> markHabitComplete(String userId, String habitId) async {
    log.i('✅ [MOCK] Marking habit complete: $habitId');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    final index = habits.indexWhere((h) => h.id == habitId);
    
    if (index == -1) {
      throw Exception('Habit not found: $habitId');
    }
    
    final habit = habits[index];
    
    // Check if already completed today
    if (habit.completedToday) {
      log.i('⚠️ [MOCK] Habit already completed today');
      return habit;
    }
    
    // Calculate new streak
    int newStreak = habit.currentStreak + 1;
    int newLongestStreak = (newStreak > habit.longestStreak) ? newStreak : habit.longestStreak;
    
    final updatedHabit = habit.copyWith(
      completedToday: true,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      totalCompletions: habit.totalCompletions + 1,
      lastCompletedDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    habits[index] = updatedHabit;
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit marked complete. Streak: $newStreak');
    return updatedHabit;
  }

  /// Undo habit completion for today (mock version)
  Future<Habit> undoHabitComplete(String userId, String habitId) async {
    log.i('↩️ [MOCK] Undoing completion: $habitId');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    final index = habits.indexWhere((h) => h.id == habitId);
    
    if (index == -1) {
      throw Exception('Habit not found: $habitId');
    }
    
    final habit = habits[index];
    
    if (!habit.completedToday) {
      log.w('⚠️ [MOCK] Habit not completed today, nothing to undo');
      return habit;
    }
    
    int newStreak = (habit.currentStreak - 1).clamp(0, 999999);
    
    final updatedHabit = habit.copyWith(
      completedToday: false,
      currentStreak: newStreak,
      totalCompletions: (habit.totalCompletions - 1).clamp(0, 999999),
      updatedAt: DateTime.now(),
    );
    
    habits[index] = updatedHabit;
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Completion undone. Streak: $newStreak');
    return updatedHabit;
  }

  /// Archive a habit (mock version)
  Future<void> archiveHabit(String userId, String habitId) async {
    log.i('📦 [MOCK] Archiving habit: $habitId');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    final index = habits.indexWhere((h) => h.id == habitId);
    
    if (index == -1) {
      throw Exception('Habit not found: $habitId');
    }
    
    final habit = habits[index];
    habits[index] = habit.copyWith(archived: true);
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit archived');
  }

  /// Restore an archived habit (mock version)
  Future<void> restoreHabit(String userId, String habitId) async {
    log.i('♻️ [MOCK] Restoring habit: $habitId');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    final index = habits.indexWhere((h) => h.id == habitId);
    
    if (index == -1) {
      throw Exception('Habit not found: $habitId');
    }
    
    final habit = habits[index];
    habits[index] = habit.copyWith(archived: false);
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit restored');
  }

  /// Delete a habit permanently (mock version)
  Future<void> deleteHabit(String userId, String habitId) async {
    log.i('🗑️ [MOCK] Deleting habit: $habitId');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    habits.removeWhere((h) => h.id == habitId);
    _habitsMap[userId] = habits;
    
    log.i('✅ [MOCK] Habit deleted');
  }

  /// Duplicate a habit (mock version)
  Future<Habit> duplicateHabit(String userId, String habitId) async {
    log.i('📋 [MOCK] Duplicating habit: $habitId');
    
    final original = await getHabit(userId, habitId);
    final newHabit = original.copyWith(
      id: _generateHabitId(),
      title: '${original.title} (Copy)',
      currentStreak: 0,
      longestStreak: 0,
      totalCompletions: 0,
      completedToday: false,
      lastCompletedDate: null,
    );
    
    return createHabit(userId, newHabit);
  }

  /// Reorder habits (mock version)
  Future<void> reorderHabits(String userId, List<String> habitIds) async {
    log.i('🔄 [MOCK] Reordering ${habitIds.length} habits');
    _initializeUserHabits(userId);
    
    final habits = _habitsMap[userId] ?? [];
    for (int i = 0; i < habitIds.length; i++) {
      final index = habits.indexWhere((h) => h.id == habitIds[i]);
      if (index != -1) {
        habits[index] = habits[index].copyWith(order: i);
      }
    }
    
    _habitsMap[userId] = habits;
    log.i('✅ [MOCK] Habits reordered');
  }

  /// Get completion history (mock version)
  Future<List<DateTime>> getCompletionHistory(
    String userId,
    String habitId,
  ) async {
    // For mock, return empty list
    return [];
  }

  /// Initialize user habits if not exists
  void _initializeUserHabits(String userId) {
    if (!_habitsMap.containsKey(userId)) {
      _habitsMap[userId] = [];
      log.i('📝 Initialized habits for user: $userId');
    }
  }

  /// Generate unique habit ID
  String _generateHabitId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Clear all mock data (for testing)
  void clearAllData() {
    _habitsMap.clear();
    log.i('🗑️ [MOCK] All data cleared');
  }
}
