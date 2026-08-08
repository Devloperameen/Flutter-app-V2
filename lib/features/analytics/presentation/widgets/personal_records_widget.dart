import 'package:flutter/material.dart';
import 'package:safe/features/analytics/domain/models/personal_records.dart';
import 'package:intl/intl.dart';

/// Widget displaying personal records and achievements
class PersonalRecordsWidget extends StatelessWidget {
  final PersonalRecords personalRecords;

  const PersonalRecordsWidget({
    Key? key,
    required this.personalRecords,
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
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Personal Records',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Records grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _RecordCard(
                  title: 'Max Daily Habits',
                  value: personalRecords.maxDailyHabits.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                  date: personalRecords.maxDailyHabitsDate,
                ),
                _RecordCard(
                  title: 'Max Daily XP',
                  value: personalRecords.maxDailyXp.toString(),
                  icon: Icons.star,
                  color: Colors.amber,
                  date: personalRecords.maxDailyXpDate,
                ),
                _RecordCard(
                  title: 'Max Focus Minutes',
                  value: personalRecords.maxDailyFocusMinutes.toString(),
                  icon: Icons.schedule,
                  color: Colors.blue,
                  date: personalRecords.maxDailyFocusMinutesDate,
                ),
                _RecordCard(
                  title: 'Longest Streak',
                  value: personalRecords.longestOverallStreak.toString(),
                  icon: Icons.local_fire_department,
                  color: Colors.red,
                  date: personalRecords.longestOverallStreakEndDate,
                ),
              ],
            ),
            // Achievements section
            const SizedBox(height: 16),
            _buildAchievementsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final achievements = <({String title, bool unlocked})>[
      (title: '7-Day Streak', unlocked: personalRecords.longestOverallStreak >= 7),
      (title: '30-Day Streak', unlocked: personalRecords.longestOverallStreak >= 30),
      (title: 'Century', unlocked: personalRecords.maxDailyHabits >= 100),
      (title: 'Focus Master', unlocked: personalRecords.maxDailyFocusMinutes >= 180),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: achievements.map((achievement) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? Colors.amber.shade50
                    : Colors.grey.shade100,
                border: Border.all(
                  color: achievement.unlocked
                      ? Colors.amber.shade300
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (achievement.unlocked)
                    const Icon(Icons.check_circle, size: 16, color: Colors.amber),
                  if (!achievement.unlocked)
                    const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    achievement.title,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: achievement.unlocked
                              ? Colors.amber.shade900
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final DateTime? date;

  const _RecordCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('MMM d').format(date!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
