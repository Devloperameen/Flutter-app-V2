// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productivity_tip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductivityTipImpl _$$ProductivityTipImplFromJson(
  Map<String, dynamic> json,
) => _$ProductivityTipImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  icon: json['icon'] as String,
  category: json['category'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ProductivityTipImplToJson(
  _$ProductivityTipImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'icon': instance.icon,
  'category': instance.category,
  'isFavorite': instance.isFavorite,
  'likes': instance.likes,
  'createdAt': instance.createdAt.toIso8601String(),
};
