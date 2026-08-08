import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';
part 'focus_session.g.dart';

@freezed
class FocusSession with _$FocusSession {
  const factory FocusSession({
    required String id,
    required String userId,
    required DateTime startedAt,
    required DateTime? endedAt,
    required int durationSeconds, // Target duration (usually 1500 for 25 min)
    required int completedSeconds, // How much was actually completed
    required String status, // 'active', 'paused', 'completed', 'abandoned'
    required String sessionType, // 'focus', 'break', 'long_break'
    required String? missionTitle,
    required int xpReward,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FocusSession;

  factory FocusSession.fromJson(Map<String, dynamic> json) =>
      _$FocusSessionFromJson(json);
}

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    required int secondsRemaining,
    required int totalSeconds,
    required bool isRunning,
    required bool isPaused,
    required String currentPhase, // 'focus', 'break', 'long_break'
    required int cycleCount,
  }) = _TimerState;

  factory TimerState.fromJson(Map<String, dynamic> json) =>
      _$TimerStateFromJson(json);
}
