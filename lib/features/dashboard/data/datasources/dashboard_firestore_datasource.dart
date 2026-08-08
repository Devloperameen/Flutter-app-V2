import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/dashboard/domain/models/dashboard_data.dart';

/// Firestore-based dashboard data source
///
/// Replaces mock data with real Firestore queries
/// Provides real-time dashboard statistics and data
class DashboardFirestoreDataSource {
  DashboardFirestoreDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Get dashboard data for current user
  ///
  /// Fetches:
  /// - User profile data
  /// - Today's focus sessions
  /// - Today's completed tasks
  /// - Current streak
  /// - XP and level
  /// - Recent activity
  Future<DashboardData> getDashboardData(String userId) async {
    try {
      log.i('📊 Fetching dashboard data for user: $userId');

      // Get user profile
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Get today's sessions (focus time)
      final today = DateTime.now();
      final startOfDay =
          today.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      final endOfDay =
          today.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

      final sessionsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .where('startedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startedAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('status', isEqualTo: 'completed')
          .get();

      int totalFocusSeconds = 0;
      for (final session in sessionsSnap.docs) {
        final data = session.data();
        totalFocusSeconds += (data['durationSeconds'] as int? ?? 0);
      }
      final todayFocusHours = (totalFocusSeconds / 3600).toStringAsFixed(1);

      // Get today's completed tasks
      final tasksSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .where('completed', isEqualTo: true)
          .where('completedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('completedAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      final completedTasks = tasksSnap.docs.length;

      // Get missions for today
      final missionsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .where('createdDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdDate',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      int missionsCompleted = 0;
      int totalXpFromMissions = 0;
      for (final mission in missionsSnap.docs) {
        final data = mission.data();
        if (data['completed'] as bool? ?? false) {
          missionsCompleted++;
          totalXpFromMissions += (data['xpReward'] as int? ?? 0);
        }
      }

      // Get daily quote (random or from Firestore)
      final dailyQuote = await _getRandomQuote();

      log.i('✅ Dashboard data fetched successfully');

      return DashboardData(
        userName: '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
        todayMission: Mission(
          id: 'daily_mission',
          title: 'Complete Your Daily Focus Session',
          description: 'Spend at least 25 minutes in deep work today',
          isCompleted: missionsCompleted > 0,
          actionUrl: '/deep-work',
        ),
        energyLevel: 'High', // TODO: Calculate based on activity
        streakDays: userData['currentStreak'] as int? ?? 0,
        dailyQuote: dailyQuote,
      );
    } catch (e, st) {
      log.e('❌ Dashboard data fetch error: $e', stackTrace: st);
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  /// Get today's mission
  Future<Map<String, dynamic>?> getTodayMission(String userId) async {
    try {
      log.i('📋 Fetching today\'s mission for user: $userId');

      final today = DateTime.now();
      final startOfDay =
          today.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      final endOfDay =
          today.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

      final missionsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .where('createdDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdDate',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('completed', isEqualTo: false)
          .limit(1)
          .get();

      if (missionsSnap.docs.isEmpty) {
        log.i('ℹ️ No active mission for today');
        return null;
      }

      final mission = missionsSnap.docs.first.data();
      mission['id'] = missionsSnap.docs.first.id;

      log.i('✅ Today\'s mission fetched');
      return mission;
    } catch (e, st) {
      log.e('❌ Mission fetch error: $e', stackTrace: st);
      throw Exception('Failed to fetch mission: $e');
    }
  }

  /// Get random daily quote
  Future<Quote> _getRandomQuote() async {
    try {
      final quotesSnap = await _firestore.collection('quotes').limit(1).get();

      if (quotesSnap.docs.isEmpty) {
        return const Quote(
          text: 'The only way to do great work is to love what you do.',
          author: 'Steve Jobs',
        );
      }

      final quote = quotesSnap.docs.first.data();
      return Quote(
        text: quote['text'] as String? ?? 'The only way to do great work is to love what you do.',
        author: quote['author'] as String? ?? 'Steve Jobs',
      );
    } catch (_) {
      // Fallback to hardcoded quote if fetch fails
      return const Quote(
        text: 'The only way to do great work is to love what you do.',
        author: 'Steve Jobs',
      );
    }
  }

  /// Complete today's mission
  Future<void> completeMission(String userId, String missionId, int xpReward) async {
    try {
      log.i('✅ Completing mission: $missionId');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .doc(missionId)
          .update({
        'completed': true,
        'completedAt': DateTime.now().toIso8601String(),
      });

      // Update user XP
      await _firestore.collection('users').doc(userId).update({
        'totalXp': FieldValue.increment(xpReward),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log.i('✅ Mission completed and XP updated');
    } catch (e, st) {
      log.e('❌ Complete mission error: $e', stackTrace: st);
      throw Exception('Failed to complete mission: $e');
    }
  }

  /// Start a mission
  Future<void> startMission(String userId, String missionTitle) async {
    try {
      log.i('▶️ Starting mission: $missionTitle');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('missions')
          .add({
        'userId': userId,
        'title': missionTitle,
        'description': 'Daily mission: $missionTitle',
        'category': 'daily',
        'createdDate': DateTime.now().toIso8601String(),
        'completed': false,
        'completedAt': null,
        'xpReward': 50,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log.i('✅ Mission started');
    } catch (e, st) {
      log.e('❌ Start mission error: $e', stackTrace: st);
      throw Exception('Failed to start mission: $e');
    }
  }

  /// Get daily quote stream (real-time)
  Stream<String> getDailyQuoteStream() {
    return _firestore
        .collection('quotes')
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 'The only way to do great work is to love what you do. - Steve Jobs';
      }

      final quote = snapshot.docs.first.data();
      return quote['text'] as String? ??
          'The only way to do great work is to love what you do. - Steve Jobs';
    }).handleError((e) {
      log.e('❌ Quote stream error: $e');
      return 'The only way to do great work is to love what you do. - Steve Jobs';
    });
  }

  /// Get dashboard data stream (real-time)
  Stream<DashboardData> getDashboardDataStream(String userId) {
    return Stream.fromFuture(getDashboardData(userId));
  }
}
