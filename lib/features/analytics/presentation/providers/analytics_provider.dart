import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/analytics/presentation/notifiers/analytics_notifier.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:safe/features/habits/presentation/providers/habits_stream_provider.dart';

part 'analytics_provider.g.dart';

/// Main analytics state provider
@riverpod
AnalyticsState analytics(AnalyticsRef ref) {
  return ref.watch(analyticsNotifierProvider);
}

/// Habit analytics provider with real-time updates
@riverpod
Future<HabitAnalytics> habitAnalytics(HabitAnalyticsRef ref) async {
  final state = ref.watch(analyticsNotifierProvider);
  
  // Depend on habits stream to get real-time updates
  final habits = await ref.watch(habitsStreamProvider.future);
  
  if (state.data == null) {
    return HabitAnalytics.empty();
  }
  
  return state.data!.habitAnalytics;
}

/// Get selected period label
@riverpod
String selectedPeriodLabel(SelectedPeriodLabelRef ref) {
  final state = ref.watch(analyticsNotifierProvider);
  return state.selectedPeriod.type.label;
}

/// Get filtered categories
@riverpod
List<String> availableCategories(AvailableCategoriesRef ref) {
  final habits = ref.watch(habitsStreamProvider);
  return habits.when(
    data: (habits) {
      final categories = <String>{};
      for (final habit in habits) {
        if (!habit.archived) {
          categories.add(habit.category);
        }
      }
      return categories.toList()..sort();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Check if analytics data is empty
@riverpod
bool isAnalyticsEmpty(IsAnalyticsEmptyRef ref) {
  final state = ref.watch(analyticsNotifierProvider);
  if (state.data == null) return true;
  
  final data = state.data!;
  return data.habitAnalytics.totalHabits == 0 &&
      data.focusAnalytics.totalSessions == 0;
}

/// Get comparison with previous period
@riverpod
Future<AnalyticsComparison> periodComparison(PeriodComparisonRef ref) async {
  final state = ref.watch(analyticsNotifierProvider);
  final userId = ref.read(authRepositoryProvider).getCurrentUserId();
  
  if (userId == null || state.data == null) {
    return AnalyticsComparison.empty();
  }

  try {
    final repository = ref.read(analyticsRepositoryProvider);
    final previousPeriod = _getPreviousPeriod(state.selectedPeriod);
    
    final previousData = await repository.getAnalytics(
      userId: userId,
      period: previousPeriod,
      categoryFilter: state.selectedCategory,
    );

    return AnalyticsComparison(
      currentCompletions: state.data!.habitAnalytics.completedCount,
      previousCompletions: previousData.habitAnalytics.completedCount,
      currentXp: state.data!.focusAnalytics.totalXpEarned,
      previousXp: previousData.focusAnalytics.totalXpEarned,
      currentFocusMinutes: state.data!.focusAnalytics.completedMinutes,
      previousFocusMinutes: previousData.focusAnalytics.completedMinutes,
    );
  } catch (e) {
    return AnalyticsComparison.empty();
  }
}

/// Calculate percentage change between periods
@riverpod
double percentageChange(PercentageChangeRef ref, {
  required int current,
  required int previous,
}) {
  if (previous == 0) return 0;
  return ((current - previous) / previous * 100);
}

/// Get analytics state for a specific habit
@riverpod
Future<HabitPerformance?> habitPerformance(
  HabitPerformanceRef ref, {
  required String habitId,
}) async {
  final state = ref.watch(analyticsNotifierProvider);
  final userId = ref.read(authRepositoryProvider).getCurrentUserId();
  
  if (userId == null || state.data == null) {
    return null;
  }

  try {
    final repository = ref.read(analyticsRepositoryProvider);
    return await repository.getHabitPerformance(
      userId: userId,
      habitId: habitId,
      period: state.selectedPeriod,
    );
  } catch (e) {
    return null;
  }
}

/// Get analytics insights as a stream
@riverpod
Stream<List<String>> analyticsInsights(AnalyticsInsightsRef ref) async* {
  final state = ref.watch(analyticsNotifierProvider);
  
  if (state.data == null) {
    yield [];
    return;
  }

  final insights = state.data!.insights.map((i) => i.message).toList();
  yield insights;
}

// ─────────────────────────────────────────────────────────────────
// Helper Models & Functions
// ─────────────────────────────────────────────────────────────────

/// Model for comparing two periods
class AnalyticsComparison {
  final int currentCompletions;
  final int previousCompletions;
  final int currentXp;
  final int previousXp;
  final int currentFocusMinutes;
  final int previousFocusMinutes;

  AnalyticsComparison({
    required this.currentCompletions,
    required this.previousCompletions,
    required this.currentXp,
    required this.previousXp,
    required this.currentFocusMinutes,
    required this.previousFocusMinutes,
  });

  factory AnalyticsComparison.empty() => AnalyticsComparison(
    currentCompletions: 0,
    previousCompletions: 0,
    currentXp: 0,
    previousXp: 0,
    currentFocusMinutes: 0,
    previousFocusMinutes: 0,
  );

  int get completionsDiff => currentCompletions - previousCompletions;
  int get xpDiff => currentXp - previousXp;
  int get focusMinutesDiff => currentFocusMinutes - previousFocusMinutes;

  double get completionsChangePercent {
    if (previousCompletions == 0) return 0;
    return (completionsDiff / previousCompletions * 100);
  }

  double get xpChangePercent {
    if (previousXp == 0) return 0;
    return (xpDiff / previousXp * 100);
  }

  double get focusMinutesChangePercent {
    if (previousFocusMinutes == 0) return 0;
    return (focusMinutesDiff / previousFocusMinutes * 100);
  }

  bool get hasImproved => completionsDiff > 0;
  bool get hasDeclined => completionsDiff < 0;
}

/// Get the previous period relative to the current period
AnalyticsPeriod _getPreviousPeriod(AnalyticsPeriod current) {
  switch (current.type) {
    case AnalyticsPeriodType.week:
      final prevEnd = current.startDate.subtract(const Duration(days: 1));
      final prevStart = prevEnd.subtract(const Duration(days: 6));
      return AnalyticsPeriod(
        type: AnalyticsPeriodType.week,
        startDate: prevStart,
        endDate: prevEnd,
      );
    case AnalyticsPeriodType.month:
      final prevMonth = DateTime(current.startDate.year, current.startDate.month - 1);
      final lastDay = DateTime(prevMonth.year, prevMonth.month + 1).subtract(const Duration(days: 1));
      return AnalyticsPeriod(
        type: AnalyticsPeriodType.month,
        startDate: DateTime(prevMonth.year, prevMonth.month),
        endDate: lastDay,
      );
    case AnalyticsPeriodType.allTime:
    case AnalyticsPeriodType.custom:
      // For all-time and custom, return a month before
      final prevMonth = current.startDate.subtract(const Duration(days: 30));
      return AnalyticsPeriod(
        type: current.type,
        startDate: prevMonth,
        endDate: current.startDate.subtract(const Duration(days: 1)),
      );
  }
}
