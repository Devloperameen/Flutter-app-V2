import 'package:safe/features/analytics/domain/models/analytics_insight.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/focus_analytics.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/analytics/domain/models/personal_records.dart';
import 'package:uuid/uuid.dart';

/// Service for generating motivational insights
class InsightsGenerator {
  static const _uuid = Uuid();

  /// Generate insights from analytics data
  static List<AnalyticsInsight> generateInsights({
    required HabitAnalytics habitAnalytics,
    required FocusAnalytics focusAnalytics,
    required PersonalRecords personalRecords,
    required AnalyticsPeriod period,
  }) {
    final insights = <AnalyticsInsight>[];

    // Add habit completion insights
    if (habitAnalytics.completedCount > 0) {
      insights.add(_generateHabitCompletionInsight(habitAnalytics, period));
    }

    // Add streak insights
    if (habitAnalytics.currentStreak > 0) {
      insights.add(_generateStreakInsight(habitAnalytics));
    }

    // Add focus session insights
    if (focusAnalytics.completedSessions > 0) {
      insights.add(_generateFocusInsight(focusAnalytics));
    }

    // Add personal record insights
    if (personalRecords.longestOverallStreak > 0) {
      insights.add(_generateRecordInsight(personalRecords));
    }

    // Add encouragement if no data
    if (insights.isEmpty) {
      insights.add(_generateEncouragementInsight(period));
    }

    return insights;
  }

  static AnalyticsInsight _generateHabitCompletionInsight(
    HabitAnalytics analytics,
    AnalyticsPeriod period,
  ) {
    final rate = analytics.completionRate.round();
    final periodLabel = period.type.label.toLowerCase();

    String message;
    String emoji;
    InsightPriority priority;

    if (rate >= 80) {
      message =
          "Incredible work this $periodLabel! You've completed ${analytics.completedCount} habits with a $rate% success rate. Keep building momentum! 💪";
      emoji = '🔥';
      priority = InsightPriority.high;
    } else if (rate >= 50) {
      message =
          "You're making steady progress this $periodLabel with ${analytics.completedCount} habits completed. Let's aim even higher! 🎯";
      emoji = '📈';
      priority = InsightPriority.medium;
    } else {
      message =
          "Every journey begins with a single step. You've completed ${analytics.completedCount} habits this $periodLabel. Let's build on that foundation! 🌱";
      emoji = '🌟';
      priority = InsightPriority.medium;
    }

    return AnalyticsInsight(
      id: _uuid.v4(),
      title: 'Habit Progress',
      message: message,
      type: InsightType.improvement,
      priority: priority,
      generatedAt: DateTime.now(),
      emoji: emoji,
    );
  }

  static AnalyticsInsight _generateStreakInsight(HabitAnalytics analytics) {
    final streak = analytics.currentStreak;
    final message = streak >= 7
        ? "Amazing! You're on a $streak-day streak! Consistency is the foundation of lasting change. Keep going! 🔥"
        : "You're building momentum with a $streak-day streak! Each day of consistency brings you closer to your goals. 💫";

    return AnalyticsInsight(
      id: _uuid.v4(),
      title: 'Streak Power',
      message: message,
      type: InsightType.streak,
      priority: streak >= 7 ? InsightPriority.high : InsightPriority.medium,
      generatedAt: DateTime.now(),
      emoji: '⚡',
    );
  }

  static AnalyticsInsight _generateFocusInsight(FocusAnalytics analytics) {
    final hours = analytics.completedMinutes / 60;
    final sessions = analytics.completedSessions;

    final message = hours >= 10
        ? "Exceptional focus! You've completed $sessions focus sessions totaling ${hours.toStringAsFixed(1)} hours. Your dedication is inspiring! 🎯"
        : "Great work! You've logged ${hours.toStringAsFixed(1)} hours across $sessions focus sessions. Deep work creates extraordinary results! 💼";

    return AnalyticsInsight(
      id: _uuid.v4(),
      title: 'Focus Achievement',
      message: message,
      type: InsightType.achievement,
      priority: hours >= 10 ? InsightPriority.high : InsightPriority.medium,
      generatedAt: DateTime.now(),
      emoji: '🎯',
    );
  }

  static AnalyticsInsight _generateRecordInsight(PersonalRecords records) {
    final streak = records.longestOverallStreak;
    final message =
        "Your personal best: $streak-day streak! This shows what you're capable of when you stay committed. Let's build on this foundation! 🏆";

    return AnalyticsInsight(
      id: _uuid.v4(),
      title: 'Personal Record',
      message: message,
      type: InsightType.milestone,
      priority: InsightPriority.high,
      generatedAt: DateTime.now(),
      emoji: '🏆',
    );
  }

  static AnalyticsInsight _generateEncouragementInsight(
    AnalyticsPeriod period,
  ) {
    final periodLabel = period.type.label.toLowerCase();
    final message =
        'Start building your habit journey this $periodLabel! Create your first habit and watch your progress grow. Every expert was once a beginner. 🚀';

    return AnalyticsInsight(
      id: _uuid.v4(),
      title: 'Get Started',
      message: message,
      type: InsightType.encouragement,
      priority: InsightPriority.medium,
      generatedAt: DateTime.now(),
      emoji: '🌱',
    );
  }
}
