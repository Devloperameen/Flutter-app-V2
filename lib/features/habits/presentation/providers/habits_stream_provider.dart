import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/data/repositories/habit_repository.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

part 'habits_stream_provider.g.dart';

/// Stream all habits for the current user
/// Rebuilds UI automatically when Firestore data changes
/// NO manual refresh needed, NO optimistic updates
@Riverpod(keepAlive: true)
Stream<List<Habit>> habitsStream(HabitsStreamRef ref) async* {
  final storage = ref.read(secureStorageProvider);
  final userId = await storage.read(StorageKeys.userId);

  if (userId == null || userId.isEmpty) {
    log.w('⚠️ No authenticated user — returning empty habits stream');
    yield [];
    return;
  }

  final repository = ref.watch(habitRepositoryProvider);
  // Let errors propagate so UI can distinguish offline vs empty
  yield* repository.getHabitsStream(userId);
}

/// Get total completion percentage
@riverpod
Future<double> completionPercentage(CompletionPercentageRef ref) async {
  final habits = await ref.watch(habitsStreamProvider.future);
  if (habits.isEmpty) return 0;
  
  final completed = habits.where((h) => h.completedToday).length;
  return (completed / habits.length) * 100;
}

/// Get total current streak sum
@riverpod
int totalCurrentStreak(TotalCurrentStreakRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.fold(0, (sum, h) => sum + h.currentStreak),
    loading: () => 0,
    error: (_, _) => 0,
  );
}

/// Get total longest streak sum
@riverpod
int totalLongestStreak(TotalLongestStreakRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.fold(0, (sum, h) => sum + h.longestStreak),
    loading: () => 0,
    error: (_, _) => 0,
  );
}

/// Get habits completed today
@riverpod
List<Habit> completedHabitsToday(CompletedHabitsTodayRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => h.completedToday).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}

/// Get habits not completed today
@riverpod
List<Habit> pendingHabitsToday(PendingHabitsTodayRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) =>
        habits.where((h) => !h.completedToday && !h.archived).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}

/// Get non-archived habits
@riverpod
List<Habit> activeHabits(ActiveHabitsRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => !h.archived).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}

/// Get archived habits
@riverpod
List<Habit> archivedHabits(ArchivedHabitsRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => h.archived).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}
