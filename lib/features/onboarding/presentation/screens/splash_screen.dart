import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:safe/core/constants/app_constants.dart';
import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/router/route_names.dart';

/// SAFE — Splash Screen
///
/// First screen the user sees. Performs initialization and then
/// navigates to either onboarding, login, or dashboard based on
/// the user's state.
///
/// Current behavior (Step 1):
/// - Show animated logo + tagline
/// - Navigate to dashboard after 2.5 seconds
///
/// Future behavior (Step 5):
/// - Check auth state
/// - Check onboarding state
/// - Route accordingly
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    // Navigate to login - auth provider will handle redirects once initialized
    context.goNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkSurfaceGradient
              : LinearGradient(
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Logo Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primarySeed.withValues(alpha: 0.3),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.xxl),

                // App Name
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                    letterSpacing: 8,
                  ),
                )
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),

                const SizedBox(height: AppSpacing.sm),

                // Tagline
                Text(
                  AppConstants.appTagline,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),

                const Spacer(flex: 3),

                // Loading indicator
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ).animate(delay: 800.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.md),

                // Mission text
                Text(
                  AppConstants.mission,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontStyle: FontStyle.italic,
                  ),
                )
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: AppSpacing.huge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
