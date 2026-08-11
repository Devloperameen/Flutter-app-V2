import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/focus_timer/domain/models/focus_session.dart';
import 'package:safe/features/focus_timer/presentation/providers/focus_providers.dart';

/// Focus Timer Screen
/// Main screen for tracking focus/Pomodoro sessions
/// Shows active session timer, completion controls, and statistics
class FocusTimerScreen extends ConsumerStatefulWidget {
  const FocusTimerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen> {
  Timer? _timerTick;
  String _displayTime = '00:00';

  @override
  void initState() {
    super.initState();
    // Start timer tick
    _timerTick = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        // Timer UI updates on each tick
      });
    });
  }

  @override
  void dispose() {
    _timerTick?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFocusSessionProvider);
    final dailyStats = ref.watch(focusDailyStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        centerTitle: true,
        elevation: 0,
      ),
      body: activeSession.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
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
            // No active session - show create session UI
            return _buildCreateSessionUI(context, ref, dailyStats);
          } else {
            // Active session - show timer UI
            return _buildActiveSessionUI(context, ref, session, dailyStats);
          }
        },
      ),
    );
  }

  /// Build UI when no active session
  Widget _buildCreateSessionUI(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<String, dynamic>> dailyStats,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Large icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
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
            'Choose a session duration and focus deeply',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Session options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildSessionButton(
                  context,
                  ref,
                  '25 Minutes',
                  '25min',
                  25,
                  '⏱️ Perfect for quick bursts',
                ),
                const SizedBox(height: 12),
                _buildSessionButton(
                  context,
                  ref,
                  '50 Minutes',
                  '50min',
                  50,
                  '🎯 Deep work focus',
                ),
                const SizedBox(height: 12),
                _buildSessionButton(
                  context,
                  ref,
                  'Custom',
                  'custom',
                  0,
                  '⚙️ Set your own duration',
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Today's stats
          if (dailyStats.hasValue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatsCard(dailyStats.value!),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build session creation button
  Widget _buildSessionButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    String sessionType,
    int duration,
    String subtitle,
  ) {
    return InkWell(
      onTap: () async {
        try {
          int finalDuration = duration;
          if (sessionType == 'custom') {
            finalDuration = await _showCustomDurationDialog(context) ?? 25;
          }

          // Create session
          await ref.read(createFocusSessionProvider(
            (sessionType: sessionType, duration: finalDuration),
          ).future);

          // Refresh active session
          ref.refresh(activeFocusSessionProvider);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Session started!')),
            );
          }
        } catch (e) {
          log.e('Error creating session: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      },
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

  /// Build active session UI with timer
  Widget _buildActiveSessionUI(
    BuildContext context,
    WidgetRef ref,
    FocusSession session,
    AsyncValue<Map<String, dynamic>> dailyStats,
  ) {
    final remainingSeconds = session.remainingSeconds;
    final displayTime = _formatTime(remainingSeconds);
    final progress = session.progress;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Session type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              session.sessionType == 'custom'
                  ? 'Custom Session'
                  : session.sessionType,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Large timer display
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                displayTime,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress > 0.8 ? Colors.red : Colors.blue,
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
          ),
          const SizedBox(height: 48),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleAbandonSession(ref, context, session),
                    icon: const Icon(Icons.close),
                    label: const Text('Abandon'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleCompleteSession(ref, context, session),
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats card
          if (dailyStats.hasValue)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatsCard(dailyStats.value!),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build statistics card
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
            'Today\'s Statistics',
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

  Future<int?> _showCustomDurationDialog(BuildContext context) async {
    final controller = TextEditingController(text: '25');
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Duration'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Minutes (1-300)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text) ?? 25;
              if (minutes < 1 || minutes > 300) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Duration must be 1-300 minutes')),
                );
                return;
              }
              Navigator.pop(context, minutes);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCompleteSession(
    WidgetRef ref,
    BuildContext context,
    FocusSession session,
  ) async {
    try {
      await ref.read(completeSessionProvider(session.id).future);
      ref.refresh(focusDailyStatsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Session completed! XP awarded!')),
        );
      }
    } catch (e) {
      log.e('Error completing session: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleAbandonSession(
    WidgetRef ref,
    BuildContext context,
    FocusSession session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandon Session?'),
        content: const Text('You won\'t earn XP for this session.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Abandon'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(abandonSessionProvider(session.id).future);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session abandoned')),
          );
        }
      } catch (e) {
        log.e('Error abandoning session: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
