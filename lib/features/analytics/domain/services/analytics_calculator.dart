import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/focus_analytics.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/analytics/domain/models/personal_records.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

/// Service for calculating analytics metrics from raw data
class AnalyticsCalculator {
  /// Calculate habit analytics from habits list
  static HabitAnalytics calculateHabitAnalytics({
    required List<Habit> habits,
    required AnalyticsPeriod period,
    String? categoryFilter,
  }) {
    // Filter habits by category if specified
    final filteredHabits = categoryFilter != null
        ? habits.where((h) => h.category == categoryFilter && !h.archived).toList()
        : habits.where((h) => !h.archived).toList();

    if (filteredHabits.isEmpty) {
      return HabitAnalytics.empty();
    }

    // Calculate total opportunities (days in period * number of habits)
    final daysInPeriod = period.endDate.difference(period.startDate).inDays + 1;
    final totalOpportunities = filteredHabits.length * daysInPeriod;

    // Count completions for each habit
    final habitCompletions = <String, int>{};
    final habitCompletionRates = <String, double>{};
    var totalCompletions = 0;

    for (final habit in filteredHabits) {
      // For now, use totalCompletions from habit
      // TODO: Query actual completion records in period
      final completions = habit.totalCompletions;
      habitCompletions[habit.id] = completions;
      final rate = daysInPeriod > 0 ? (completions / daysInPeriod * 100.0) : 0.0;
      habitCompletionRates[habit.id] = rate.clamp(0.0, 100.0);
      totalCompletions += completions;
    }

    // Sort habits by completion rate
    final topHabits = habitCompletionRates.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate category completions
    final categoryCompletions = <String, int>{};
    for (final habit in filteredHabits) {
      categoryCompletions[habit.category] = 
          (categoryCompletions[habit.category] ?? 0) + habitCompletions[habit.id]!;
    }

    // Calculate overall completion rate
    final rate = totalOpportunities > 0
        ? (totalCompletions / totalOpportunities * 100.0)
        : 0.0;
    final completionRate = rate.clamp(0.0, 100.0);

    // Calculate streaks
    var currentStreak = 0;
    var longestStreak = 0;
    for (final habit in filteredHabits) {
      if (habit.completedToday) {
        currentStreak = habit.currentStreak;
      }
      if (habit.longestStreak > longestStreak) {
        longestStreak = habit.longestStreak;
      }
    }

    return HabitAnalytics(
      totalHabits: filteredHabits.length,
      completedCount: totalCompletions,
      totalOpportunities: totalOpportunities,
      completionRate: completionRate,
      habitCompletions: habitCompletions,
      habitCompletionRates: habitCompletionRates,
      topHabits: topHabits.map((e) => e.key).toList(),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      categoryCompletions: categoryCompletions,
      dailyData: [], // TODO: Populate from completion records
    );
  }

  /// Calculate focus analytics from focus sessions
  static FocusAnalytics calculateFocusAnalytics({
    required List<FocusSession> sessions,
    required AnalyticsPeriod period,
  }) {
    // Filter sessions within period
    final filteredSessions = sessions.where((session) {
      return session.startedAt.isAfter(period.startDate) &&
          session.startedAt.isBefore(period.endDate);
    }).toList();

    if (filteredSessions.isEmpty) {
      return FocusAnalytics.empty();
    }

    final completedSessions =
        filteredSessions.where((s) => s.status == 'completed').toList();

    // Calculate totals
    var totalMinutes = 0;
    var completedMinutes = 0;
    var totalXpEarned = 0;
    var longestSessionMinutes = 0;

    final sessionsByType = <String, int>{};
    final minutesByType = <String, int>{};

    for (final session in filteredSessions) {
      final minutes = session.durationSeconds ~/ 60;
      totalMinutes += minutes;

      if (session.status == 'completed') {
        final completedMins = session.completedSeconds ~/ 60;
        completedMinutes += completedMins;
        totalXpEarned += session.xpReward;

        if (completedMins > longestSessionMinutes) {
          longestSessionMinutes = completedMins;
        }

        // Group by session type
        sessionsByType[session.sessionType] =
            (sessionsByType[session.sessionType] ?? 0) + 1;
        minutesByType[session.sessionType] =
            (minutesByType[session.sessionType] ?? 0) + completedMins;
      }
    }

    final averageSessionMinutes = completedSessions.isNotEmpty
        ? completedMinutes / completedSessions.length
        : 0.0;

    // Calculate longest streak
    // TODO: Implement proper streak calculation from sorted sessions
    final longestStreak = 0;

    return FocusAnalytics(
      totalSessions: filteredSessions.length,
      completedSessions: completedSessions.length,
      totalMinutes: totalMinutes,
      completedMinutes: completedMinutes,
      totalXpEarned: totalXpEarned,
      averageSessionMinutes: averageSessionMinutes,
      longestSessionMinutes: longestSessionMinutes,
      sessionsByType: sessionsByType,
      minutesByType: minutesByType,
      dailyData: [], // TODO: Populate from session records
      longestStreak: longestStreak,
    );
  }

  /// Calculate personal records
  static PersonalRecords calculatePersonalRecords({
    required List<Habit> habits,
    required List<FocusSession> sessions,
  }) {
    final maxDailyHabits = 0;
    DateTime? maxDailyHabitsDate;
    final maxDailyXp = 0;
    DateTime? maxDailyXpDate;
    final maxDailyFocusMinutes = 0;
    DateTime? maxDailyFocusMinutesDate;
    var longestHabitStreak = 0;
    String? longestHabitStreakHabitId;
    var longestOverallStreak = 0;
    DateTime? longestOverallStreakEndDate;

    // Find longest habit streak
    for (final habit in habits) {
      if (habit.longestStreak > longestHabitStreak) {
        longestHabitStreak = habit.longestStreak;
        longestHabitStreakHabitId = habit.id;
      }
      if (habit.longestStreak > longestOverallStreak) {
        longestOverallStreak = habit.longestStreak;
        longestOverallStreakEndDate = habit.lastCompletedDate;
      }
    }

    // TODO: Calculate actual max daily records from historical data
    // For now, use current totals as baseline
    final currentDailyHabits = habits.where((h) => h.completedToday).length;

    return PersonalRecords(
      maxDailyHabits: currentDailyHabits > maxDailyHabits ? currentDailyHabits : maxDailyHabits,
      maxDailyHabitsDate: currentDailyHabits > maxDailyHabits ? DateTime.now() : maxDailyHabitsDate,
      maxDailyXp: maxDailyXp,
      maxDailyXpDate: maxDailyXpDate,
      maxDailyFocusMinutes: maxDailyFocusMinutes,
      maxDailyFocusMinutesDate: maxDailyFocusMinutesDate,
      longestHabitStreak: longestHabitStreak,
      longestHabitStreakHabitId: longestHabitStreakHabitId,
      longestOverallStreak: longestOverallStreak,
      longestOverallStreakEndDate: longestOverallStreakEndDate,
    );
  }

  /// Calculate habit performance for a specific habit
  static HabitPerformance calculateHabitPerformance({
    required Habit habit,
    required AnalyticsPeriod period,
  }) {
    final daysInPeriod = period.endDate.difference(period.startDate).inDays + 1;
    final completions = habit.totalCompletions;
    final rate = daysInPeriod > 0 ? (completions / daysInPeriod * 100.0) : 0.0;
    final completionRate = rate.clamp(0.0, 100.0);

    return HabitPerformance(
      habitId: habit.id,
      title: habit.title,
      emoji: habit.emoji,
      color: habit.color,
      category: habit.category,
      completions: completions,
      opportunities: daysInPeriod,
      completionRate: completionRate,
      currentStreak: habit.currentStreak,
      longestStreak: habit.longestStreak,
      lastCompleted: habit.lastCompletedDate,
      dailyData: [], // TODO: Populate from completion records
    );
  }
}
