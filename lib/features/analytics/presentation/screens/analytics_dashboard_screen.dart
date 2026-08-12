import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/analytics/domain/models/analytics_models.dart';
import 'package:safe/features/analytics/presentation/providers/analytics_providers.dart';

/// Analytics Dashboard Screen
/// Shows comprehensive analytics with period selector
/// Displays habits, focus sessions, XP progression, insights
class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final dashboard = ref.watch(dashboardDataProvider);
    final userRank = ref.watch(userRankProvider);
    final insights = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(dashboardDataProvider);
          ref.refresh(userRankProvider);
          ref.refresh(insightsProvider);
        },
        child: ListView(
          children: [
            // Period selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildPeriodSelector(context, ref, selectedPeriod),
            ),

            // Dashboard content
            dashboard.when(
              loading: () => const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $err'),
                ),
              ),
              data: (data) {
                final analyticsData = AnalyticsData.fromJson(data);
                return Column(
                  children: [
                    // Summary cards
                    _buildSummaryCards(context, analyticsData),
                    const SizedBox(height: 24),

                    // Habit completion
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildHabitCard(analyticsData.habits),
                    ),
                    const SizedBox(height: 16),

                    // Focus sessions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildFocusCard(analyticsData.focus),
                    ),
                    const SizedBox(height: 16),

                    // Streaks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStreakCard(analyticsData.streaks),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),

            // User rank section
            userRank.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (rank) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildRankCard(context, rank),
              ),
            ),
            const SizedBox(height: 24),

            // Insights section
            if (insights.hasValue) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Insights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              ...insights.value!.asMap().entries.map((entry) {
                final insight = Insight.fromJson(entry.value);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildInsightCard(context, insight),
                );
              }),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(
    BuildContext context,
    WidgetRef ref,
    String selectedPeriod,
  ) {
    final periods = ['today', 'week', 'month', 'all-time'];
    final labels = ['Today', 'Week', 'Month', 'All Time'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...periods.asMap().entries.map((entry) {
            final index = entry.key;
            final period = entry.value;
            final label = labels[index];
            final isSelected = period == selectedPeriod;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(selectedPeriodProvider.notifier).state = period;
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, AnalyticsData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Habits',
                  '${data.habits.percentage}%',
                  '${data.habits.completed}/${data.habits.total}',
                  Colors.blue,
                  '🎯',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Focus',
                  '${data.focus.totalMinutes}min',
                  '${data.focus.sessions} sessions',
                  Colors.purple,
                  '⏱️',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'XP Gained',
                  '${data.xpGained}',
                  'This ${data.period}',
                  Colors.orange,
                  '⭐',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Streak',
                  '${data.streaks.current}',
                  'days 🔥',
                  Colors.red,
                  '🎯',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    String icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$title\n$subtitle',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(HabitStats habits) {
    final percentage = habits.percentage;
    final color = percentage >= 80 ? Colors.green : percentage >= 50 ? Colors.orange : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Habit Completion',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: habits.percentage / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${habits.percentage}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${habits.completed}/${habits.total} habits completed',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusCard(FocusStats focus) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⏱️ Focus Sessions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFocusStatItem(
                'Sessions',
                '${focus.sessions}',
                '📊',
              ),
              _buildFocusStatItem(
                'Total Time',
                '${focus.totalMinutes}min',
                '⏱️',
              ),
              _buildFocusStatItem(
                'Average',
                '${focus.averageDuration}min',
                '📈',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFocusStatItem(String label, String value, String icon) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(StreakData streaks) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔥 Streaks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Streak'),
                    Text(
                      '${streaks.current} days',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Longest Streak'),
                    Text(
                      '${streaks.longest} days',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard(BuildContext context, UserRank rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏆 Your Rank',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${rank.rank}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'out of ${rank.totalUsers}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Level ${rank.level}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rank.percentile}th percentile',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, Insight insight) {
    final colors = {
      'high': Colors.red,
      'medium': Colors.orange,
      'low': Colors.blue,
    };
    final color = colors[insight.priority] ?? Colors.blue;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(insight.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
