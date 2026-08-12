import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/features/habits/domain/models/habit.dart';

/// Reusable habit card widget
class HabitCard extends StatelessWidget {

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
    this.onViewHistory,
  });
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final VoidCallback? onViewHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: habit.completedToday
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: habit.completedToday ? 2 : 1,
          ),
          boxShadow: [
            if (habit.completedToday)
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: checkbox, emoji, title, menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion checkbox
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: habit.completedToday
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: habit.completedToday
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: habit.completedToday
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
                SizedBox(width: AppSpacing.md),

                // Emoji and title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            habit.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              habit.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: habit.completedToday
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: habit.completedToday
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (habit.description != null &&
                          habit.description!.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          habit.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Menu button
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    } else if (value == 'archive') {
                      onArchive();
                    } else if (value == 'history') {
                      onViewHistory?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: AppSpacing.sm),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'history',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined),
                          SizedBox(width: AppSpacing.sm),
                          Text('History'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'archive',
                      child: Row(
                        children: [
                          Icon(Icons.archive_outlined),
                          SizedBox(width: AppSpacing.sm),
                          Text('Archive'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline),
                          SizedBox(width: AppSpacing.sm),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),

            // Category, streaks, reminder
            Row(
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: Text(
                    habit.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),

                // Current streak
                if (habit.currentStreak > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 12,
                          color: Color(0xFFFF6B6B),
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Text(
                          '${habit.currentStreak}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFFF6B6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                ],

                // Reminder time if set
                if (habit.reminderEnabled && habit.reminderTime != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Text(
                          habit.reminderTime!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Spacer(),

                // Completion percentage
                Text(
                  '${habit.totalCompletions > 0 ? ((habit.totalCompletions / 365) * 100).toStringAsFixed(0) : 0}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}
