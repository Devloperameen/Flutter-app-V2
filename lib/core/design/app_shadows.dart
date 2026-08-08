import 'package:flutter/material.dart';

/// SAFE Design System — Shadow Tokens
///
/// Elevation system using soft, diffuse shadows for a premium feel.
/// Avoid harsh drop shadows — SAFE should feel modern and elegant.
abstract final class AppShadows {
  // ─────────────────────────────────────────────
  // Light Mode Shadows
  // ─────────────────────────────────────────────

  /// Subtle shadow for cards and surfaces (elevation 1)
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Medium shadow for elevated cards (elevation 2)
  static List<BoxShadow> get md => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Large shadow for modals and floating elements (elevation 3)
  static List<BoxShadow> get lg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Extra large shadow for navigation bars and overlays (elevation 4)
  static List<BoxShadow> get xl => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ─────────────────────────────────────────────
  // Colored Shadows (for branded elements)
  // ─────────────────────────────────────────────

  /// Primary colored glow shadow
  static List<BoxShadow> primaryGlow(Color primaryColor) => [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Accent colored glow shadow
  static List<BoxShadow> accentGlow(Color accentColor) => [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}
