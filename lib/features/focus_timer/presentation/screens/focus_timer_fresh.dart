import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/focus_timer/presentation/providers/focus_providers.dart';

// Import FocusStatus enum
// Note: FocusStatus is defined inline in focus_session.dart model file

/// ✅ FRESH FOCUS TIMER SCREEN
/// Complete rebuild with START, PAUSE, RESUME, STOP functionality
/// 
/// Features:
/// - Start new focus sessions (25min, 50min, custom)
/// - Pause active sessions
/// - Resume paused sessions  
/// - Stop/end sessions
/// - View daily statistics
/// - Real-time timer updates
/// - Full backend API integration
class FreshFocusTimerScreen extends ConsumerStatefulWidget {
  const FreshFocusTimerScreen({super.key});

  @override
  ConsumerState<FreshFocusTimerScreen> createState() =>
      _FreshFocusTimerScreenState();
}

class _FreshFocusTimerScreenState extends ConsumerState<FreshFocusTimerScreen> {
  Timer? _timerTick;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    log.i('🎯 Fresh Focus Timer Screen initialized');

    // Start periodic timer for UI updates (every 100ms)
    _timerTick = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {
          // Trigger rebuild to update timer display
        });
      }
    });
  }

  @override
  void dispose() {
    log.i('🎯 Fresh Focus Timer Screen disposed');
    _timerTick?.cancel();
    _timerTick = null;
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // ════════════════════════════════════════════════════
  // ✅ START SESSION
  // ════════════════════════════════════════════════════

  Future<void> _handleStartSession({
    required String sessionType,
    required int duration,
  }) async {
    try {
      setState(() => _isLoading = true);

      log.i('🚀 Starting session: $sessionType for $duration minutes');

      await ref.read(
        startFocusSessionProvider(
          (sessionType: sessionType, duration: duration),
        ).future,
      );

      if (mounted) {
        log.i('✅ Session started successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Focus session started! Stay focused!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log.e('❌ Error starting session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ PAUSE SESSION
  // ════════════════════════════════════════════════════

  Future<void> _handlePauseSession(String sessionId) async {
    try {
      setState(() => _isLoading = true);

      log.i('⏸️ Pausing session: $sessionId');

      await ref.read(pauseFocusSessionProvider(sessionId).future);

      if (mounted) {
        log.i('✅ Session paused');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏸️ Session paused. Take a break!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log.e('❌ Error pausing session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ RESUME SESSION
  // ════════════════════════════════════════════════════

  Future<void> _handleResumeSession(String sessionId) async {
    try {
      setState(() => _isLoading = true);

      log.i('▶️ Resuming session: $sessionId');

      await ref.read(resumeFocusSessionProvider(sessionId).future);

      if (mounted) {
        log.i('✅ Session resumed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('▶️ Let\'s get back to focus!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log.e('❌ Error resuming session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ════════════════════════════════════════════════════
  // ✅ STOP SESSION
  // ════════════════════════════════════════════════════

  Future<void> _handleStopSession(String sessionId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Session?'),
        content: const Text(
          'Are you sure you want to stop this session?\n\nYou can resume it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Stop'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() => _isLoading = true);

      log.i('⏹️ Stopping session: $sessionId');

      await ref.read(stopFocusSessionProvider(sessionId).future);

      if (mounted) {
        log.i('✅ Session stopped');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏹️ Session ended'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log.e('❌ Error stopping session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ════════════════════════════════════════════════════
  // CUSTOM DURATION DIALOG
  // ════════════════════════════════════════════════════

  Future<int?> _showCustomDurationDialog() async {
    final controller = TextEditingController(text: '25');
    bool isMinutes = true;

    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Custom Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(label: Text('Minutes'), value: true),
                        ButtonSegment(label: Text('Seconds'), value: false),
                      ],
                      selected: {isMinutes},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() => isMinutes = newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isMinutes ? 'Minutes (1-300)' : 'Seconds (1-18000)',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text) ?? (isMinutes ? 25 : 1500);

                if (isMinutes) {
                  if (value < 1 || value > 300) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Minutes must be 1-300'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, value);
                } else {
                  if (value < 1 || value > 18000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Seconds must be 1-18000'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, value);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFocusSessionProvider);
    final dailyStats = ref.watch(focusDailyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Focus Timer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: activeSession.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(activeFocusSessionProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (session) {
          if (session == null) {
            // ════════════════════════════════════════════════
            // ✅ NO ACTIVE SESSION - SHOW START OPTIONS
            // ════════════════════════════════════════════════
            return _buildCreateSessionUI(dailyStats);
          } else {
            // ════════════════════════════════════════════════
            // ✅ ACTIVE SESSION - SHOW TIMER & CONTROLS
            // ════════════════════════════════════════════════
            return _buildActiveSessionUI(session, dailyStats);
          }
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // ✅ CREATE SESSION UI (No active session)
  // ════════════════════════════════════════════════════

  Widget _buildCreateSessionUI(AsyncValue<Map<String, dynamic>> dailyStats) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.timer,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Start a Focus Session',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a duration and focus deeply',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // ✅ 25 MIN BUTTON
            _buildStartButton(
              label: '25 Minutes',
              subtitle: '⏱️ Pomodoro session',
              onPressed: () => _handleStartSession(
                sessionType: '25min',
                duration: 25,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ 50 MIN BUTTON
            _buildStartButton(
              label: '50 Minutes',
              subtitle: '🎯 Deep work session',
              onPressed: () => _handleStartSession(
                sessionType: '50min',
                duration: 50,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ CUSTOM BUTTON
            _buildStartButton(
              label: 'Custom Duration',
              subtitle: '⚙️ Set your own time',
              onPressed: () async {
                final duration = await _showCustomDurationDialog();
                if (duration != null && mounted) {
                  _handleStartSession(
                    sessionType: 'custom',
                    duration: duration,
                  );
                }
              },
            ),
            const SizedBox(height: 48),

            // Today's Stats
            if (dailyStats.hasValue)
              _buildStatsCard(dailyStats.value!),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton({
    required String label,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // ✅ ACTIVE SESSION UI (Timer & Controls)
  // ════════════════════════════════════════════════════

  Widget _buildActiveSessionUI(
    FocusSession session,
    AsyncValue<Map<String, dynamic>> dailyStats,
  ) {
    final remainingSeconds = session.remainingSeconds;
    final displayTime = _formatTime(remainingSeconds);
    final progress = session.progress;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(session.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusLabel(session.status),
                style: TextStyle(
                  color: _getStatusColor(session.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Large Timer Display
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(session.status).withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  displayTime,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: _getStatusColor(session.status),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Progress Bar
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress > 0.8 ? Colors.red : _getStatusColor(session.status),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% Complete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // ✅ ACTION BUTTONS
            Row(
              children: [
                // Pause/Resume Button
                if (session.status == 'active')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _handlePauseSession(session.id),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        disabledBackgroundColor: Colors.grey,
                      ),
                    ),
                  )
                else if (session.status == 'paused')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _handleResumeSession(session.id),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),

                // Stop Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _handleStopSession(session.id),
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Today's Stats
            if (dailyStats.hasValue)
              _buildStatsCard(dailyStats.value!),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // STATS CARD
  // ════════════════════════════════════════════════════

  Widget _buildStatsCard(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            "Today's Statistics",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Sessions',
                '${stats['completedSessions'] ?? 0}',
                '🎯',
              ),
              _buildStatColumn(
                'Minutes',
                '${stats['totalMinutes'] ?? 0}',
                '⏱️',
              ),
              _buildStatColumn(
                'XP Earned',
                '${stats['totalXP'] ?? 0}',
                '⭐',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // HELPER METHODS
  // ════════════════════════════════════════════════════

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'stopped':
      case 'abandoned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return '🔥 Active';
      case 'paused':
        return '⏸️ Paused';
      case 'completed':
        return '✅ Completed';
      case 'stopped':
        return '⏹️ Stopped';
      case 'abandoned':
        return '❌ Abandoned';
      default:
        return status;
    }
  }
}
