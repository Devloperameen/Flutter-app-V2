import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/core/utils/app_logger.dart';

part 'habits_stream_provider.g.dart';

/// Stream all habits for the current user
/// Rebuilds UI automatically when Firestore data changes
/// NO manual refresh needed, NO optimistic updates
@riverpod
Stream<List<Habit>> habitsStream(HabitsStreamRef ref) {
  final userId = ref.watch(authRepositoryProvider).getCurrentUserId();
  
  if (userId == null || userId.isEmpty) {
    log.w('⚠️ No authenticated user');
    return Stream.value([]);
  }

  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitsStream(userId);
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
    error: (_, __) => 0,
  );
}

/// Get total longest streak sum
@riverpod
int totalLongestStreak(TotalLongestStreakRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.fold(0, (sum, h) => sum + h.longestStreak),
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Get habits completed today
@riverpod
List<Habit> completedHabitsToday(CompletedHabitsTodayRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => h.completedToday).toList(),
    loading: () => [],
    error: (_, __) => [],
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
    error: (_, __) => [],
  );
}

/// Get non-archived habits
@riverpod
List<Habit> activeHabits(ActiveHabitsRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => !h.archived).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Get archived habits
@riverpod
List<Habit> archivedHabits(ArchivedHabitsRef ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  return habitsAsync.when(
    data: (habits) => habits.where((h) => h.archived).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}
