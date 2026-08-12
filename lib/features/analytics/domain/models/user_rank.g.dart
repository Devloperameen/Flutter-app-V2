// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRankImpl _$$UserRankImplFromJson(Map<String, dynamic> json) =>
    _$UserRankImpl(
      rank: (json['rank'] as num).toInt(),
      totalUsers: (json['totalUsers'] as num).toInt(),
      percentile: (json['percentile'] as num).toDouble(),
      level: (json['level'] as num).toInt(),
      totalXp: (json['totalXp'] as num).toInt(),
      userName: json['userName'] as String,
      focusHours: (json['focusHours'] as num).toInt(),
      streakDays: (json['streakDays'] as num).toInt(),
    );

Map<String, dynamic> _$$UserRankImplToJson(_$UserRankImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'totalUsers': instance.totalUsers,
      'percentile': instance.percentile,
      'level': instance.level,
      'totalXp': instance.totalXp,
      'userName': instance.userName,
      'focusHours': instance.focusHours,
      'streakDays': instance.streakDays,
    };
