import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_analytics.freezed.dart';
part 'focus_analytics.g.dart';

/// Analytics data for focus sessions
@freezed
class FocusAnalytics with _$FocusAnalytics {
  const factory FocusAnalytics({
    required int totalSessions,
    required int completedSessions,
    required int totalMinutes,
    required int completedMinutes,
    required int totalXpEarned,
    required double averageSessionMinutes,
    required int longestSessionMinutes,
    required Map<String, int> sessionsByType, // sessionType -> count
    required Map<String, int> minutesByType, // sessionType -> minutes
    required List<DailyFocusData> dailyData,
    required int longestStreak, // Consecutive completed sessions
  }) = _FocusAnalytics;

  factory FocusAnalytics.fromJson(Map<String, dynamic> json) =>
      _$FocusAnalyticsFromJson(json);

  /// Empty analytics state
  factory FocusAnalytics.empty() => const FocusAnalytics(
        totalSessions: 0,
        completedSessions: 0,
        totalMinutes: 0,
        completedMinutes: 0,
        totalXpEarned: 0,
        averageSessionMinutes: 0,
        longestSessionMinutes: 0,
        sessionsByType: {},
        minutesByType: {},
        dailyData: [],
        longestStreak: 0,
      );
}

/// Daily focus session data for charts
@freezed
class DailyFocusData with _$DailyFocusData {
  const factory DailyFocusData({
    required DateTime date,
    required int sessions,
    required int minutes,
    required int xpEarned,
  }) = _DailyFocusData;

  factory DailyFocusData.fromJson(Map<String, dynamic> json) =>
      _$DailyFocusDataFromJson(json);
}
