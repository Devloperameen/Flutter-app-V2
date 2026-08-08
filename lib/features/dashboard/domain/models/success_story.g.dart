// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuccessStoryImpl _$$SuccessStoryImplFromJson(Map<String, dynamic> json) =>
    _$SuccessStoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      story: json['story'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      achievement: json['achievement'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SuccessStoryImplToJson(_$SuccessStoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'story': instance.story,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'achievement': instance.achievement,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
    };
