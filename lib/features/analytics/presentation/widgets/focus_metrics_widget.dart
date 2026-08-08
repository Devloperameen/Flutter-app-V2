import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/focus_analytics.dart';

/// Widget displaying focus session metrics
class FocusMetricsWidget extends StatelessWidget {
  final FocusAnalytics focusAnalytics;

  const FocusMetricsWidget({
    Key? key,
    required this.focusAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hoursCompleted = focusAnalytics.completedMinutes / 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Focus Sessions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Main metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _FocusStatItem(
                    label: 'Sessions',
                    value: focusAnalytics.completedSessions.toString(),
                    subLabel: 'completed',
                  ),
                ),
                Expanded(
                  child: _FocusStatItem(
                    label: 'Focus Time',
                    value: hoursCompleted >= 1
                        ? '${hoursCompleted.toStringAsFixed(1)}h'
                        : '${focusAnalytics.completedMinutes}m',
                    subLabel: 'total',
                  ),
                ),
                Expanded(
                  child: _FocusStatItem(
                    label: 'Average',
                    value: '${focusAnalytics.averageSessionMinutes.toStringAsFixed(0)}m',
                    subLabel: 'per session',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // XP and Longest Streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⭐ XP Earned',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.amber.shade800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          focusAnalytics.totalXpEarned.toString(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.amber.shade800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔥 Longest Streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.purple.shade800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${focusAnalytics.longestStreak} sessions',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.purple.shade800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Session types breakdown (if available)
            if (focusAnalytics.sessionsByType.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Session Breakdown',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              ...focusAnalytics.sessionsByType.entries.map((entry) {
                final minutes = focusAnalytics.minutesByType[entry.key] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.key}min sessions',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${entry.value} sessions (${minutes}m total)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _FocusStatItem extends StatelessWidget {
  final String label;
  final String value;
  final String subLabel;

  const _FocusStatItem({
    required this.label,
    required this.value,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        Text(
          subLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
