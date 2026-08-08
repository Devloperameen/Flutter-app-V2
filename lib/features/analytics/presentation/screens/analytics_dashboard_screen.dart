import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';
import 'package:safe/features/analytics/presentation/notifiers/analytics_notifier.dart';
import 'package:safe/features/analytics/presentation/widgets/analytics_header.dart';
import 'package:safe/features/analytics/presentation/widgets/empty_state_widget.dart';
import 'package:safe/features/analytics/presentation/widgets/habit_metrics_widget.dart';
import 'package:safe/features/analytics/presentation/widgets/focus_metrics_widget.dart';
import 'package:safe/features/analytics/presentation/widgets/streaks_widget.dart';
import 'package:safe/features/analytics/presentation/widgets/personal_records_widget.dart';
import 'package:safe/features/analytics/presentation/widgets/insights_card.dart';
import 'package:safe/features/analytics/presentation/widgets/analytics_chart_widget.dart';

/// Main analytics dashboard screen
class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final notifier = ref.read(analyticsNotifierProvider.notifier);
          await notifier.refresh();
        },
        child: CustomScrollView(
          slivers: [
            // Header with offline indicator
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (analyticsState.isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.orange.shade100,
                      child: Text(
                        'Offline - Showing cached data',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orange.shade900,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const AnalyticsHeader(),
                ],
              ),
            ),

            // Main content
            if (analyticsState.isLoading)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (analyticsState.error != null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading analytics',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        analyticsState.error ?? 'Unknown error',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else if (analyticsState.data == null ||
                (analyticsState.data!.habitAnalytics.totalHabits == 0 &&
                    analyticsState.data!.focusAnalytics.totalSessions == 0))
              SliverFillRemaining(
                child: AnalyticsEmptyStateWidget(
                  period: analyticsState.selectedPeriod,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),

                    // Habit Metrics
                    HabitMetricsWidget(
                      habitAnalytics: analyticsState.data!.habitAnalytics,
                    ),
                    const SizedBox(height: 16),

                    // Focus Metrics
                    FocusMetricsWidget(
                      focusAnalytics: analyticsState.data!.focusAnalytics,
                    ),
                    const SizedBox(height: 16),

                    // Charts
                    AnalyticsChartWidget(
                      habitAnalytics: analyticsState.data!.habitAnalytics,
                      focusAnalytics: analyticsState.data!.focusAnalytics,
                      period: analyticsState.selectedPeriod,
                    ),
                    const SizedBox(height: 16),

                    // Streaks
                    StreaksWidget(
                      habitAnalytics: analyticsState.data!.habitAnalytics,
                    ),
                    const SizedBox(height: 16),

                    // Personal Records
                    PersonalRecordsWidget(
                      personalRecords: analyticsState.data!.personalRecords,
                    ),
                    const SizedBox(height: 16),

                    // Insights
                    if (analyticsState.data!.insights.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Insights',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...analyticsState.data!.insights.map(
                            (insight) => InsightsCard(insight: insight),
                          ),
                        ],
                      ),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
