/// SAFE Design System — Spacing Tokens
///
/// Based on a 4px grid system for pixel-perfect consistency.
/// Use these constants instead of hardcoded values throughout the app.
abstract final class AppSpacing {
  // ─────────────────────────────────────────────
  // Base Scale (4px grid)
  // ─────────────────────────────────────────────

  /// 4px — Minimal spacing (icon padding, tight gaps)
  static const double xxs = 4;

  /// 8px — Small spacing (between related items)
  static const double xs = 8;

  /// 12px — Compact spacing (form field gaps)
  static const double sm = 12;

  /// 16px — Standard spacing (default padding)
  static const double md = 16;

  /// 20px — Medium spacing (card internal padding)
  static const double lg = 20;

  /// 24px — Large spacing (section gaps)
  static const double xl = 24;

  /// 32px — Extra large (major section separation)
  static const double xxl = 32;

  /// 40px — Huge spacing (screen-level separation)
  static const double xxxl = 40;

  /// 48px — Maximum spacing (hero sections)
  static const double huge = 48;

  /// 64px — Extreme spacing (major visual breaks)
  static const double extreme = 64;

  /// 80px — Ultra spacing (splash/onboarding)
  static const double ultra = 80;

  // ─────────────────────────────────────────────
  // Semantic Spacing
  // ─────────────────────────────────────────────

  /// Screen horizontal padding
  static const double screenHorizontal = 20;

  /// Screen vertical padding
  static const double screenVertical = 24;

  /// Card internal padding
  static const double cardPadding = 16;

  /// Card border radius
  static const double cardRadius = 16;

  /// Button border radius
  static const double buttonRadius = 12;

  /// Input field border radius
  static const double inputRadius = 12;

  /// Bottom sheet border radius
  static const double sheetRadius = 24;

  /// Dialog border radius
  static const double dialogRadius = 28;

  /// Chip border radius
  static const double chipRadius = 8;

  /// Avatar sizes
  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 72;
  static const double avatarXLarge = 96;

  /// Icon sizes
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 80;

  /// App bar height
  static const double appBarHeight = 64;
}
