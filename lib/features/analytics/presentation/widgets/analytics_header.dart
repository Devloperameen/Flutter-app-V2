import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/presentation/controllers/analytics_notifier.dart';

/// Header with period selector and category filter
class AnalyticsHeader extends ConsumerWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsNotifierProvider);
    final notifier = ref.read(analyticsNotifierProvider.notifier);

    return Column(
      children: [
        // Period selector tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PeriodTab(
                  label: 'Week',
                  isSelected: analyticsState.selectedPeriod.type == AnalyticsPeriodType.week,
                  onTap: () => notifier.setPeriod(AnalyticsPeriodType.week),
                ),
                const SizedBox(width: 8),
                _PeriodTab(
                  label: 'Month',
                  isSelected: analyticsState.selectedPeriod.type == AnalyticsPeriodType.month,
                  onTap: () => notifier.setPeriod(AnalyticsPeriodType.month),
                ),
                const SizedBox(width: 8),
                _PeriodTab(
                  label: 'All Time',
                  isSelected: analyticsState.selectedPeriod.type == AnalyticsPeriodType.allTime,
                  onTap: () => notifier.setPeriod(AnalyticsPeriodType.allTime),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Individual period tab widget
class _PeriodTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
