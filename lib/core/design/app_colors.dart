import 'package:flutter/material.dart';

/// SAFE Design System — Premium Color Tokens
///
/// Inspired by Apple, Google Material 3, Linear, Notion, Duolingo, and Headspace.
/// A sophisticated palette representing hope, discipline, growth, and transformation.
/// The color system uses Material 3 seed-based generation with semantic tokens
/// for the app's unique needs and emotional engagement.
abstract final class AppColors {
  // ─────────────────────────────────────────────
  // Brand Colors — Premium Palette
  // ─────────────────────────────────────────────

  /// Primary Brand Color — Sky Blue
  /// Represents clarity, focus, hope, and upward growth
  static const Color primarySeed = Color(0xFF03A9F4); // Sky Blue

  /// Secondary Brand Color — Deep Brown
  /// Represents stability, earth, foundation, and discipline
  static const Color secondarySeed = Color(0xFF795548); // Earth Brown

  /// Tertiary Brand Color — Trust Blue
  /// Represents trust, knowledge, and wisdom
  static const Color tertiarySeed = Color(0xFF1565C0); // Trust Deep Blue

  // ─────────────────────────────────────────────
  // Premium Neutral & Support Colors
  // ─────────────────────────────────────────────

  /// Premium Black - Deep Surface
  static const Color premiumBlack = Color(0xFF0F0F0F);

  /// Premium Dark Gray - Elevated Surface
  static const Color premiumDarkGray = Color(0xFF1A1A1A);

  /// Premium Charcoal - Secondary Surface
  static const Color premiumCharcoal = Color(0xFF2A2A2A);

  /// Premium Gray - Subtle Element
  static const Color premiumGray = Color(0xFF757575);

  /// Premium Light Gray - Dividers & Borders
  static const Color premiumLightGray = Color(0xFFE0E0E0);

  /// Premium Off-White - Soft Surface
  static const Color premiumOffWhite = Color(0xFFFAFAFA);

  // ─────────────────────────────────────────────
  // Energy Level Colors (Semantic)
  // ─────────────────────────────────────────────

  static const Color energyLow = Color(0xFFE53935);      // Warm Red
  static const Color energyMedium = Color(0xFFFFA726);   // Warm Orange
  static const Color energyHigh = Color(0xFF66BB6A);     // Fresh Green
  static const Color energyFull = Color(0xFF2E7D32);     // Deep Green

  // ─────────────────────────────────────────────
  // Streak & Motivation Colors
  // ─────────────────────────────────────────────

  static const Color streakActive = Color(0xFFFF6F00);   // Flame Orange
  static const Color streakInactive = Color(0xFFBDBDBD); // Cool Gray
  static const Color streakGold = Color(0xFFFFD700);     // Achievement Gold

  // ─────────────────────────────────────────────
  // Deep Work & Focus Colors
  // ─────────────────────────────────────────────

  static const Color deepWorkFocus = Color(0xFF1565C0);  // Deep Focus Blue
  static const Color deepWorkBreak = Color(0xFF66BB6A);  // Rest Green
  static const Color deepWorkPaused = Color(0xFFFFA726); // Pause Orange

  // ─────────────────────────────────────────────
  // Impact & Achievement Colors
  // ─────────────────────────────────────────────

  static const Color impactPositive = Color(0xFF2E7D32); // Success Green
  static const Color impactNeutral = Color(0xFF757575);  // Neutral Gray
  static const Color impactWarning = Color(0xFFFF9800);  // Warning Amber

  // ─────────────────────────────────────────────
  // Rank & Progression Colors (Status Badges)
  // ─────────────────────────────────────────────

  static const Color rankExplorer = Color(0xFF78909C);    // Blue Grey - Beginning
  static const Color rankBuilder = Color(0xFF42A5F5);     // Blue - Progress
  static const Color rankAchiever = Color(0xFF66BB6A);    // Green - Strong
  static const Color rankLeader = Color(0xFFFFA726);      // Orange - Leading
  static const Color rankMentor = Color(0xFFAB47BC);      // Purple - Teaching
  static const Color rankVisionary = Color(0xFFEF5350);   // Red - Inspiring
  static const Color rankLegacy = Color(0xFFFFD700);      // Gold - Ultimate

  // ─────────────────────────────────────────────
  // Mood & Emotion Colors
  // ─────────────────────────────────────────────

  static const Color moodExcited = Color(0xFFFFD700);    // Gold
  static const Color moodHappy = Color(0xFF66BB6A);      // Green
  static const Color moodContent = Color(0xFF42A5F5);    // Blue
  static const Color moodFocused = Color(0xFF1565C0);    // Deep Blue
  static const Color moodCalm = Color(0xFFAB47BC);       // Purple
  static const Color moodSad = Color(0xFF64B5F6);        // Light Blue
  static const Color moodFrustrated = Color(0xFFE53935); // Red
  static const Color moodTired = Color(0xFF757575);      // Gray

  // ─────────────────────────────────────────────
  // Interactive & Feedback Colors
  // ─────────────────────────────────────────────

  static const Color successGreen = Color(0xFF4CAF50);   // Success Action
  static const Color errorRed = Color(0xFFf44336);       // Error State
  static const Color warningAmber = Color(0xFFFFC107);   // Warning State
  static const Color infoBlue = Color(0xFF2196F3);       // Info State

  // ─────────────────────────────────────────────
  // Glassmorphism & Transparency
  // ─────────────────────────────────────────────

  static const Color glassLight = Color(0xFFFFFFFF);     // For light mode
  static const Color glassDark = Color(0xFF1A1A1A);      // For dark mode

  // ─────────────────────────────────────────────
  // Gradient Presets — Premium Design
  // ─────────────────────────────────────────────

  /// Primary gradient - represents hope and upward growth
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF03A9F4), Color(0xFF0288D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium success gradient - celebration and achievement
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Energy gradient - motivation and vitality
  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFFFF6F00), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Deep work gradient - focus and concentration
  static const LinearGradient deepWorkGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Calm gradient - peace and reflection
  static const LinearGradient calmGradient = LinearGradient(
    colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark surface gradient - depth and sophistication
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Premium gradient - luxury and achievement
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Radial gradient - focus point attention
  static RadialGradient focusRadialGradient(Color color) {
    return RadialGradient(
      colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.05)],
      radius: 1.5,
    );
  }

  // ─────────────────────────────────────────────
  // Color Scheme Generators — Material 3
  // ─────────────────────────────────────────────

  /// Generate the light color scheme from seed colors.
  /// Optimized for readability and premium feel.
  static ColorScheme getLightScheme({Color? primary}) {
    return ColorScheme.fromSeed(
      seedColor: primary ?? primarySeed,
      secondary: secondarySeed,
      tertiary: tertiarySeed,
      brightness: Brightness.light,
      surface: premiumOffWhite,
    );
  }

  /// Generate the dark color scheme from seed colors.
  /// Optimized for reduced eye strain and premium feel.
  static ColorScheme getDarkScheme({Color? primary}) {
    return ColorScheme.fromSeed(
      seedColor: primary ?? primarySeed,
      secondary: secondarySeed,
      tertiary: tertiarySeed,
      brightness: Brightness.dark,
      surface: premiumBlack,
    );
  }
}

