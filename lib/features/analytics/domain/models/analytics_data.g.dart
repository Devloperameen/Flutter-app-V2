// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      period: AnalyticsPeriod.fromJson(json['period'] as Map<String, dynamic>),
      habitAnalytics: HabitAnalytics.fromJson(
        json['habitAnalytics'] as Map<String, dynamic>,
      ),
      focusAnalytics: FocusAnalytics.fromJson(
        json['focusAnalytics'] as Map<String, dynamic>,
      ),
      personalRecords: PersonalRecords.fromJson(
        json['personalRecords'] as Map<String, dynamic>,
      ),
      insights: (json['insights'] as List<dynamic>)
          .map((e) => AnalyticsInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      selectedCategory: json['selectedCategory'] as String?,
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'habitAnalytics': instance.habitAnalytics,
      'focusAnalytics': instance.focusAnalytics,
      'personalRecords': instance.personalRecords,
      'insights': instance.insights,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'selectedCategory': instance.selectedCategory,
    };
