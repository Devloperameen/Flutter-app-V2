// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionImpl _$$MissionImplFromJson(Map<String, dynamic> json) =>
    _$MissionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      actionUrl: json['actionUrl'] as String,
    );

Map<String, dynamic> _$$MissionImplToJson(_$MissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'actionUrl': instance.actionUrl,
    };

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) =>
    _$QuoteImpl(text: json['text'] as String, author: json['author'] as String);

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{'text': instance.text, 'author': instance.author};

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      userName: json['userName'] as String,
      todayMission: Mission.fromJson(
        json['todayMission'] as Map<String, dynamic>,
      ),
      energyLevel: json['energyLevel'] as String,
      streakDays: (json['streakDays'] as num).toInt(),
      dailyQuote: Quote.fromJson(json['dailyQuote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'todayMission': instance.todayMission,
      'energyLevel': instance.energyLevel,
      'streakDays': instance.streakDays,
      'dailyQuote': instance.dailyQuote,
    };
