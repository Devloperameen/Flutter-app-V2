// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsPeriodImpl _$$AnalyticsPeriodImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsPeriodImpl(
  type: $enumDecode(_$AnalyticsPeriodTypeEnumMap, json['type']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
);

Map<String, dynamic> _$$AnalyticsPeriodImplToJson(
  _$AnalyticsPeriodImpl instance,
) => <String, dynamic>{
  'type': _$AnalyticsPeriodTypeEnumMap[instance.type]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
};

const _$AnalyticsPeriodTypeEnumMap = {
  AnalyticsPeriodType.week: 'week',
  AnalyticsPeriodType.month: 'month',
  AnalyticsPeriodType.allTime: 'allTime',
  AnalyticsPeriodType.custom: 'custom',
};
