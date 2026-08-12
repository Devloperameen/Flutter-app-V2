/// Activity domain model
/// Represents a single activity in the activity feed
class Activity {

  Activity({
    required this.id,
    required this.type,
    required this.xpEarned,
    required this.metadata,
    required this.createdAt,
    this.shared = false,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] as String? ?? json['id'] as String,
      type: json['type'] as String,
      xpEarned: json['xpEarned'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      shared: json['shared'] as bool? ?? false,
    );
  }
  final String id;
  final String type; // 'habit-completion', 'focus-completed', 'streak-milestone', 'level-up', etc.
  final int xpEarned;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final bool shared;

  /// Get activity icon based on type
  String get icon {
    switch (type) {
      case 'habit-completion':
        return '🎯';
      case 'focus-completed':
        return '⏱️';
      case 'streak-milestone':
        return '🔥';
      case 'level-up':
        return '⭐';
      case 'achievement-unlocked':
        return '🏆';
      default:
        return '📝';
    }
  }

  /// Get activity title based on type
  String get title {
    switch (type) {
      case 'habit-completion':
        return 'Completed: ${metadata['habitTitle'] ?? 'Habit'}';
      case 'focus-completed':
        return 'Focus session completed';
      case 'streak-milestone':
        return 'Streak milestone: ${metadata['streakDays']} days!';
      case 'level-up':
        return 'Level up: Level ${metadata['newLevel']}';
      case 'achievement-unlocked':
        return 'Achievement: ${metadata['achievementName']}';
      default:
        return 'Activity';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'xpEarned': xpEarned,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'shared': shared,
    };
  }

  @override
  String toString() => 'Activity(type: $type, xp: $xpEarned, icon: $icon)';
}

/// Achievement/Badge model
class Achievement { // 0-100 if not unlocked

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.unlockedAt,
    this.progress = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      unlocked: json['unlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progress: json['progress'] as int? ?? 0,
    );
  }
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;
  final int progress;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'unlocked': unlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }
}
