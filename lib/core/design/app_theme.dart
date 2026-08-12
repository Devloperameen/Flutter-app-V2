import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/design/app_typography.dart';

/// SAFE Design System — Theme Configuration
///
/// Generates complete Material 3 themes from our design tokens.
/// Both light and dark themes are built from the same seed colors
/// ensuring visual consistency across modes.
abstract final class AppTheme {
  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static ThemeData getLight({Color? primary}) {
    final colorScheme = AppColors.getLightScheme(primary: primary);
    final textTheme = AppTypography.textTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,

      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            size: AppSpacing.iconMedium,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        height: AppSpacing.bottomNavHeight,
      ),

      // Chip
      chipTheme: ChipThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.sheetRadius),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
        ),
        elevation: 6,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
      ),

      // Page transitions
      // Using default transitions
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────

  static ThemeData getDark({Color? primary}) {
    final colorScheme = AppColors.getDarkScheme(primary: primary);
    final textTheme = AppTypography.textTheme(colorScheme);
    
    final lightTheme = getLight(primary: primary);

    // Start from the light theme and override for dark mode
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            size: AppSpacing.iconMedium,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        height: AppSpacing.bottomNavHeight,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.sheetRadius),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
        ),
        elevation: 6,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
