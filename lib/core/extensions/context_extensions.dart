import 'package:flutter/material.dart';

/// Extensions on [BuildContext] for convenient access to theme data.
///
/// Usage:
/// ```dart
/// Text('Hello', style: context.titleLarge);
/// Container(color: context.colorScheme.primary);
/// ```
extension BuildContextExtensions on BuildContext {
  // ─────────────────────────────────────────────
  // Theme Access
  // ─────────────────────────────────────────────

  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // ─────────────────────────────────────────────
  // Typography Shortcuts
  // ─────────────────────────────────────────────

  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  // ─────────────────────────────────────────────
  // Media Query Shortcuts
  // ─────────────────────────────────────────────

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get bottomInset => viewInsets.bottom;
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  // ─────────────────────────────────────────────
  // Responsive Breakpoints
  // ─────────────────────────────────────────────

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // ─────────────────────────────────────────────
  // Navigation Shortcuts
  // ─────────────────────────────────────────────

  NavigatorState get navigator => Navigator.of(this);

  void pop<T>([T? result]) => navigator.pop(result);

  // ─────────────────────────────────────────────
  // Snackbar / Feedback
  // ─────────────────────────────────────────────

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
  }

  void showErrorSnackBar(String message) {
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colorScheme.error,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  void showSuccessSnackBar(String message) {
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: colorScheme.onPrimary),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: colorScheme.primary,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ─────────────────────────────────────────────
  // Focus
  // ─────────────────────────────────────────────

  /// Dismiss the keyboard
  void unfocus() => FocusScope.of(this).unfocus();
}
