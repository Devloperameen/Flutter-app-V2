import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';

/// Widget displaying streak statistics
class StreaksWidget extends StatelessWidget {
  final HabitAnalytics habitAnalytics;

  const StreaksWidget({
    Key? key,
    required this.habitAnalytics,
  }) : super(key: key);

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
                  Icons.local_fire_department,
                  color: Colors.deepOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Streak Power',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Current and longest streaks
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: habitAnalytics.currentStreak > 0
                          ? Colors.orange.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: habitAnalytics.currentStreak > 0
                            ? Colors.orange.shade200
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${habitAnalytics.currentStreak}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: habitAnalytics.currentStreak > 0
                                        ? Colors.deepOrange
                                        : Colors.grey.shade600,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'days',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildStreakStatus(
                          context,
                          habitAnalytics.currentStreak,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Longest Streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${habitAnalytics.longestStreak}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.purple.shade600,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'days',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All-time personal best 🏆',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Streak tips
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      habitAnalytics.currentStreak > 0
                          ? 'Keep up the momentum! Don\'t break your streak today.'
                          : 'Start a new streak by completing your habits today!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade900,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStatus(BuildContext context, int streak) {
    if (streak >= 7) {
      return Row(
        children: [
          Icon(Icons.whatshot, size: 16, color: Colors.red.shade600),
          const SizedBox(width: 4),
          Text(
            'On fire! 🔥',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    } else if (streak >= 3) {
      return Row(
        children: [
          Icon(Icons.trending_up, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            'Building momentum',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    } else if (streak > 0) {
      return Row(
        children: [
          Icon(Icons.start, size: 16, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            'Great start!',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    } else {
      return Text(
        'Start today for your first day!',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
      );
    }
  }
}
