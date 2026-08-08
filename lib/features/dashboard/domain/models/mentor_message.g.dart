// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentor_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MentorMessageImpl _$$MentorMessageImplFromJson(Map<String, dynamic> json) =>
    _$MentorMessageImpl(
      id: json['id'] as String,
      message: json['message'] as String,
      tone: json['tone'] as String,
      context: json['context'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MentorMessageImplToJson(_$MentorMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'tone': instance.tone,
      'context': instance.context,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };
