import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:safe/features/activity/domain/models/activity.dart';
import 'package:safe/features/activity/presentation/providers/activity_providers.dart';

/// Activity Feed Screen
/// Shows user's activity history with filtering and achievements
class ActivityFeedScreen extends ConsumerWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedActivityTypeProvider);
    final activities = ref.watch(filteredActivityFeedProvider);
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Activity type filter
          _buildFilterChips(context, ref, selectedType),
          const Divider(height: 1),

          // Activity list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(filteredActivityFeedProvider);
                ref.refresh(achievementsProvider);
              },
              child: activities.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $err'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.refresh(filteredActivityFeedProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (activityList) {
                  if (activityList.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    itemCount: activityList.length + 1, // +1 for achievements card
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Show achievements at the top
                        return achievements.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (achievementList) => _buildAchievementsCard(
                            context,
                            achievementList,
                          ),
                        );
                      }

                      final activity = Activity.fromJson(activityList[index - 1]);
                      return _buildActivityCard(context, ref, activity);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    WidgetRef ref,
    String selectedType,
  ) {
    final filters = [
      ('all', 'All'),
      ('habit-completion', 'Habits'),
      ('focus-completed', 'Focus'),
      ('streak-milestone', 'Streaks'),
      ('level-up', 'Level Ups'),
      ('achievement-unlocked', 'Achievements'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final value = filter.$1;
          final label = filter.$2;
          final isSelected = value == selectedType;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedActivityTypeProvider.notifier).state = value;
                ref.read(activityFeedPageProvider.notifier).state = 1; // Reset page
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievementsCard(
    BuildContext context,
    List<Map<String, dynamic>> achievementList,
  ) {
    final unlockedCount = achievementList.where((a) => a['unlocked'] == true).length;
    final totalCount = achievementList.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '🏆 Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$unlockedCount/$totalCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: achievementList.take(6).map((achievementJson) {
                final achievement = Achievement.fromJson(achievementJson);
                return _buildAchievementBadge(achievement);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(Achievement achievement) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: achievement.unlocked
                  ? Colors.amber.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              border: Border.all(
                color: achievement.unlocked ? Colors.amber : Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 24,
                  color: achievement.unlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.name,
            style: TextStyle(
              fontSize: 10,
              color: achievement.unlocked ? Colors.black87 : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) {
    final dateStr = _formatDate(activity.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getActivityColor(activity.type).withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  activity.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (activity.xpEarned > 0) ...[
                        Text(
                          '+${activity.xpEarned} XP',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•'),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Share button (if not shared)
            if (!activity.shared)
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                onPressed: () => _handleShareActivity(context, ref, activity),
                tooltip: 'Share',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.filter_list_off,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Activities Yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete habits and focus sessions to see your activity here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'habit-completion':
        return Colors.blue;
      case 'focus-completed':
        return Colors.purple;
      case 'streak-milestone':
        return Colors.red;
      case 'level-up':
        return Colors.amber;
      case 'achievement-unlocked':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleShareActivity(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    try {
      await ref.read(shareActivityProvider(activity.id).future);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Activity shared to community!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
