import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';

/// Widget displayed when there is no analytics data
class AnalyticsEmptyStateWidget extends StatelessWidget {

  const AnalyticsEmptyStateWidget({
    super.key,
    required this.period,
  });
  final AnalyticsPeriod period;

  @override
  Widget build(BuildContext context) {
    final periodLabel = period.type.label.toLowerCase();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 48,
                    color: Colors.blue.shade300,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'Start Your Journey',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                'No habit data for this $periodLabel yet.\n'
                'Create your first habit to see your progress appear here! 🚀',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Focus sessions info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Focus Sessions',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No focus sessions completed yet.\n'
                      'Complete your first focus session to earn XP and see your productivity insights! 💪',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.amber.shade800,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Tips section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Quick Tips',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade900,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _TipItem(
                      number: '1',
                      title: 'Create Habits',
                      description:
                          'Start with small, achievable habits like a 10-minute walk or 5-minute meditation.',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      number: '2',
                      title: 'Use Focus Timer',
                      description:
                          'Use the focus timer for deep work sessions to boost productivity and earn XP.',
                    ),
                    const SizedBox(height: 8),
                    _TipItem(
                      number: '3',
                      title: 'Build Streaks',
                      description:
                          'Consistency is key. Check off your habits daily to build impressive streaks.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {

  const _TipItem({
    required this.number,
    required this.title,
    required this.description,
  });
  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade900,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade900,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.green.shade700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
