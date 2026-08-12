import 'package:flutter/material.dart';
import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';

enum AchievementType {
  sevenDayStreak,
  thirtyDayStreak,
  hundredHabits,
  thousandXp,
  fiftyFocusHours,
  maxDaily,
}

class AchievementBadge extends StatelessWidget { // 0-100 for locked achievements

  const AchievementBadge({
    super.key,
    required this.type,
    required this.unlockedDate,
    this.isLocked = false,
    this.progress = 0,
  });
  final AchievementType type;
  final DateTime unlockedDate;
  final bool isLocked;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isLocked
            ? theme.colorScheme.surfaceContainerLow
            : _getAchievementColor(theme),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked
              ? theme.colorScheme.outlineVariant
              : _getAchievementColor(theme).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Badge icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.transparent
                  : _getAchievementColor(theme).withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isLocked
                    ? theme.colorScheme.outlineVariant
                    : _getAchievementColor(theme).withValues(alpha: 0.5),
              ),
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _getAchievementEmoji(),
                  style: const TextStyle(fontSize: 32),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Title
          Text(
            _getAchievementTitle(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isLocked) ...[
            SizedBox(height: AppSpacing.sm),
            // Unlock date
            Text(
              _formatDate(unlockedDate),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ] else ...[
            SizedBox(height: AppSpacing.md),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 4,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  _getAchievementColor(theme),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            // Progress text
            Text(
              '${progress.toStringAsFixed(0)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getAchievementTitle() {
    switch (type) {
      case AchievementType.sevenDayStreak:
        return '7-Day Streak';
      case AchievementType.thirtyDayStreak:
        return '30-Day Streak';
      case AchievementType.hundredHabits:
        return '100 Habits';
      case AchievementType.thousandXp:
        return '1000 XP';
      case AchievementType.fiftyFocusHours:
        return '50 Focus Hours';
      case AchievementType.maxDaily:
        return 'Max Daily';
    }
  }

  String _getAchievementEmoji() {
    switch (type) {
      case AchievementType.sevenDayStreak:
        return '🔥';
      case AchievementType.thirtyDayStreak:
        return '💪';
      case AchievementType.hundredHabits:
        return '💯';
      case AchievementType.thousandXp:
        return '⭐';
      case AchievementType.fiftyFocusHours:
        return '🎯';
      case AchievementType.maxDaily:
        return '⚡';
    }
  }

  Color _getAchievementColor(ThemeData theme) {
    switch (type) {
      case AchievementType.sevenDayStreak:
      case AchievementType.thirtyDayStreak:
        return AppColors.streakActive;
      case AchievementType.hundredHabits:
        return AppColors.primarySeed;
      case AchievementType.thousandXp:
        return AppColors.moodExcited;
      case AchievementType.fiftyFocusHours:
        return AppColors.deepWorkFocus;
      case AchievementType.maxDaily:
        return AppColors.impactPositive;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Unlocked today';
    } else if (difference.inDays == 1) {
      return 'Unlocked yesterday';
    } else if (difference.inDays < 7) {
      return 'Unlocked ${difference.inDays} days ago';
    } else {
      return 'Unlocked ${date.month}/${date.day}/${date.year}';
    }
  }
}
