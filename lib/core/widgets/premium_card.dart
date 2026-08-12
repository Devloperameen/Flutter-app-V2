import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safe/core/design/app_spacing.dart';

/// Premium card widget with glassmorphism and animations
/// Inspired by Apple, Notion, and Linear design systems
class PremiumCard extends StatefulWidget {

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius = 16,
    this.showShadow = true,
    this.useGlassmorphism = false,
    this.backgroundColor,
    this.border,
    this.gradient,
    this.animationDuration = const Duration(milliseconds: 300),
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double borderRadius;
  final bool showShadow;
  final bool useGlassmorphism;
  final Color? backgroundColor;
  final Border? border;
  final LinearGradient? gradient;
  final Duration animationDuration;

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent event) {
    if (widget.onTap != null) {
      _hoverController.forward();
      setState(() => _isHovering = true);
    }
  }

  void _onExit(PointerEvent event) {
    _hoverController.reverse();
    setState(() => _isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_hoverController.value * 4),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? colors.surfaceContainerLow,
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.border,
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: colors.onSurface.withValues(alpha: 0.08),
                        blurRadius: 12 + (_isHovering ? 8 : 0),
                        offset: Offset(0, 4 + (_isHovering ? 2 : 0)),
                      ),
                      if (_isHovering)
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: widget.useGlassmorphism
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: widget.padding,
                        child: widget.child,
                      ),
                    )
                  : Padding(
                      padding: widget.padding,
                      child: widget.child,
                    ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, duration: 300.ms);
  }
}
