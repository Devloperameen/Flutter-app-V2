import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/presentation/providers/habit_calendar_provider.dart';
import 'package:safe/core/utils/app_logger.dart';

class HabitCalendarScreen extends ConsumerStatefulWidget {
  const HabitCalendarScreen({
    required this.habitId,
    required this.habit,
    super.key,
  });

  final String habitId;
  final Habit habit;

  @override
  ConsumerState<HabitCalendarScreen> createState() =>
      _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends ConsumerState<HabitCalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completions = ref.watch(
      habitCompletionsProvider(widget.habitId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.habit.emoji} ${widget.habit.title}'),
        centerTitle: false,
        elevation: 0,
      ),
      body: completions.when(
        data: (completionDates) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Streak information card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withOpacity(0.5),
                      theme.colorScheme.secondaryContainer.withOpacity(0.3),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StreakInfo(
                      label: 'Current Streak',
                      value: widget.habit.currentStreak,
                      emoji: '🔥',
                    ),
                    _StreakInfo(
                      label: 'Longest Streak',
                      value: widget.habit.longestStreak,
                      emoji: '🏆',
                    ),
                    _StreakInfo(
                      label: 'Total Completions',
                      value: widget.habit.totalCompletions,
                      emoji: '✅',
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Statistics
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _StatisticRow(
                      label: 'Completion Rate',
                      value: _calculateCompletionRate(completionDates),
                      suffix: '%',
                    ),
                    SizedBox(height: AppSpacing.md),
                    _StatisticRow(
                      label: 'Completed This Month',
                      value: _countThisMonth(completionDates),
                      suffix: ' days',
                    ),
                    SizedBox(height: AppSpacing.md),
                    _StatisticRow(
                      label: 'Created',
                      value: _formatDate(widget.habit.createdAt),
                      suffix: '',
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.cardRadius),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: widget.habit.createdAt,
                  lastDay: DateTime.now(),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isCompleted = completionDates.any(
                        (date) => isSameDay(date, day),
                      );
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isCompleted
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final isCompleted = completionDates.any(
                        (date) => isSameDay(date, day),
                      );
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                          color: isCompleted
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isCompleted
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.tertiary,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Legend
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legend',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text('Completed', style: theme.textTheme.bodySmall),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text('Today', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  int _calculateCompletionRate(List<DateTime> completionDates) {
    if (completionDates.isEmpty) return 0;
    final daysActive = DateTime.now()
            .difference(widget.habit.createdAt)
            .inDays +
        1;
    return ((completionDates.length / daysActive) * 100).toInt();
  }

  int _countThisMonth(List<DateTime> completionDates) {
    final now = DateTime.now();
    return completionDates
        .where((date) => date.year == now.year && date.month == now.month)
        .length;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StreakInfo extends StatelessWidget {
  const _StreakInfo({
    required this.label,
    required this.value,
    required this.emoji,
  });

  final String label;
  final int value;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({
    required this.label,
    required this.value,
    required this.suffix,
  });

  final String label;
  final dynamic value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          '$value$suffix',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
