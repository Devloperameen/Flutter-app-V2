import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/app_spacing.dart';

/// Premium motivational header widget
/// Displays greeting, mission statement, and inspirational quote
class MotivationalHeader extends StatelessWidget {
  final String greeting;
  final String userName;
  final String? quote;
  final String? author;
  final Color? quoteBackgroundColor;

  const MotivationalHeader({
    super.key,
    required this.greeting,
    required this.userName,
    this.quote,
    this.author,
    this.quoteBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Hi, $userName 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Motivational Quote Card
        if (quote != null && quote!.isNotEmpty)
          _QuoteCard(
            quote: quote!,
            author: author,
            backgroundColor: quoteBackgroundColor,
          ),
      ],
    );
  }
}

/// Animatedquote card with gradient background
class _QuoteCard extends StatelessWidget {
  final String quote;
  final String? author;
  final Color? backgroundColor;

  const _QuoteCard({
    required this.quote,
    this.author,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (backgroundColor ?? colors.primaryContainer).withValues(alpha: 0.8),
            (backgroundColor ?? colors.primaryContainer).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          if (author != null && author!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— $author',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, duration: 700.ms);
  }
}
