import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/router/route_names.dart';
import 'package:safe/features/activity/presentation/screens/activity_feed_screen.dart';
import 'package:safe/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:safe/features/auth/presentation/screens/login_screen.dart' as safe_auth;
import 'package:safe/features/auth/presentation/screens/register_screen.dart';
import 'package:safe/features/community/presentation/screens/community_screen.dart';
import 'package:safe/features/content/presentation/screens/quote_screen.dart';
import 'package:safe/features/content/presentation/screens/video_screen.dart';
import 'package:safe/features/dashboard/presentation/screens/analytics_focus_combined_screen.dart';
import 'package:safe/features/dashboard/presentation/screens/dashboard_screen_simple.dart';
import 'package:safe/features/dashboard/presentation/screens/dashboard_shell.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/presentation/screens/edit_habit_screen.dart';
import 'package:safe/features/habits/presentation/screens/habit_calendar_screen.dart';
import 'package:safe/features/habits/presentation/screens/habits_screen.dart';
import 'package:safe/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:safe/features/profile/presentation/screens/profile_screen.dart';

part 'app_router.g.dart';

/// SAFE — Router Configuration
///
/// Declarative routing with GoRouter.
///
/// Architecture decisions:
/// 1. ShellRoute for persistent bottom navigation
/// 2. Redirect guards for authentication
/// 3. Named routes for type-safe navigation
/// 4. Nested navigation for tab-based flows
///
/// Auth guards implemented with Firebase Auth listener.
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final listenable = ValueNotifier<bool>(false);

  ref.listen(
    authNotifierProvider,
    (previous, next) {
      listenable.value = !listenable.value;
    },
  );

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      if (authState.isLoading) return null;

      final isAuth = authState.valueOrNull != null;
      final isSplash = state.uri.toString() == RoutePaths.splash;
      final isLoggingIn = state.uri.toString() == RoutePaths.login ||
          state.uri.toString() == RoutePaths.register ||
          state.uri.toString().startsWith(RoutePaths.forgotPassword);

      if (!isAuth && !isLoggingIn && !isSplash) {
        return RoutePaths.login;
      }

      if (isAuth && (isLoggingIn || isSplash)) {
        return RoutePaths.dashboard;
      }

      return null;
    },
    routes: [
      // ─────────────────────────────────────────
      // Splash Screen
      // ─────────────────────────────────────────
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
    
    // ─────────────────────────────────────────
    // Auth Flow
    // ─────────────────────────────────────────
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) => const safe_auth.LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.register,
      name: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      name: RouteNames.forgotPassword,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return ForgotPasswordScreen(initialEmail: email);
      },
    ),

    // ─────────────────────────────────────────
    // Main App Shell (Bottom Navigation)
    // ─────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardScreenSimple(),
        ),
        GoRoute(
          path: RoutePaths.habits,
          name: RouteNames.habits,
          builder: (context, state) => const HabitsScreen(),
          routes: [
            GoRoute(
              path: 'edit/:id',
              name: 'habitEdit',
              builder: (context, state) {
                final habitId = state.pathParameters['id']!;
                return EditHabitScreen(habitId: habitId);
              },
            ),
            GoRoute(
              path: 'calendar/:id',
              name: 'habitCalendar',
              builder: (context, state) {
                final habitId = state.pathParameters['id']!;
                // habit will be passed via extra
                final extra = state.extra as Map<String, dynamic>?;
                final habitData = extra?['habit'];
                if (habitData == null || habitData is! Habit) {
                  return const Scaffold(
                    body: Center(child: Text('Habit not found')),
                  );
                }
                return HabitCalendarScreen(
                  habitId: habitId,
                  habit: habitData,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.analyticsFocus,
          name: RouteNames.analyticsFocus,
          builder: (context, state) => const AnalyticsFocusCombinedScreen(),
        ),
        GoRoute(
          path: RoutePaths.activity,
          name: RouteNames.activity,
          builder: (context, state) => const ActivityFeedScreen(),
        ),
        GoRoute(
          path: RoutePaths.quotes,
          name: RouteNames.quotes,
          builder: (context, state) => const QuoteScreen(),
        ),
        GoRoute(
          path: RoutePaths.videos,
          name: RouteNames.videos,
          builder: (context, state) => const VideoScreen(),
        ),
        GoRoute(
          path: RoutePaths.community,
          name: RouteNames.community,
          builder: (context, state) => const CommunityScreen(),
        ),
        GoRoute(
          path: RoutePaths.profile,
          name: RouteNames.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // ─────────────────────────────────────────────────
    // Admin Dashboard (Outside Shell - Full Screen)
    // ─────────────────────────────────────────────────
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) {
        // ✅ FIXED: Add role-based access control
        final authNotifier = ref.read(authNotifierProvider);
        final user = authNotifier.valueOrNull;
        
        // Check if user is admin
        if (user == null || (user.role != 'admin' && user.role != 'super_admin')) {
          // Not admin - redirect to home with error
          Future.microtask(() {
            if (context.mounted) {
              context.goNamed('home');
            }
          });
          return const Scaffold(
            body: Center(child: Text('Access Denied')),
          );
        }
        
        return const AdminDashboardScreen();
      },
    ),
  ],
  );
}
