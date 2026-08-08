// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  authorRole: json['authorRole'] as String,
  content: json['content'] as String,
  imageUrl: json['imageUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  likeCount: (json['likeCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isLikedByMe: json['isLikedByMe'] as bool,
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorRole': instance.authorRole,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'isLikedByMe': instance.isLikedByMe,
    };
