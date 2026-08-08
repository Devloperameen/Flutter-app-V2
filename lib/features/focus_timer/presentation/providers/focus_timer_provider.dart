import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/focus_timer/data/datasources/focus_timer_datasource.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/focus_timer/domain/models/timer_config.dart';

part 'focus_timer_provider.g.dart';

@riverpod
class FocusTimerNotifier extends _$FocusTimerNotifier {
  @override
  FutureOr<TimerState> build() async {
    return const TimerState(
      secondsRemaining: 1500,
      totalSeconds: 1500,
      isRunning: false,
      isPaused: false,
      currentPhase: 'focus',
      cycleCount: 0,
    );
  }

  late FocusTimerDatasource _datasource = FocusTimerDatasource();
  late FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;
  int _secondsRemaining = 1500;
  int _totalSeconds = 1500;
  bool _isRunning = false;
  String _currentSessionId = '';
  TimerConfig _currentConfig = TimerConfig.presets[0]; // Default to deep work

  Future<void> startFocusSession({
    String? missionTitle,
    TimerConfig? config,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Use provided config or default to deep work
      _currentConfig = config ?? TimerConfig.presets[0];

      log.i('⏱️ Starting focus session with ${_currentConfig.name}');

      final session = await _datasource.startFocusSession(
        userId,
        sessionType: 'focus',
        durationSeconds: _currentConfig.durationSeconds,
        missionTitle: missionTitle ?? _currentConfig.name,
        xpReward: _currentConfig.xpReward,
      );

      _currentSessionId = session.id;
      _totalSeconds = _currentConfig.durationSeconds;
      _secondsRemaining = _currentConfig.durationSeconds;
      _isRunning = true;

      state = AsyncValue.data(TimerState(
        secondsRemaining: _secondsRemaining,
        totalSeconds: _totalSeconds,
        isRunning: true,
        isPaused: false,
        currentPhase: 'focus',
        cycleCount: 0,
      ));

      _startTimer();
    } catch (e, st) {
      log.e('❌ Failed to start: $e', stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  void pauseTimer() {
    try {
      _isRunning = false;
      _timer?.cancel();

      state = AsyncValue.data((state.value ?? const TimerState(
        secondsRemaining: 0,
        totalSeconds: 0,
        isRunning: false,
        isPaused: false,
        currentPhase: 'idle',
        cycleCount: 0,
      )).copyWith(isRunning: false, isPaused: true));

      log.i('⏸️ Timer paused');
    } catch (e, st) {
      log.e('❌ Pause failed: $e', stackTrace: st);
    }
  }

  void resumeTimer() {
    try {
      _isRunning = true;
      state = AsyncValue.data((state.value ?? const TimerState(
        secondsRemaining: 0,
        totalSeconds: 0,
        isRunning: false,
        isPaused: false,
        currentPhase: 'idle',
        cycleCount: 0,
      )).copyWith(isRunning: true, isPaused: false));

      _startTimer();
      log.i('▶️ Timer resumed');
    } catch (e, st) {
      log.e('❌ Resume failed: $e', stackTrace: st);
    }
  }

  Future<void> stopFocusSession() async {
    try {
      _isRunning = false;
      _timer?.cancel();

      final userId = _auth.currentUser?.uid;
      if (userId != null && _currentSessionId.isNotEmpty) {
        final completedSeconds = _totalSeconds - _secondsRemaining;
        // Use actual XP reward from the timer config
        await _datasource.completeFocusSession(
          userId,
          _currentSessionId,
          completedSeconds: completedSeconds,
          xpReward: _currentConfig.xpReward,
        );
      }

      state = AsyncValue.data(const TimerState(
        secondsRemaining: 0,
        totalSeconds: 0,
        isRunning: false,
        isPaused: false,
        currentPhase: 'idle',
        cycleCount: 0,
      ));

      _currentSessionId = '';
      log.i('✅ Session completed with ${_currentConfig.xpReward} XP');
    } catch (e, st) {
      log.e('❌ Stop failed: $e', stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && _isRunning) {
        _secondsRemaining--;

        state = AsyncValue.data(TimerState(
          secondsRemaining: _secondsRemaining,
          totalSeconds: _totalSeconds,
          isRunning: _isRunning,
          isPaused: false,
          currentPhase: 'focus',
          cycleCount: 0,
        ));

        if (_secondsRemaining == 0) {
          stopFocusSession();
        }
      }
    });
  }
}
