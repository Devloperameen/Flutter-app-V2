import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/dashboard/domain/models/daily_challenge.dart';

/// Daily challenges horizontal cards
class DailyChallengeCards extends StatelessWidget {

  const DailyChallengeCards({
    super.key,
    required this.challenges,
  });
  final List<DailyChallenge> challenges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Text(
            'Daily Challenges',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: AppSpacing.sm),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Text(
            'Complete challenges to earn XP and level up',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ).animate(delay: 50.ms).fadeIn(),
        
        const SizedBox(height: AppSpacing.md),
        
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < challenges.length - 1 ? AppSpacing.md : 0,
                ),
                child: _ChallengeCard(challenge: challenges[index])
                    .animate(delay: (100 + index * 50).ms)
                    .fadeIn()
                    .slideX(begin: 0.1, end: 0),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {

  const _ChallengeCard({required this.challenge});
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = challenge.targetValue > 0
        ? (challenge.currentValue / challenge.targetValue).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: challenge.isCompleted
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: challenge.isCompleted
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: challenge.isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and XP reward
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: challenge.isCompleted
                      ? Colors.white.withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                ),
                child: Text(
                  challenge.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                ),
                child: Text(
                  '+${challenge.xpReward} XP',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Title
          Text(
            challenge.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: challenge.isCompleted
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const Spacer(),
          
          // Progress bar
          if (!challenge.isCompleted) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${challenge.currentValue}/${challenge.targetValue}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ] else
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Completed!',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
