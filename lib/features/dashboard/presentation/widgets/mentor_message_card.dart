import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/design.dart';

/// AI Mentor message card with warm, personal feel
class MentorMessageCard extends StatelessWidget {

  const MentorMessageCard({
    super.key,
    required this.message,
    this.mentorName = 'Sadiq',
  });
  final String message;
  final String mentorName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mentor avatar and label
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    mentorName[0].toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentorName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Your AI Mentor',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Quote icon
          Icon(
            Icons.format_quote,
            size: 32,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // Message
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms);
  }
}
