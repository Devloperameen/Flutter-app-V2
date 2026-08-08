import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/focus_timer/domain/models/timer_config.dart';
import 'package:safe/features/focus_timer/presentation/providers/focus_timer_provider.dart';

class FocusTimerScreen extends ConsumerStatefulWidget {
  const FocusTimerScreen({
    super.key,
    this.config,
  });

  final TimerConfig? config;

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Auto-start focus session when screen opens
    Future.microtask(() {
      ref.read(focusTimerNotifierProvider.notifier).startFocusSession(
            config: widget.config,
          );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerState = ref.watch(focusTimerNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: timerState.when(
        data: (state) => SafeArea(
          child: Column(
            children: [
              // ─── Header ───
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Text(
                      'Focus Session',
                      style: theme.textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
              ),

              // ─── Timer Display ───
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mission title if provided
                      if (widget.config != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.xl),
                          child: Text(
                            widget.config!.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Large timer display
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _pulseController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Text(
                          _formatTime(state.secondsRemaining),
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 120,
                            fontWeight: FontWeight.w300,
                            color: state.secondsRemaining < 300
                                ? Colors.red
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Progress indicator
                      SizedBox(
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: state.totalSeconds > 0
                                ? (state.totalSeconds - state.secondsRemaining) /
                                    state.totalSeconds
                                : 0,
                            minHeight: 8,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerLow,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              state.secondsRemaining < 300
                                  ? Colors.red
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Progress text
                      Text(
                        '${((state.totalSeconds - state.secondsRemaining) / state.totalSeconds * 100).toStringAsFixed(0)}% Complete',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Control Buttons ───
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pause/Resume Button
                    FloatingActionButton.large(
                      heroTag: 'pause_resume',
                      onPressed: state.isRunning
                          ? () {
                              ref
                                  .read(focusTimerNotifierProvider.notifier)
                                  .pauseTimer();
                            }
                          : state.isPaused
                              ? () {
                                  ref
                                      .read(focusTimerNotifierProvider.notifier)
                                      .resumeTimer();
                                }
                              : null,
                      backgroundColor: state.isRunning
                          ? Colors.orange
                          : state.isPaused
                              ? Colors.blue
                              : theme.colorScheme.surfaceContainerHigh,
                      child: Icon(
                        state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: state.isRunning || state.isPaused
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.lg),

                    // Complete Button
                    FloatingActionButton.large(
                      heroTag: 'complete',
                      onPressed: state.isRunning || state.isPaused
                          ? () async {
                              try {
                                await ref
                                    .read(focusTimerNotifierProvider.notifier)
                                    .stopFocusSession();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            }
                          : null,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.lg),

                    // Abandon Button
                    FloatingActionButton.large(
                      heroTag: 'abandon',
                      onPressed: state.isRunning || state.isPaused
                          ? () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Abandon Session?'),
                                  content: const Text(
                                    'Are you sure you want to abandon this focus session? Your progress will not be saved.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Abandon'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ─── Tips Section ───
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Keep your phone away and focus on your task',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
