import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';

/// Firestore-based focus timer datasource
/// Manages focus sessions, timers, and XP rewards
class FocusTimerDatasource {
  FocusTimerDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Verify user is authenticated
  void _checkUser(String userId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User is not authenticated');
    }
    if (currentUser.uid != userId) {
      throw Exception('Unauthorized: User UID mismatch');
    }
    log.i('✅ User verified: ${currentUser.uid}');
  }

  /// Start a new focus session
  Future<FocusSession> startFocusSession(
    String userId, {
    required String sessionType,
    required int durationSeconds,
    String? missionTitle,
    int xpReward = 50,
  }) async {
    try {
      _checkUser(userId);
      log.i('⏱️ Starting focus session: $sessionType for $durationSeconds seconds');

      final now = DateTime.now();
      final sessionId = _firestore.collection('users').doc().id;

      final focusSession = FocusSession(
        id: sessionId,
        userId: userId,
        startedAt: now,
        endedAt: null,
        durationSeconds: durationSeconds,
        completedSeconds: 0,
        status: 'active',
        sessionType: sessionType,
        missionTitle: missionTitle,
        xpReward: xpReward,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .doc(sessionId)
          .set({
        'id': focusSession.id,
        'userId': focusSession.userId,
        'startedAt': Timestamp.fromDate(focusSession.startedAt),
        'endedAt': null,
        'durationSeconds': focusSession.durationSeconds,
        'completedSeconds': focusSession.completedSeconds,
        'status': focusSession.status,
        'sessionType': focusSession.sessionType,
        'missionTitle': focusSession.missionTitle,
        'xpReward': focusSession.xpReward,
        'createdAt': Timestamp.fromDate(focusSession.createdAt),
        'updatedAt': Timestamp.fromDate(focusSession.updatedAt),
      });

      log.i('✅ Focus session started: $sessionId');
      return focusSession;
    } catch (e, st) {
      log.e('❌ Failed to start focus session: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Pause/Resume a focus session
  Future<void> updateFocusSessionStatus(
    String userId,
    String sessionId, {
    required String newStatus,
    required int completedSeconds,
  }) async {
    try {
      _checkUser(userId);
      log.i('⏸️ Updating session $sessionId status to: $newStatus');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .doc(sessionId)
          .update({
        'status': newStatus,
        'completedSeconds': completedSeconds,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      log.i('✅ Session status updated');
    } catch (e, st) {
      log.e('❌ Failed to update session status: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Complete a focus session and award XP
  Future<void> completeFocusSession(
    String userId,
    String sessionId, {
    required int completedSeconds,
    required int xpReward,
  }) async {
    try {
      _checkUser(userId);
      log.i('✅ Completing focus session: $sessionId');

      final now = DateTime.now();

      // Update session
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .doc(sessionId)
          .update({
        'status': 'completed',
        'completedSeconds': completedSeconds,
        'endedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // Award XP and update user stats (use set with merge to create if doesn't exist)
      await _firestore
          .collection('users')
          .doc(userId)
          .set({
        'totalXp': FieldValue.increment(xpReward),
        'totalFocusSeconds': FieldValue.increment(completedSeconds),
        'focusSessionsCompleted': FieldValue.increment(1),
        'updatedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      log.i('✅ Focus session completed. XP awarded: $xpReward');
    } catch (e, st) {
      log.e('❌ Failed to complete focus session: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Abandon a focus session
  Future<void> abandonFocusSession(
    String userId,
    String sessionId, {
    required int completedSeconds,
  }) async {
    try {
      _checkUser(userId);
      log.i('❌ Abandoning focus session: $sessionId');

      final now = DateTime.now();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .doc(sessionId)
          .update({
        'status': 'abandoned',
        'completedSeconds': completedSeconds,
        'endedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      log.i('✅ Focus session abandoned');
    } catch (e, st) {
      log.e('❌ Failed to abandon focus session: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get today's total focus time
  Future<int> getTodayFocusSeconds(String userId) async {
    try {
      _checkUser(userId);

      final today = DateTime.now();
      final startOfDay = today.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      final endOfDay = today.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

      final sessionsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .where('startedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startedAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('status', isEqualTo: 'completed')
          .get();

      int totalSeconds = 0;
      for (final session in sessionsSnap.docs) {
        totalSeconds += (session['completedSeconds'] as int? ?? 0);
      }

      log.i('📊 Today focus time: ${totalSeconds}s (${(totalSeconds / 60).toStringAsFixed(1)}min)');
      return totalSeconds;
    } catch (e, st) {
      log.e('❌ Failed to get today focus seconds: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get focus sessions stream (real-time)
  Stream<List<FocusSession>> getFocusSessionsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('focusSessions')
        .orderBy('startedAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FocusSession(
          id: data['id'] as String,
          userId: data['userId'] as String,
          startedAt: (data['startedAt'] as Timestamp).toDate(),
          endedAt: data['endedAt'] != null
              ? (data['endedAt'] as Timestamp).toDate()
              : null,
          durationSeconds: data['durationSeconds'] as int,
          completedSeconds: data['completedSeconds'] as int,
          status: data['status'] as String,
          sessionType: data['sessionType'] as String,
          missionTitle: data['missionTitle'] as String?,
          xpReward: data['xpReward'] as int,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    }).handleError((e) {
      log.e('❌ Focus sessions stream error: $e');
      return [];
    });
  }

  /// Get current active session
  Future<FocusSession?> getActiveSession(String userId) async {
    try {
      _checkUser(userId);

      final sessionsSnap = await _firestore
          .collection('users')
          .doc(userId)
          .collection('focusSessions')
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (sessionsSnap.docs.isEmpty) {
        return null;
      }

      final data = sessionsSnap.docs.first.data();
      return FocusSession(
        id: data['id'] as String,
        userId: data['userId'] as String,
        startedAt: (data['startedAt'] as Timestamp).toDate(),
        endedAt:
            data['endedAt'] != null ? (data['endedAt'] as Timestamp).toDate() : null,
        durationSeconds: data['durationSeconds'] as int,
        completedSeconds: data['completedSeconds'] as int,
        status: data['status'] as String,
        sessionType: data['sessionType'] as String,
        missionTitle: data['missionTitle'] as String?,
        xpReward: data['xpReward'] as int,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    } catch (e, st) {
      log.e('❌ Failed to get active session: $e', stackTrace: st);
      return null;
    }
  }
}
