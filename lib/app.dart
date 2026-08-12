import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe/core/constants/app_constants.dart';
import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_theme.dart';
import 'package:safe/core/providers/theme_provider.dart';
import 'package:safe/core/router/app_router.dart';

/// SAFE — Root Application Widget
///
/// Configures:
/// - Material 3 theming (light + dark)
/// - Dynamic color switching via Riverpod
/// - GoRouter navigation
/// - Global app configuration
class SafeApp extends ConsumerWidget {
  const SafeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    final primaryColor = themeState.useBlueTheme
        ? AppColors.primarySeed
        : AppColors.secondarySeed;

    return MaterialApp.router(
      // ─── Identity ───
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // ─── Theme ───
      theme: AppTheme.getLight(primary: primaryColor),
      darkTheme: AppTheme.getDark(primary: primaryColor),
      themeMode: themeState.themeMode,

      // ─── Navigation ───
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}


