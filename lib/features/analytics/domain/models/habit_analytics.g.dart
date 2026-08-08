// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitAnalyticsImpl _$$HabitAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$HabitAnalyticsImpl(
      totalHabits: (json['totalHabits'] as num).toInt(),
      completedCount: (json['completedCount'] as num).toInt(),
      totalOpportunities: (json['totalOpportunities'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      habitCompletions: Map<String, int>.from(json['habitCompletions'] as Map),
      habitCompletionRates:
          (json['habitCompletionRates'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ),
      topHabits: (json['topHabits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      categoryCompletions: Map<String, int>.from(
        json['categoryCompletions'] as Map,
      ),
      dailyData: (json['dailyData'] as List<dynamic>)
          .map((e) => DailyHabitData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HabitAnalyticsImplToJson(
  _$HabitAnalyticsImpl instance,
) => <String, dynamic>{
  'totalHabits': instance.totalHabits,
  'completedCount': instance.completedCount,
  'totalOpportunities': instance.totalOpportunities,
  'completionRate': instance.completionRate,
  'habitCompletions': instance.habitCompletions,
  'habitCompletionRates': instance.habitCompletionRates,
  'topHabits': instance.topHabits,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'categoryCompletions': instance.categoryCompletions,
  'dailyData': instance.dailyData,
};

_$DailyHabitDataImpl _$$DailyHabitDataImplFromJson(Map<String, dynamic> json) =>
    _$DailyHabitDataImpl(
      date: DateTime.parse(json['date'] as String),
      completions: (json['completions'] as num).toInt(),
      opportunities: (json['opportunities'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyHabitDataImplToJson(
  _$DailyHabitDataImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'completions': instance.completions,
  'opportunities': instance.opportunities,
};

_$HabitPerformanceImpl _$$HabitPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$HabitPerformanceImpl(
  habitId: json['habitId'] as String,
  title: json['title'] as String,
  emoji: json['emoji'] as String,
  color: json['color'] as String,
  category: json['category'] as String,
  completions: (json['completions'] as num).toInt(),
  opportunities: (json['opportunities'] as num).toInt(),
  completionRate: (json['completionRate'] as num).toDouble(),
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  lastCompleted: json['lastCompleted'] == null
      ? null
      : DateTime.parse(json['lastCompleted'] as String),
  dailyData: (json['dailyData'] as List<dynamic>)
      .map((e) => DailyHabitData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$HabitPerformanceImplToJson(
  _$HabitPerformanceImpl instance,
) => <String, dynamic>{
  'habitId': instance.habitId,
  'title': instance.title,
  'emoji': instance.emoji,
  'color': instance.color,
  'category': instance.category,
  'completions': instance.completions,
  'opportunities': instance.opportunities,
  'completionRate': instance.completionRate,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastCompleted': instance.lastCompleted?.toIso8601String(),
  'dailyData': instance.dailyData,
};
