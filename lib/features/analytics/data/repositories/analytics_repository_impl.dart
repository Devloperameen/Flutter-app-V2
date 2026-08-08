import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/analytics/domain/models/analytics_data.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/analytics/domain/repositories/analytics_repository_interface.dart';
import 'package:safe/features/analytics/domain/services/analytics_calculator.dart';
import 'package:safe/features/analytics/domain/services/insights_generator.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

part 'analytics_repository_impl.g.dart';

/// Riverpod provider for AnalyticsRepository
@riverpod
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  return AnalyticsRepository(firestore: FirebaseFirestore.instance);
}

/// Repository for analytics operations
class AnalyticsRepository implements IAnalyticsRepository {
  AnalyticsRepository({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<AnalyticsData> getAnalytics({
    required String userId,
    required AnalyticsPeriod period,
    String? categoryFilter,
  }) async {
    try {
      log.i('📊 Fetching analytics for user: $userId, period: ${period.type.label}');

      // Fetch habits
      final habitsSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();

      final habits = habitsSnapshot.docs
          .map((doc) => Habit.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Fetch focus sessions
      final sessionsSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .where('startedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(period.startDate))
          .where('startedAt',
              isLessThanOrEqualTo: Timestamp.fromDate(period.endDate))
          .get();

      final sessions = sessionsSnapshot.docs
          .map((doc) => FocusSession.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Calculate analytics
      final habitAnalytics = AnalyticsCalculator.calculateHabitAnalytics(
        habits: habits,
        period: period,
        categoryFilter: categoryFilter,
      );

      final focusAnalytics = AnalyticsCalculator.calculateFocusAnalytics(
        sessions: sessions,
        period: period,
      );

      final personalRecords = AnalyticsCalculator.calculatePersonalRecords(
        habits: habits,
        sessions: sessions,
      );

      // Generate insights
      final insights = InsightsGenerator.generateInsights(
        habitAnalytics: habitAnalytics,
        focusAnalytics: focusAnalytics,
        personalRecords: personalRecords,
        period: period,
      );

      log.i('✅ Analytics calculated successfully');

      return AnalyticsData(
        period: period,
        habitAnalytics: habitAnalytics,
        focusAnalytics: focusAnalytics,
        personalRecords: personalRecords,
        insights: insights,
        lastUpdated: DateTime.now(),
        selectedCategory: categoryFilter,
      );
    } catch (e, stackTrace) {
      log.e('❌ Failed to fetch analytics: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<HabitPerformance> getHabitPerformance({
    required String userId,
    required String habitId,
    required AnalyticsPeriod period,
  }) async {
    try {
      log.i('📊 Fetching habit performance: $habitId');

      // Fetch habit
      final habitDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .get();

      if (!habitDoc.exists) {
        throw Exception('Habit not found');
      }

      final habit = Habit.fromJson({...habitDoc.data()!, 'id': habitDoc.id});

      // Calculate performance
      final performance = AnalyticsCalculator.calculateHabitPerformance(
        habit: habit,
        period: period,
      );

      log.i('✅ Habit performance calculated');

      return performance;
    } catch (e, stackTrace) {
      log.e('❌ Failed to fetch habit performance: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> refreshCache(String userId) async {
    // TODO: Implement cache refresh logic
    log.i('🔄 Analytics cache refresh triggered for user: $userId');
  }
}
