// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitImpl _$$HabitImplFromJson(Map<String, dynamic> json) => _$HabitImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  emoji: json['emoji'] as String,
  color: json['color'] as String,
  category: json['category'] as String,
  description: json['description'] as String?,
  reminderEnabled: json['reminderEnabled'] as bool? ?? false,
  reminderTime: json['reminderTime'] as String?,
  targetMinutes: (json['targetMinutes'] as num?)?.toInt() ?? 0,
  completedToday: json['completedToday'] as bool? ?? false,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  totalCompletions: (json['totalCompletions'] as num?)?.toInt() ?? 0,
  lastCompletedDate: json['lastCompletedDate'] == null
      ? null
      : DateTime.parse(json['lastCompletedDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  archived: json['archived'] as bool? ?? false,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$HabitImplToJson(_$HabitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'emoji': instance.emoji,
      'color': instance.color,
      'category': instance.category,
      'description': instance.description,
      'reminderEnabled': instance.reminderEnabled,
      'reminderTime': instance.reminderTime,
      'targetMinutes': instance.targetMinutes,
      'completedToday': instance.completedToday,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'totalCompletions': instance.totalCompletions,
      'lastCompletedDate': instance.lastCompletedDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'archived': instance.archived,
      'order': instance.order,
    };
