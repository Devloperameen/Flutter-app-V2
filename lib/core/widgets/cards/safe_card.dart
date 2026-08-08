import 'package:flutter/material.dart';
import 'package:safe/core/design/design.dart';

class SafeCard extends StatelessWidget {
  const SafeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final widget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }
}
