// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonalRecordsImpl _$$PersonalRecordsImplFromJson(
  Map<String, dynamic> json,
) => _$PersonalRecordsImpl(
  maxDailyHabits: (json['maxDailyHabits'] as num).toInt(),
  maxDailyHabitsDate: json['maxDailyHabitsDate'] == null
      ? null
      : DateTime.parse(json['maxDailyHabitsDate'] as String),
  maxDailyXp: (json['maxDailyXp'] as num).toInt(),
  maxDailyXpDate: json['maxDailyXpDate'] == null
      ? null
      : DateTime.parse(json['maxDailyXpDate'] as String),
  maxDailyFocusMinutes: (json['maxDailyFocusMinutes'] as num).toInt(),
  maxDailyFocusMinutesDate: json['maxDailyFocusMinutesDate'] == null
      ? null
      : DateTime.parse(json['maxDailyFocusMinutesDate'] as String),
  longestHabitStreak: (json['longestHabitStreak'] as num).toInt(),
  longestHabitStreakHabitId: json['longestHabitStreakHabitId'] as String?,
  longestOverallStreak: (json['longestOverallStreak'] as num).toInt(),
  longestOverallStreakEndDate: json['longestOverallStreakEndDate'] == null
      ? null
      : DateTime.parse(json['longestOverallStreakEndDate'] as String),
);

Map<String, dynamic> _$$PersonalRecordsImplToJson(
  _$PersonalRecordsImpl instance,
) => <String, dynamic>{
  'maxDailyHabits': instance.maxDailyHabits,
  'maxDailyHabitsDate': instance.maxDailyHabitsDate?.toIso8601String(),
  'maxDailyXp': instance.maxDailyXp,
  'maxDailyXpDate': instance.maxDailyXpDate?.toIso8601String(),
  'maxDailyFocusMinutes': instance.maxDailyFocusMinutes,
  'maxDailyFocusMinutesDate': instance.maxDailyFocusMinutesDate
      ?.toIso8601String(),
  'longestHabitStreak': instance.longestHabitStreak,
  'longestHabitStreakHabitId': instance.longestHabitStreakHabitId,
  'longestOverallStreak': instance.longestOverallStreak,
  'longestOverallStreakEndDate': instance.longestOverallStreakEndDate
      ?.toIso8601String(),
};
