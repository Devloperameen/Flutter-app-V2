import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/analytics_insight.dart';

/// Widget displaying a single insight card
class InsightsCard extends StatelessWidget {

  const InsightsCard({
    super.key,
    required this.insight,
  });
  final AnalyticsInsight insight;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final iconColor = _getIconColor();

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    insight.emoji ?? '💡',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getTitleColor(),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        insight.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getTextColor(),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Priority indicator
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriorityBadge(priority: insight.priority),
                Text(
                  _formatInsightType(insight.type),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (insight.type) {
      case InsightType.achievement:
        return Colors.green.shade50;
      case InsightType.milestone:
        return Colors.amber.shade50;
      case InsightType.streak:
        return Colors.orange.shade50;
      case InsightType.improvement:
        return Colors.blue.shade50;
      case InsightType.comparison:
        return Colors.purple.shade50;
      case InsightType.prediction:
        return Colors.indigo.shade50;
      case InsightType.encouragement:
        return Colors.pink.shade50;
    }
  }

  Color _getTitleColor() {
    switch (insight.type) {
      case InsightType.achievement:
        return Colors.green.shade900;
      case InsightType.milestone:
        return Colors.amber.shade900;
      case InsightType.streak:
        return Colors.orange.shade900;
      case InsightType.improvement:
        return Colors.blue.shade900;
      case InsightType.comparison:
        return Colors.purple.shade900;
      case InsightType.prediction:
        return Colors.indigo.shade900;
      case InsightType.encouragement:
        return Colors.pink.shade900;
    }
  }

  Color _getTextColor() {
    switch (insight.type) {
      case InsightType.achievement:
        return Colors.green.shade800;
      case InsightType.milestone:
        return Colors.amber.shade800;
      case InsightType.streak:
        return Colors.orange.shade800;
      case InsightType.improvement:
        return Colors.blue.shade800;
      case InsightType.comparison:
        return Colors.purple.shade800;
      case InsightType.prediction:
        return Colors.indigo.shade800;
      case InsightType.encouragement:
        return Colors.pink.shade800;
    }
  }

  Color _getIconColor() {
    switch (insight.type) {
      case InsightType.achievement:
        return Colors.green;
      case InsightType.milestone:
        return Colors.amber;
      case InsightType.streak:
        return Colors.deepOrange;
      case InsightType.improvement:
        return Colors.blue;
      case InsightType.comparison:
        return Colors.purple;
      case InsightType.prediction:
        return Colors.indigo;
      case InsightType.encouragement:
        return Colors.pink;
    }
  }

  String _formatInsightType(InsightType type) {
    switch (type) {
      case InsightType.achievement:
        return 'Achievement';
      case InsightType.milestone:
        return 'Milestone';
      case InsightType.streak:
        return 'Streak';
      case InsightType.improvement:
        return 'Improvement';
      case InsightType.comparison:
        return 'Comparison';
      case InsightType.prediction:
        return 'Prediction';
      case InsightType.encouragement:
        return 'Encouragement';
    }
  }
}

class _PriorityBadge extends StatelessWidget {

  const _PriorityBadge({required this.priority});
  final InsightPriority priority;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case InsightPriority.high:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        label = '🔥 High Priority';
        break;
      case InsightPriority.medium:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        label = '⭐ Medium';
        break;
      case InsightPriority.low:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        label = 'Low Priority';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
