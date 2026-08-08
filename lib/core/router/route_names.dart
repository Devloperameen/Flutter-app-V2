/// SAFE — Route Names & Paths
///
/// Centralized route definitions prevent typos and enable
/// type-safe navigation throughout the app.

/// Named routes for GoRouter navigation.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';

  // Main tabs
  static const String dashboard = 'dashboard';
  static const String habits = 'habits';
  static const String community = 'community';
  static const String profile = 'profile';

  // Sub-routes
  static const String habitDetail = 'habitDetail';
  static const String settings = 'settings';
  static const String editProfile = 'editProfile';
}

/// Path strings for GoRouter routes.
abstract final class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main tabs
  static const String dashboard = '/dashboard';
  static const String habits = '/habits';
  static const String community = '/community';
  static const String profile = '/profile';

  // Sub-routes
  static const String habitDetail = '/habits/:id';
  static const String settings = '/settings';
  static const String editProfile = '/profile/edit';
}
