// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FocusSessionImpl _$$FocusSessionImplFromJson(Map<String, dynamic> json) =>
    _$FocusSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      completedSeconds: (json['completedSeconds'] as num).toInt(),
      status: json['status'] as String,
      sessionType: json['sessionType'] as String,
      missionTitle: json['missionTitle'] as String?,
      xpReward: (json['xpReward'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FocusSessionImplToJson(_$FocusSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'completedSeconds': instance.completedSeconds,
      'status': instance.status,
      'sessionType': instance.sessionType,
      'missionTitle': instance.missionTitle,
      'xpReward': instance.xpReward,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TimerStateImpl _$$TimerStateImplFromJson(Map<String, dynamic> json) =>
    _$TimerStateImpl(
      secondsRemaining: (json['secondsRemaining'] as num).toInt(),
      totalSeconds: (json['totalSeconds'] as num).toInt(),
      isRunning: json['isRunning'] as bool,
      isPaused: json['isPaused'] as bool,
      currentPhase: json['currentPhase'] as String,
      cycleCount: (json['cycleCount'] as num).toInt(),
    );

Map<String, dynamic> _$$TimerStateImplToJson(_$TimerStateImpl instance) =>
    <String, dynamic>{
      'secondsRemaining': instance.secondsRemaining,
      'totalSeconds': instance.totalSeconds,
      'isRunning': instance.isRunning,
      'isPaused': instance.isPaused,
      'currentPhase': instance.currentPhase,
      'cycleCount': instance.cycleCount,
    };
