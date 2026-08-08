import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/data/datasources/habit_datasource_interface.dart';
import 'dart:math';

/// Firestore-based habit datasource.
/// Firestore is the ONLY source of truth.
/// No mock data, no fallbacks, no optimistic updates in datasource.
class FirestoreHabitDatasource implements IHabitDatasource {
  FirestoreHabitDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Verify user is authenticated and matches the provided userId
  void _checkUser(String userId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User is not authenticated');
    }
    if (currentUser.uid != userId) {
      throw Exception(
        'Unauthorized: Current user UID (${currentUser.uid}) does not match requested userId ($userId)',
      );
    }
    log.i('✅ User verified: ${currentUser.uid}');
  }

  /// Reference to habits collection for user
  CollectionReference<Map<String, dynamic>> _habitsCollection(String userId) =>
      _firestore.collection('users').doc(userId).collection('habits');

  /// Stream all habits for user, ordered by custom order
  Stream<List<Habit>> getHabitsStream(String userId) {
    return _habitsCollection(userId)
        .orderBy('order', descending: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      final habits = <Habit>[];
      for (final doc in snapshot.docs) {
        try {
          habits.add(_habitFromDoc(doc));
        } catch (e) {
          log.e('❌ Error parsing habit: ${doc.id}: $e');
        }
      }
      return habits;
    });
  }

  /// Get single habit
  Future<Habit> getHabit(String userId, String habitId) async {
    try {
      final doc = await _habitsCollection(userId).doc(habitId).get();
      if (!doc.exists) {
        throw Exception('Habit not found: $habitId');
      }
      return _habitFromDoc(doc);
    } catch (e, st) {
      log.e('❌ Failed to get habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Create a new habit
  Future<Habit> createHabit(String userId, Habit habit) async {
    try {
      _checkUser(userId);
      log.i('➕ Creating habit: ${habit.title}');
      
      final now = DateTime.now();
      final habitData = {
        'id': habit.id,
        'title': habit.title,
        'emoji': habit.emoji,
        'color': habit.color,
        'category': habit.category,
        'description': habit.description,
        'reminderEnabled': habit.reminderEnabled,
        'reminderTime': habit.reminderTime,
        'targetMinutes': habit.targetMinutes,
        'completedToday': false,
        'currentStreak': 0,
        'longestStreak': 0,
        'totalCompletions': 0,
        'lastCompletedDate': null,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'archived': false,
        'order': habit.order,
      };

      await _habitsCollection(userId).doc(habit.id).set(habitData);

      return habit.copyWith(
        createdAt: now,
        updatedAt: now,
      );
    } catch (e, st) {
      log.e('❌ Failed to create habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Update habit metadata (title, emoji, color, etc.)
  Future<void> updateHabit(String userId, Habit habit) async {
    try {
      _checkUser(userId);
      log.i('✏️ Updating habit: ${habit.id}');

      final now = DateTime.now();
      await _habitsCollection(userId).doc(habit.id).update({
        'title': habit.title,
        'emoji': habit.emoji,
        'color': habit.color,
        'category': habit.category,
        'description': habit.description,
        'reminderEnabled': habit.reminderEnabled,
        'reminderTime': habit.reminderTime,
        'targetMinutes': habit.targetMinutes,
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e, st) {
      log.e('❌ Failed to update habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Mark habit as completed for today using Firestore transaction
  /// Handles streak calculation atomically
  Future<Habit> markHabitComplete(String userId, String habitId) async {
    try {
      _checkUser(userId);
      log.i('✅ Marking habit complete: $habitId');

      final result = await _firestore.runTransaction((transaction) async {
        final docRef = _habitsCollection(userId).doc(habitId);
        final docSnapshot = await transaction.get(docRef);

        if (!docSnapshot.exists) {
          throw Exception('Habit not found');
        }

        final data = docSnapshot.data()!;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // Check if already completed today
        final lastCompletedDate = data['lastCompletedDate'] != null
            ? (data['lastCompletedDate'] is String
                ? DateTime.parse(data['lastCompletedDate'] as String)
                : (data['lastCompletedDate'] as Timestamp).toDate())
            : null;

        if (lastCompletedDate != null) {
          final lastDay = DateTime(
            lastCompletedDate.year,
            lastCompletedDate.month,
            lastCompletedDate.day,
          );
          if (lastDay == today) {
            log.i('⚠️ Habit already completed today');
            // Return current state without updating
            return _habitFromMap(habitId, data);
          }
        }

        // Calculate new streak
        int newStreak = (data['currentStreak'] as int? ?? 0) + 1;
        final newLongestStreak = max(
          newStreak,
          data['longestStreak'] as int? ?? 0,
        );

        // Update habit in transaction
        transaction.update(docRef, {
          'completedToday': true,
          'currentStreak': newStreak,
          'longestStreak': newLongestStreak,
          'totalCompletions': (data['totalCompletions'] as int? ?? 0) + 1,
          'lastCompletedDate': Timestamp.fromDate(today),
          'updatedAt': Timestamp.fromDate(now),
        });

        // Log completion in sub-collection
        await transaction.set(
          docRef.collection('completions').doc(today.toIso8601String()),
          {
            'date': today.toIso8601String(),
            'completedAt': Timestamp.fromDate(now),
          },
        );

        // Return updated habit
        final updatedData = {...data};
        updatedData['completedToday'] = true;
        updatedData['currentStreak'] = newStreak;
        updatedData['longestStreak'] = newLongestStreak;
        updatedData['totalCompletions'] =
            (data['totalCompletions'] as int? ?? 0) + 1;
        updatedData['lastCompletedDate'] = Timestamp.fromDate(today);
        updatedData['updatedAt'] = Timestamp.fromDate(now);

        return _habitFromMap(habitId, updatedData);
      });

      return result;
    } catch (e, st) {
      log.e('❌ Failed to mark habit complete: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Undo habit completion for today
  Future<Habit> undoHabitComplete(String userId, String habitId) async {
    try {
      _checkUser(userId);
      log.i('↩️ Undoing habit completion: $habitId');

      final result = await _firestore.runTransaction((transaction) async {
        final docRef = _habitsCollection(userId).doc(habitId);
        final docSnapshot = await transaction.get(docRef);

        if (!docSnapshot.exists) {
          throw Exception('Habit not found');
        }

        final data = docSnapshot.data()!;
        if (!(data['completedToday'] as bool? ?? false)) {
          log.w('⚠️ Habit not completed today, nothing to undo');
          return _habitFromMap(habitId, data);
        }

        final now = DateTime.now();
        int newStreak = max(0, (data['currentStreak'] as int? ?? 0) - 1);

        // Update in transaction
        transaction.update(docRef, {
          'completedToday': false,
          'currentStreak': newStreak,
          'totalCompletions': max(0, (data['totalCompletions'] as int? ?? 0) - 1),
          'updatedAt': Timestamp.fromDate(now),
        });

        // Delete completion log
        final today = DateTime(now.year, now.month, now.day);
        await transaction.delete(
          docRef.collection('completions').doc(today.toIso8601String()),
        );

        // Return updated habit
        final updatedData = {...data};
        updatedData['completedToday'] = false;
        updatedData['currentStreak'] = newStreak;
        updatedData['totalCompletions'] =
            max(0, (data['totalCompletions'] as int? ?? 0) - 1);
        updatedData['updatedAt'] = Timestamp.fromDate(now);

        return _habitFromMap(habitId, updatedData);
      });

      return result;
    } catch (e, st) {
      log.e('❌ Failed to undo habit completion: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Archive a habit
  Future<void> archiveHabit(String userId, String habitId) async {
    try {
      _checkUser(userId);
      log.i('📦 Archiving habit: $habitId');
      await _habitsCollection(userId).doc(habitId).update({
        'archived': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e, st) {
      log.e('❌ Failed to archive habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Restore an archived habit
  Future<void> restoreHabit(String userId, String habitId) async {
    try {
      _checkUser(userId);
      log.i('♻️ Restoring habit: $habitId');
      await _habitsCollection(userId).doc(habitId).update({
        'archived': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e, st) {
      log.e('❌ Failed to restore habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Delete a habit permanently
  Future<void> deleteHabit(String userId, String habitId) async {
    try {
      _checkUser(userId);
      log.i('🗑️ Deleting habit: $habitId');

      await _firestore.runTransaction((transaction) async {
        final docRef = _habitsCollection(userId).doc(habitId);

        // Delete all completions
        final completions =
            await docRef.collection('completions').get();
        for (final doc in completions.docs) {
          transaction.delete(doc.reference);
        }

        // Delete habit
        transaction.delete(docRef);
      });
    } catch (e, st) {
      log.e('❌ Failed to delete habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Duplicate a habit (for today and all future days)
  Future<Habit> duplicateHabit(String userId, String habitId) async {
    try {
      log.i('📋 Duplicating habit: $habitId');

      final original = await getHabit(userId, habitId);
      final newHabit = original.copyWith(
        id: _generateHabitId(),
        title: '${original.title} (Copy)',
        currentStreak: 0,
        longestStreak: 0,
        totalCompletions: 0,
        completedToday: false,
        lastCompletedDate: null,
      );

      return createHabit(userId, newHabit);
    } catch (e, st) {
      log.e('❌ Failed to duplicate habit: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Reorder habits
  Future<void> reorderHabits(String userId, List<String> habitIds) async {
    try {
      log.i('🔄 Reordering ${habitIds.length} habits');

      await _firestore.runTransaction((transaction) async {
        for (int i = 0; i < habitIds.length; i++) {
          transaction.update(
            _habitsCollection(userId).doc(habitIds[i]),
            {'order': i},
          );
        }
      });
    } catch (e, st) {
      log.e('❌ Failed to reorder habits: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Get completion history for a habit
  Future<List<DateTime>> getCompletionHistory(
    String userId,
    String habitId,
  ) async {
    try {
      final completions = await _habitsCollection(userId)
          .doc(habitId)
          .collection('completions')
          .orderBy('date', descending: true)
          .get();

      return completions.docs
          .map((doc) {
        final date = doc['date'];
        if (date is String) {
          return DateTime.parse(date);
        }
        return null;
      })
          .whereType<DateTime>()
          .toList();
    } catch (e, st) {
      log.e('❌ Failed to get completion history: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Helper: Convert Firestore document to Habit model
  Habit _habitFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return _habitFromMap(doc.id, doc.data() ?? {});
  }

  /// Helper: Convert map to Habit model
  /// Automatically calculates completedToday based on lastCompletedDate
  Habit _habitFromMap(String id, Map<String, dynamic> data) {
    // Parse lastCompletedDate
    DateTime? lastCompletedDate = data['lastCompletedDate'] != null
        ? (data['lastCompletedDate'] is String
            ? DateTime.parse(data['lastCompletedDate'] as String)
            : (data['lastCompletedDate'] as Timestamp).toDate())
        : null;

    // Calculate completedToday based on lastCompletedDate
    // If lastCompletedDate is today, then completedToday = true
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    bool isCompletedToday = false;
    
    if (lastCompletedDate != null) {
      final lastDay = DateTime(lastCompletedDate.year, lastCompletedDate.month, lastCompletedDate.day);
      isCompletedToday = lastDay == today;
    }

    return Habit(
      id: id,
      title: data['title'] as String? ?? 'Untitled',
      emoji: data['emoji'] as String? ?? '✨',
      color: data['color'] as String? ?? '#FF6B6B',
      category: data['category'] as String? ?? 'other',
      description: data['description'] as String?,
      reminderEnabled: data['reminderEnabled'] as bool? ?? false,
      reminderTime: data['reminderTime'] as String?,
      targetMinutes: data['targetMinutes'] as int? ?? 0,
      completedToday: isCompletedToday,
      currentStreak: data['currentStreak'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? 0,
      totalCompletions: data['totalCompletions'] as int? ?? 0,
      lastCompletedDate: lastCompletedDate,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is String
              ? DateTime.parse(data['createdAt'] as String)
              : (data['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] is String
              ? DateTime.parse(data['updatedAt'] as String)
              : (data['updatedAt'] as Timestamp).toDate())
          : DateTime.now(),
      archived: data['archived'] as bool? ?? false,
      order: data['order'] as int? ?? 0,
    );
  }

  /// Generate unique habit ID
  String _generateHabitId() {
    return _firestore.collection('users').doc().id;
  }
}

/// Helper function
int max(int a, int b) => a > b ? a : b;
