// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FocusAnalyticsImpl _$$FocusAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$FocusAnalyticsImpl(
      totalSessions: (json['totalSessions'] as num).toInt(),
      completedSessions: (json['completedSessions'] as num).toInt(),
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      completedMinutes: (json['completedMinutes'] as num).toInt(),
      totalXpEarned: (json['totalXpEarned'] as num).toInt(),
      averageSessionMinutes: (json['averageSessionMinutes'] as num).toDouble(),
      longestSessionMinutes: (json['longestSessionMinutes'] as num).toInt(),
      sessionsByType: Map<String, int>.from(json['sessionsByType'] as Map),
      minutesByType: Map<String, int>.from(json['minutesByType'] as Map),
      dailyData: (json['dailyData'] as List<dynamic>)
          .map((e) => DailyFocusData.fromJson(e as Map<String, dynamic>))
          .toList(),
      longestStreak: (json['longestStreak'] as num).toInt(),
    );

Map<String, dynamic> _$$FocusAnalyticsImplToJson(
  _$FocusAnalyticsImpl instance,
) => <String, dynamic>{
  'totalSessions': instance.totalSessions,
  'completedSessions': instance.completedSessions,
  'totalMinutes': instance.totalMinutes,
  'completedMinutes': instance.completedMinutes,
  'totalXpEarned': instance.totalXpEarned,
  'averageSessionMinutes': instance.averageSessionMinutes,
  'longestSessionMinutes': instance.longestSessionMinutes,
  'sessionsByType': instance.sessionsByType,
  'minutesByType': instance.minutesByType,
  'dailyData': instance.dailyData,
  'longestStreak': instance.longestStreak,
};

_$DailyFocusDataImpl _$$DailyFocusDataImplFromJson(Map<String, dynamic> json) =>
    _$DailyFocusDataImpl(
      date: DateTime.parse(json['date'] as String),
      sessions: (json['sessions'] as num).toInt(),
      minutes: (json['minutes'] as num).toInt(),
      xpEarned: (json['xpEarned'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyFocusDataImplToJson(
  _$DailyFocusDataImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'sessions': instance.sessions,
  'minutes': instance.minutes,
  'xpEarned': instance.xpEarned,
};
