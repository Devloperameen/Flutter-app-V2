import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_analytics.freezed.dart';
part 'habit_analytics.g.dart';

/// Analytics data for habit tracking
@freezed
class HabitAnalytics with _$HabitAnalytics {
  const factory HabitAnalytics({
    required int totalHabits,
    required int completedCount,
    required int totalOpportunities,
    required double completionRate, // Percentage (0-100)
    required Map<String, int> habitCompletions, // habitId -> completion count
    required Map<String, double> habitCompletionRates, // habitId -> rate
    required List<String> topHabits, // Sorted by completion rate
    required int currentStreak,
    required int longestStreak,
    required Map<String, int> categoryCompletions, // category -> count
    required List<DailyHabitData> dailyData,
  }) = _HabitAnalytics;

  factory HabitAnalytics.fromJson(Map<String, dynamic> json) =>
      _$HabitAnalyticsFromJson(json);

  /// Empty analytics state
  factory HabitAnalytics.empty() => const HabitAnalytics(
        totalHabits: 0,
        completedCount: 0,
        totalOpportunities: 0,
        completionRate: 0,
        habitCompletions: {},
        habitCompletionRates: {},
        topHabits: [],
        currentStreak: 0,
        longestStreak: 0,
        categoryCompletions: {},
        dailyData: [],
      );
}

/// Daily habit completion data for charts
@freezed
class DailyHabitData with _$DailyHabitData {
  const factory DailyHabitData({
    required DateTime date,
    required int completions,
    required int opportunities,
  }) = _DailyHabitData;

  factory DailyHabitData.fromJson(Map<String, dynamic> json) =>
      _$DailyHabitDataFromJson(json);
}

/// Individual habit performance details
@freezed
class HabitPerformance with _$HabitPerformance {
  const factory HabitPerformance({
    required String habitId,
    required String title,
    required String emoji,
    required String color,
    required String category,
    required int completions,
    required int opportunities,
    required double completionRate,
    required int currentStreak,
    required int longestStreak,
    required DateTime? lastCompleted,
    required List<DailyHabitData> dailyData,
  }) = _HabitPerformance;

  factory HabitPerformance.fromJson(Map<String, dynamic> json) =>
      _$HabitPerformanceFromJson(json);
}
