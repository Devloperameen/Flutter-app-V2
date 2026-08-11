import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/focus_timer/data/datasources/http_focus_timer_datasource.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/focus_timer/domain/models/timer_config.dart';
import 'package:safe/core/providers/core_providers.dart';

part 'focus_timer_provider.g.dart';

class TimerState {
  final int secondsRemaining;
  final int totalSeconds;
  final bool isRunning;
  final bool isPaused;
  final String currentPhase;
  final int cycleCount;

  const TimerState({
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.currentPhase,
    required this.cycleCount,
  });

  TimerState copyWith({
    int? secondsRemaining,
    int? totalSeconds,
    bool? isRunning,
    bool? isPaused,
    String? currentPhase,
    int? cycleCount,
  }) {
    return TimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      currentPhase: currentPhase ?? this.currentPhase,
      cycleCount: cycleCount ?? this.cycleCount,
    );
  }
}

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

  late HttpFocusTimerDatasource _datasource;
  late AuthRepository _authRepository;
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
      _datasource = HttpFocusTimerDatasource(apiClient: ref.read(apiClientProvider));
      _authRepository = ref.read(authRepositoryProvider);

      final userId = _authRepository.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('User not authenticated');
      }

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

      final userId = _authRepository.getCurrentUserId();
      if (userId != null && userId.isNotEmpty && _currentSessionId.isNotEmpty) {
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
