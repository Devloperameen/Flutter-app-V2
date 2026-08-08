import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/core/utils/app_logger.dart';

part 'habit_calendar_provider.g.dart';

/// Provider for getting completion history of a habit
/// Returns list of dates when habit was completed
@riverpod
Future<List<DateTime>> habitCompletions(
  HabitCompletionsRef ref,
  String habitId,
) async {
  try {
    final userId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      log.w('⚠️ No authenticated user');
      return [];
    }

    final repository = ref.read(habitRepositoryProvider);
    return await repository.getCompletionHistory(userId, habitId);
  } catch (e, st) {
    log.e('❌ Failed to get habit completions: $e', stackTrace: st);
    rethrow;
  }
}
