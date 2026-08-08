import 'package:flutter/material.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/core/widgets/cards/safe_card.dart';

class SafeStatCard extends StatelessWidget {
  const SafeStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.showIconBackground = false,
    this.valueStyle,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final bool showIconBackground;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget iconWidget = Icon(icon, color: iconColor, size: AppSpacing.iconMedium);

    if (showIconBackground) {
      iconWidget = Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
        child: iconWidget,
      );
    }

    return SafeCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          SizedBox(height: showIconBackground ? AppSpacing.md : AppSpacing.sm),
          Text(
            value,
            style: valueStyle ?? theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
