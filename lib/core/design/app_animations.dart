/// SAFE Design System — Animation Tokens
///
/// Consistent animation durations and curves throughout the app.
/// Fast enough to feel responsive, slow enough to be perceived.
abstract final class AppAnimations {
  // ─────────────────────────────────────────────
  // Durations
  // ─────────────────────────────────────────────

  /// 150ms — Micro-interactions (button press, icon change)
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms — Standard transitions (fade, color change)
  static const Duration normal = Duration(milliseconds: 250);

  /// 350ms — Medium transitions (slide, expand)
  static const Duration medium = Duration(milliseconds: 350);

  /// 500ms — Slow transitions (page transition, complex animation)
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms — Dramatic transitions (onboarding, celebration)
  static const Duration dramatic = Duration(milliseconds: 800);

  /// 1200ms — Extended animations (splash, loading reveal)
  static const Duration extended = Duration(milliseconds: 1200);

  // ─────────────────────────────────────────────
  // Stagger Delays
  // ─────────────────────────────────────────────

  /// Delay between staggered list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Delay for sequential card animations
  static const Duration cardStagger = Duration(milliseconds: 80);
}
