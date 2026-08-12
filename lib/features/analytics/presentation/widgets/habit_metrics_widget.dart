import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';

/// Widget displaying habit completion metrics
class HabitMetricsWidget extends StatelessWidget {

  const HabitMetricsWidget({
    super.key,
    required this.habitAnalytics,
  });
  final HabitAnalytics habitAnalytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Habit Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Completion stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Completed',
                    value: habitAnalytics.completedCount.toString(),
                    subLabel: 'of ${habitAnalytics.totalOpportunities}',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Habits',
                    value: habitAnalytics.totalHabits.toString(),
                    subLabel: 'active',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Rate',
                    value: '${habitAnalytics.completionRate.toStringAsFixed(0)}%',
                    subLabel: 'completion',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: habitAnalytics.completionRate / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(habitAnalytics.completionRate),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Top habits
            if (habitAnalytics.topHabits.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Top Habits',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...habitAnalytics.topHabits.take(3).map((habitId) {
                    final rate = habitAnalytics.habitCompletionRates[habitId] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            habitId,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${rate.toStringAsFixed(0)}%',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 50) return Colors.orange;
    return Colors.red;
  }
}

class _StatItem extends StatelessWidget {

  const _StatItem({
    required this.label,
    required this.value,
    required this.subLabel,
  });
  final String label;
  final String value;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
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
