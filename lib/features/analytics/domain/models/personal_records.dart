import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_records.freezed.dart';
part 'personal_records.g.dart';

/// Personal records and achievements
@freezed
class PersonalRecords with _$PersonalRecords {
  const factory PersonalRecords({
    required int maxDailyHabits,
    required DateTime? maxDailyHabitsDate,
    required int maxDailyXp,
    required DateTime? maxDailyXpDate,
    required int maxDailyFocusMinutes,
    required DateTime? maxDailyFocusMinutesDate,
    required int longestHabitStreak,
    required String? longestHabitStreakHabitId,
    required int longestOverallStreak,
    required DateTime? longestOverallStreakEndDate,
  }) = _PersonalRecords;

  factory PersonalRecords.fromJson(Map<String, dynamic> json) =>
      _$PersonalRecordsFromJson(json);

  /// Empty personal records
  factory PersonalRecords.empty() => const PersonalRecords(
        maxDailyHabits: 0,
        maxDailyHabitsDate: null,
        maxDailyXp: 0,
        maxDailyXpDate: null,
        maxDailyFocusMinutes: 0,
        maxDailyFocusMinutesDate: null,
        longestHabitStreak: 0,
        longestHabitStreakHabitId: null,
        longestOverallStreak: 0,
        longestOverallStreakEndDate: null,
      );
}
