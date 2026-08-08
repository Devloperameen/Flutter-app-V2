// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsInsightImpl _$$AnalyticsInsightImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsInsightImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$InsightTypeEnumMap, json['type']),
  priority: $enumDecode(_$InsightPriorityEnumMap, json['priority']),
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  emoji: json['emoji'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$AnalyticsInsightImplToJson(
  _$AnalyticsInsightImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'type': _$InsightTypeEnumMap[instance.type]!,
  'priority': _$InsightPriorityEnumMap[instance.priority]!,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'emoji': instance.emoji,
  'metadata': instance.metadata,
};

const _$InsightTypeEnumMap = {
  InsightType.improvement: 'improvement',
  InsightType.encouragement: 'encouragement',
  InsightType.achievement: 'achievement',
  InsightType.milestone: 'milestone',
  InsightType.comparison: 'comparison',
  InsightType.prediction: 'prediction',
  InsightType.streak: 'streak',
};

const _$InsightPriorityEnumMap = {
  InsightPriority.high: 'high',
  InsightPriority.medium: 'medium',
  InsightPriority.low: 'low',
};
