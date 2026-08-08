// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningResourceImpl _$$LearningResourceImplFromJson(
  Map<String, dynamic> json,
) => _$LearningResourceImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  resourceUrl: json['resourceUrl'] as String,
  type: json['type'] as String,
  category: json['category'] as String,
  author: json['author'] as String,
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  isRecommended: json['isRecommended'] as bool? ?? false,
  isCompleted: json['isCompleted'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$LearningResourceImplToJson(
  _$LearningResourceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'thumbnailUrl': instance.thumbnailUrl,
  'resourceUrl': instance.resourceUrl,
  'type': instance.type,
  'category': instance.category,
  'author': instance.author,
  'duration': instance.duration,
  'isRecommended': instance.isRecommended,
  'isCompleted': instance.isCompleted,
  'tags': instance.tags,
  'createdAt': instance.createdAt.toIso8601String(),
};
