import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/core/utils/app_logger.dart';

part 'habit_actions_provider.g.dart';

/// Provider for creating a new habit
@riverpod
Future<void> createHabitAction(
  CreateHabitActionRef ref, {
  required String title,
  required String emoji,
  required String color,
  required String category,
  String? description,
  bool reminderEnabled = false,
  String? reminderTime,
  int targetMinutes = 0,
}) async {
  try {
    log.i('➕ Creating habit: $title');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      emoji: emoji,
      color: color,
      category: category,
      description: description,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      targetMinutes: targetMinutes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repository.createHabit(userId, habit);
    log.i('✅ Habit created successfully');
  } catch (e, st) {
    log.e('❌ Failed to create habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for completing a habit
@riverpod
Future<void> completeHabitAction(
  CompleteHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('✅ Completing habit: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.markHabitComplete(userId, habitId);
    log.i('✅ Habit marked complete');
  } catch (e, st) {
    log.e('❌ Failed to complete habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for undoing habit completion
@riverpod
Future<void> undoHabitAction(
  UndoHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('↩️ Undoing completion: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.undoHabitComplete(userId, habitId);
    log.i('✅ Completion undone');
  } catch (e, st) {
    log.e('❌ Failed to undo completion: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for deleting a habit
@riverpod
Future<void> deleteHabitAction(
  DeleteHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('🗑️ Deleting habit: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.deleteHabit(userId, habitId);
    log.i('✅ Habit deleted');
  } catch (e, st) {
    log.e('❌ Failed to delete habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for archiving a habit
@riverpod
Future<void> archiveHabitAction(
  ArchiveHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('📦 Archiving habit: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.archiveHabit(userId, habitId);
    log.i('✅ Habit archived');
  } catch (e, st) {
    log.e('❌ Failed to archive habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for restoring a habit
@riverpod
Future<void> restoreHabitAction(
  RestoreHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('♻️ Restoring habit: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.restoreHabit(userId, habitId);
    log.i('✅ Habit restored');
  } catch (e, st) {
    log.e('❌ Failed to restore habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for duplicating a habit
@riverpod
Future<void> duplicateHabitAction(
  DuplicateHabitActionRef ref,
  String habitId,
) async {
  try {
    log.i('📋 Duplicating habit: $habitId');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.duplicateHabit(userId, habitId);
    log.i('✅ Habit duplicated');
  } catch (e, st) {
    log.e('❌ Failed to duplicate habit: $e', stackTrace: st);
    rethrow;
  }
}

/// Provider for reordering habits
@riverpod
Future<void> reorderHabitsAction(
  ReorderHabitsActionRef ref,
  List<String> habitIds,
) async {
  try {
    log.i('🔄 Reordering ${habitIds.length} habits');
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final repository = ref.read(habitRepositoryProvider);
    await repository.reorderHabits(userId, habitIds);
    log.i('✅ Habits reordered');
  } catch (e, st) {
    log.e('❌ Failed to reorder habits: $e', stackTrace: st);
    rethrow;
  }
}
