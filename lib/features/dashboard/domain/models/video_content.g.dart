// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoContentImpl _$$VideoContentImplFromJson(Map<String, dynamic> json) =>
    _$VideoContentImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      category: json['category'] as String,
      duration: (json['duration'] as num).toInt(),
      views: (json['views'] as num).toInt(),
      isWatched: json['isWatched'] as bool? ?? false,
      watchProgress: (json['watchProgress'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VideoContentImplToJson(_$VideoContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'thumbnailUrl': instance.thumbnailUrl,
      'videoUrl': instance.videoUrl,
      'category': instance.category,
      'duration': instance.duration,
      'views': instance.views,
      'isWatched': instance.isWatched,
      'watchProgress': instance.watchProgress,
      'createdAt': instance.createdAt.toIso8601String(),
    };
