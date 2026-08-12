import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/app_spacing.dart';

/// Premium animated button with multiple styles
/// Inspired by Linear, Notion, and Apple's design philosophy
enum PremiumButtonStyle { primary, secondary, tertiary, danger }

class PremiumButton extends StatefulWidget {

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = PremiumButtonStyle.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 52,
    this.isFullWidth = false,
  });
  final String label;
  final VoidCallback onPressed;
  final PremiumButtonStyle style;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double height;
  final bool isFullWidth;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!widget.isLoading) {
      _pressController.forward();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _pressController.reverse();
  }

  Color _getBackgroundColor(ColorScheme colors) {
    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return colors.primary;
      case PremiumButtonStyle.secondary:
        return colors.primaryContainer;
      case PremiumButtonStyle.tertiary:
        return colors.surfaceContainerHighest;
      case PremiumButtonStyle.danger:
        return const Color(0xFFE53935);
    }
  }

  Color _getForegroundColor(ColorScheme colors) {
    switch (widget.style) {
      case PremiumButtonStyle.primary:
        return colors.onPrimary;
      case PremiumButtonStyle.secondary:
        return colors.onPrimaryContainer;
      case PremiumButtonStyle.tertiary:
        return colors.onSurface;
      case PremiumButtonStyle.danger:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final backgroundColor = _getBackgroundColor(colors);
    final foregroundColor = _getForegroundColor(colors);

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 - (_pressController.value * 0.02),
            child: Opacity(
              opacity: 1 - (_pressController.value * 0.1),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: widget.isLoading ? null : widget.onPressed,
          child: Container(
            width: widget.isFullWidth ? double.infinity : widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (widget.style == PremiumButtonStyle.primary)
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onPressed,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(foregroundColor),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.leadingIcon != null) ...[
                              widget.leadingIcon!,
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Text(
                              widget.label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: foregroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.trailingIcon != null) ...[
                              const SizedBox(width: AppSpacing.sm),
                              widget.trailingIcon!,
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, duration: 300.ms);
  }
}
