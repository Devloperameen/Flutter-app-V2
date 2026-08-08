import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_period.freezed.dart';
part 'analytics_period.g.dart';

/// Represents a time period for analytics filtering
@freezed
class AnalyticsPeriod with _$AnalyticsPeriod {
  const factory AnalyticsPeriod({
    required AnalyticsPeriodType type,
    required DateTime startDate,
    required DateTime endDate,
  }) = _AnalyticsPeriod;

  factory AnalyticsPeriod.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPeriodFromJson(json);
}

/// Enum for analytics period types
enum AnalyticsPeriodType {
  @JsonValue('week')
  week,
  @JsonValue('month')
  month,
  @JsonValue('allTime')
  allTime,
  @JsonValue('custom')
  custom,
}

extension AnalyticsPeriodTypeX on AnalyticsPeriodType {
  String get label {
    switch (this) {
      case AnalyticsPeriodType.week:
        return 'Week';
      case AnalyticsPeriodType.month:
        return 'Month';
      case AnalyticsPeriodType.allTime:
        return 'All Time';
      case AnalyticsPeriodType.custom:
        return 'Custom';
    }
  }

  /// Create period instance for current period
  AnalyticsPeriod toPeriod() {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsPeriodType.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return AnalyticsPeriod(
          type: this,
          startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
        );
      case AnalyticsPeriodType.month:
        return AnalyticsPeriod(
          type: this,
          startDate: DateTime(now.year, now.month),
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
        );
      case AnalyticsPeriodType.allTime:
        return AnalyticsPeriod(
          type: this,
          startDate: DateTime(2020), // App inception
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
        );
      case AnalyticsPeriodType.custom:
        return AnalyticsPeriod(
          type: this,
          startDate: now,
          endDate: now,
        );
    }
  }
}
