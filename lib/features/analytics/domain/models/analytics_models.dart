/// Analytics overview data
class AnalyticsData {

  AnalyticsData({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.habits,
    required this.focus,
    required this.xpGained,
    required this.streaks,
    required this.activities,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      period: json['period'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      habits: HabitStats.fromJson(json['habits'] as Map<String, dynamic>),
      focus: FocusStats.fromJson(json['focus'] as Map<String, dynamic>),
      xpGained: json['xpGained'] as int,
      streaks: StreakData.fromJson(json['streaks'] as Map<String, dynamic>),
      activities:
          ActivityStats.fromJson(json['activities'] as Map<String, dynamic>),
    );
  }
  final String period; // 'today', 'week', 'month', 'all-time'
  final DateTime startDate;
  final DateTime endDate;
  final HabitStats habits;
  final FocusStats focus;
  final int xpGained;
  final StreakData streaks;
  final ActivityStats activities;
}

/// Habit completion statistics
class HabitStats {

  HabitStats({
    required this.completed,
    required this.total,
    required this.percentage,
  });

  factory HabitStats.fromJson(Map<String, dynamic> json) {
    return HabitStats(
      completed: json['completed'] as int,
      total: json['total'] as int,
      percentage: json['percentage'] as int,
    );
  }
  final int completed;
  final int total;
  final int percentage;
}

/// Focus session statistics
class FocusStats {

  FocusStats({
    required this.totalMinutes,
    required this.sessions,
    required this.averageDuration,
  });

  factory FocusStats.fromJson(Map<String, dynamic> json) {
    return FocusStats(
      totalMinutes: json['totalMinutes'] as int,
      sessions: json['sessions'] as int,
      averageDuration: json['averageDuration'] as int,
    );
  }
  final int totalMinutes;
  final int sessions;
  final int averageDuration;
}

/// Streak tracking data
class StreakData {

  StreakData({
    required this.current,
    required this.longest,
    required this.habits,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    final habitsJson = json['habits'] as List<dynamic>? ?? [];
    return StreakData(
      current: json['current'] as int,
      longest: json['longest'] as int,
      habits: habitsJson
          .map((h) => HabitStreak.fromJson(h as Map<String, dynamic>))
          .toList(),
    );
  }
  final int current;
  final int longest;
  final List<HabitStreak> habits;
}

/// Individual habit streak
class HabitStreak {

  HabitStreak({
    required this.habitId,
    required this.name,
    required this.currentStreak,
  });

  factory HabitStreak.fromJson(Map<String, dynamic> json) {
    return HabitStreak(
      habitId: json['habitId'] as String,
      name: json['name'] as String,
      currentStreak: json['currentStreak'] as int,
    );
  }
  final String habitId;
  final String name;
  final int currentStreak;
}

/// Activity type statistics
class ActivityStats {

  ActivityStats({
    required this.count,
    required this.byType,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) {
    final byTypeJson = json['topTypes'] as List<dynamic>? ?? [];
    final byType = <String, int>{};
    for (final item in byTypeJson) {
      final map = item as Map<String, dynamic>;
      byType[map['type'] as String] = map['count'] as int;
    }

    return ActivityStats(
      count: json['count'] as int,
      byType: byType,
    );
  }
  final int count;
  final Map<String, int> byType;
}

/// Leaderboard user entry
class LeaderboardUser {

  LeaderboardUser({
    required this.rank,
    required this.userId,
    required this.fullName,
    required this.level,
    required this.totalXP,
    this.avatar,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      level: json['level'] as int,
      totalXP: json['totalXP'] as int,
      avatar: json['avatar'] as String?,
    );
  }
  final int rank;
  final String userId;
  final String fullName;
  final int level;
  final int totalXP;
  final String? avatar;
}

/// User rank information - USE user_rank.dart instead (freezed version)
class UserRankLegacy {

  UserRankLegacy({
    required this.rank,
    required this.totalUsers,
    required this.percentile,
    required this.level,
    required this.totalXP,
  });

  factory UserRankLegacy.fromJson(Map<String, dynamic> json) {
    return UserRankLegacy(
      rank: json['rank'] as int,
      totalUsers: json['totalUsers'] as int,
      percentile: json['percentile'] as int,
      level: json['level'] as int,
      totalXP: json['totalXP'] as int,
    );
  }
  final int rank;
  final int totalUsers;
  final int percentile;
  final int level;
  final int totalXP;
}

/// Insight/suggestion for user
class Insight { // 'high', 'medium', 'low'

  Insight({
    required this.type,
    required this.message,
    required this.priority,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      type: json['type'] as String,
      message: json['message'] as String,
      priority: json['priority'] as String? ?? 'medium',
    );
  }
  final String type;
  final String message;
  final String priority;

  String get icon {
    switch (type) {
      case 'level-milestone':
        return '🎉';
      case 'perfect-day':
        return '💪';
      case 'top-ranking':
        return '🏆';
      case 'streak-warning':
        return '⚠️';
      default:
        return '💡';
    }
  }
}
