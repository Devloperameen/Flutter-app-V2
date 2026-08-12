import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated circular progress indicator
/// Perfect for showing daily goals, streaks, and achievements
class AnimatedProgressRing extends StatefulWidget {

  const AnimatedProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    required this.progressColor,
    required this.backgroundColor,
    this.centerLabel = '',
    this.labelStyle,
    this.animationDuration = const Duration(milliseconds: 800),
  });
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final String centerLabel;
  final TextStyle? labelStyle;
  final Duration animationDuration;

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: oldWidget.progress, end: widget.progress)
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ProgressRingPainter(
                  progress: 1,
                  color: widget.backgroundColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Progress ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ProgressRingPainter(
                  progress: _animation.value,
                  color: widget.progressColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.centerLabel.isNotEmpty)
                    Text(
                      '${(_animation.value * 100).toStringAsFixed(0)}%',
                      style: widget.labelStyle ??
                          theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                    ),
                  if (widget.centerLabel.isNotEmpty)
                    Text(
                      widget.centerLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(duration: 300.ms).scale(duration: 300.ms);
  }
}

/// Custom painter for progress ring
class _ProgressRingPainter extends CustomPainter {

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw arc from -90 degrees (top) to 270 degrees * progress
    const pi = 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (pi / 180), // Start at top
      (360 * progress) * (pi / 180),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
