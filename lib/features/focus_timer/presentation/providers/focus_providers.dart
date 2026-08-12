import 'package:riverpod/riverpod.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/focus_timer/data/repositories/focus_repository.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';

// ─────────────────────────────────────────────────
// REPOSITORY PROVIDER
// ─────────────────────────────────────────────────

/// Provides FocusRepository instance
/// Depends on ApiClient which is auto-initialized
final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FocusRepository(apiClient);
});

// ─────────────────────────────────────────────────
// ACTIVE SESSION PROVIDER
// ─────────────────────────────────────────────────

/// Fetches and watches user's active focus session
/// Automatically refetches when invalidated
/// Returns null if no active session
final activeFocusSessionProvider =
    FutureProvider.autoDispose<FocusSession?>((ref) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getActiveSession();
});

// ─────────────────────────────────────────────────
// CREATE SESSION PROVIDER
// ─────────────────────────────────────────────────

/// Creates a new focus session
/// Usage: ref.read(createFocusSessionProvider(request).future)
final createFocusSessionProvider =
    FutureProvider.family<FocusSession, ({String sessionType, int duration})>(
  (ref, params) async {
    final repository = ref.watch(focusRepositoryProvider);
    return repository.createSession(
      sessionType: params.sessionType,
      duration: params.duration,
    );
  },
);

// ─────────────────────────────────────────────────
// SESSION HISTORY PROVIDER
// ─────────────────────────────────────────────────

/// Fetches paginated focus session history
/// Can be used for infinite scrolling with different pages
final sessionHistoryProvider =
    FutureProvider.family<List<FocusSession>, ({int page, int limit})>(
  (ref, params) async {
    final repository = ref.watch(focusRepositoryProvider);
    return repository.getSessionHistory(
      page: params.page,
      limit: params.limit,
    );
  },
);

// ─────────────────────────────────────────────────
// COMPLETE SESSION PROVIDER
// ─────────────────────────────────────────────────

/// Completes a focus session and awards XP
/// Usage: ref.read(completeSessionProvider(sessionId).future)
final completeSessionProvider =
    FutureProvider.family<FocusSession, String>((ref, sessionId) async {
  final repository = ref.watch(focusRepositoryProvider);
  final session = await repository.completeSession(sessionId);
  
  // Invalidate related providers to refresh UI
  ref.invalidate(activeFocusSessionProvider);
  ref.invalidate(focusDailyStatsProvider);
  ref.invalidate(focusWeeklyStatsProvider);
  
  return session;
});

// ─────────────────────────────────────────────────
// ABANDON SESSION PROVIDER
// ─────────────────────────────────────────────────

/// Abandons a focus session without earning XP
/// Usage: ref.read(abandonSessionProvider(sessionId).future)
final abandonSessionProvider =
    FutureProvider.family<FocusSession, String>((ref, sessionId) async {
  final repository = ref.watch(focusRepositoryProvider);
  final session = await repository.abandonSession(sessionId);
  
  // Invalidate related providers
  ref.invalidate(activeFocusSessionProvider);
  
  return session;
});

// ─────────────────────────────────────────────────
// DAILY STATS PROVIDER
// ─────────────────────────────────────────────────

/// Fetches today's focus statistics
/// Auto-refetches when invalidated
final focusDailyStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getDailyStats();
});

// ─────────────────────────────────────────────────
// WEEKLY STATS PROVIDER
// ─────────────────────────────────────────────────

/// Fetches this week's focus statistics
/// Includes daily breakdown
final focusWeeklyStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getWeeklyStats();
});

// ─────────────────────────────────────────────────
// TIMER STATE PROVIDER
// ─────────────────────────────────────────────────

/// Local state for timer countdown
/// Tracks seconds remaining and paused state
class TimerState {

  TimerState({
    required this.secondsRemaining,
    required this.isPaused,
    required this.startTime,
    required this.totalSeconds,
  });
  final int secondsRemaining;
  final bool isPaused;
  final DateTime startTime;
  final int totalSeconds;

  TimerState copyWith({
    int? secondsRemaining,
    bool? isPaused,
    DateTime? startTime,
    int? totalSeconds,
  }) {
    return TimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isPaused: isPaused ?? this.isPaused,
      startTime: startTime ?? this.startTime,
      totalSeconds: totalSeconds ?? this.totalSeconds,
    );
  }
}

/// Local timer state management
final timerStateProvider =
    StateNotifierProvider.family<TimerNotifier, TimerState, FocusSession>(
  (ref, session) {
    final totalSeconds = session.durationSeconds;
    return TimerNotifier(
      initialState: TimerState(
        secondsRemaining: totalSeconds,
        isPaused: false,
        startTime: DateTime.now(),
        totalSeconds: totalSeconds,
      ),
    );
  },
);

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({required TimerState initialState})
      : super(initialState);

  void tick() {
    if (!state.isPaused && state.secondsRemaining > 0) {
      state = state.copyWith(
        secondsRemaining: state.secondsRemaining - 1,
      );
    }
  }

  void pause() {
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    state = state.copyWith(isPaused: false);
  }

  void reset() {
    state = state.copyWith(
      secondsRemaining: state.totalSeconds,
      isPaused: false,
    );
  }
}
