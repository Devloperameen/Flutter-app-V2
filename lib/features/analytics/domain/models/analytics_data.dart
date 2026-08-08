import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:safe/features/analytics/domain/models/analytics_insight.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/focus_analytics.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/analytics/domain/models/personal_records.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

/// Complete analytics data for a period
@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required AnalyticsPeriod period,
    required HabitAnalytics habitAnalytics,
    required FocusAnalytics focusAnalytics,
    required PersonalRecords personalRecords,
    required List<AnalyticsInsight> insights,
    required DateTime lastUpdated,
    String? selectedCategory, // Filter by category
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);

  /// Empty analytics data
  factory AnalyticsData.empty(AnalyticsPeriod period) => AnalyticsData(
        period: period,
        habitAnalytics: HabitAnalytics.empty(),
        focusAnalytics: FocusAnalytics.empty(),
        personalRecords: PersonalRecords.empty(),
        insights: [],
        lastUpdated: DateTime.now(),
      );
}
