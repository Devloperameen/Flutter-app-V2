import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/dashboard/domain/models/productivity_tip.dart';

/// Swipeable productivity tip card that auto-rotates
class ProductivityTipCard extends StatefulWidget {
  final List<ProductivityTip> tips;
  final VoidCallback? onNext;

  const ProductivityTipCard({
    super.key,
    required this.tips,
    this.onNext,
  });

  @override
  State<ProductivityTipCard> createState() => _ProductivityTipCardState();
}

class _ProductivityTipCardState extends State<ProductivityTipCard> {
  int _currentIndex = 0;
  bool _isHovering = false;

  void _nextTip() {
    if (!mounted || widget.tips.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.tips.length;
    });
    if (widget.onNext != null) {
      widget.onNext!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tips.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final tip = widget.tips[_currentIndex];

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < -10) {
          _nextTip();
        } else if (details.delta.dx > 10) {
          setState(() {
            _currentIndex = (_currentIndex - 1 + widget.tips.length) % widget.tips.length;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.tertiaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            key: ValueKey<int>(_currentIndex),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and category
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                    ),
                    child: Text(
                      tip.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                    ),
                    child: Text(
                      tip.category.toUpperCase().replaceAll('_', ' '),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Title
              Text(
                tip.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Content
              Text(
                tip.content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Actions
              Row(
                children: [
                  // Likes
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${tip.likes}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Next tip button
                  TextButton.icon(
                    onPressed: _nextTip,
                    icon: const Text('Next Tip'),
                    label: const Icon(Icons.arrow_forward_rounded, size: 18),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onTertiaryContainer,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
