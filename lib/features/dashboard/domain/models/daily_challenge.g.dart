// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyChallengeImpl _$$DailyChallengeImplFromJson(Map<String, dynamic> json) =>
    _$DailyChallengeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      xpReward: (json['xpReward'] as num).toInt(),
      category: json['category'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num).toInt(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$DailyChallengeImplToJson(
  _$DailyChallengeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'icon': instance.icon,
  'xpReward': instance.xpReward,
  'category': instance.category,
  'isCompleted': instance.isCompleted,
  'progress': instance.progress,
  'targetValue': instance.targetValue,
  'currentValue': instance.currentValue,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
