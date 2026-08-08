import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/domain/models/habit_analytics.dart';
import 'package:safe/features/analytics/domain/models/focus_analytics.dart';

/// Widget displaying analytics charts
class AnalyticsChartWidget extends StatelessWidget {
  final HabitAnalytics habitAnalytics;
  final FocusAnalytics focusAnalytics;
  final AnalyticsPeriod period;

  const AnalyticsChartWidget({
    Key? key,
    required this.habitAnalytics,
    required this.focusAnalytics,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Habit completion chart
        if (habitAnalytics.dailyData.isNotEmpty)
          _buildHabitChart(context),
        if (habitAnalytics.dailyData.isEmpty && habitAnalytics.totalHabits > 0)
          _buildEmptyChartPlaceholder(context, 'Daily Habit Chart'),
        const SizedBox(height: 16),
        // Focus session chart
        if (focusAnalytics.dailyData.isNotEmpty)
          _buildFocusChart(context),
        if (focusAnalytics.dailyData.isEmpty && focusAnalytics.totalSessions > 0)
          _buildEmptyChartPlaceholder(context, 'Daily Focus Chart'),
      ],
    );
  }

  Widget _buildHabitChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Habit Completions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            // Simple bar chart representation
            _buildSimpleBarChart(
              context,
              habitAnalytics.dailyData
                  .map((d) => d.completions.toDouble())
                  .toList(),
              _getDayLabels(period),
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Focus Minutes',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            // Simple bar chart representation
            _buildSimpleBarChart(
              context,
              focusAnalytics.dailyData
                  .map((d) => d.minutes.toDouble())
                  .toList(),
              _getDayLabels(period),
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart(
    BuildContext context,
    List<double> values,
    List<String> labels,
    Color barColor,
  ) {
    if (values.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No data available',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ),
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final maxHeight = maxValue > 0 ? maxValue : 1;

    return SizedBox(
      height: 200,
      child: Column(
        children: [
          // Chart area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  values.length,
                  (index) {
                    final value = values[index];
                    final percentage = (value / maxHeight).clamp(0.0, 1.0);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Value label
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            value.toStringAsFixed(0),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        // Bar
                        Expanded(
                          flex: (percentage * 100).toInt().clamp(1, 100),
                          child: Container(
                            width: 24,
                            decoration: BoxDecoration(
                              color: barColor.withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: (100 - percentage * 100).toInt().clamp(0, 99),
                          child: Container(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // Labels
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.map((label) {
                return SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChartPlaceholder(BuildContext context, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.bar_chart,
                size: 40,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Chart data coming soon',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getDayLabels(AnalyticsPeriod period) {
    switch (period.type) {
      case AnalyticsPeriodType.week:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case AnalyticsPeriodType.month:
        return List.generate(
          (period.endDate.difference(period.startDate).inDays ~/ 7) + 1,
          (i) => 'W${i + 1}',
        );
      default:
        return [];
    }
  }
}
