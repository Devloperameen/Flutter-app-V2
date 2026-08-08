/// SAFE — Application Constants
///
/// Centralized configuration values that can be changed without
/// hunting through the codebase.
abstract final class AppConstants {
  // ─────────────────────────────────────────────
  // App Identity
  // ─────────────────────────────────────────────

  static const String appName = 'SAFE';
  static const String appTagline = 'Become Your Best Self';
  static const String appDescription =
      'A personal transformation platform that guides you through every stage of life.';
  static const String appVersion = '0.1.0';

  // ─────────────────────────────────────────────
  // Mission
  // ─────────────────────────────────────────────

  static const String mission =
      'Help millions of people become the best version of themselves.';

  // ─────────────────────────────────────────────
  // Mentor
  // ─────────────────────────────────────────────

  static const String mentorName = 'Sadiq';
  static const String mentorTitle = 'Founder & Mentor';

  // ─────────────────────────────────────────────
  // API Configuration (placeholder — will be configured per environment)
  // ─────────────────────────────────────────────

  static const String apiBaseUrl = 'https://api.safe.app';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiMaxRetries = 3;

  // ─────────────────────────────────────────────
  // Storage Keys
  // ─────────────────────────────────────────────

  static const String keyThemeMode = 'safe_theme_mode';
  static const String keyAccessToken = 'safe_access_token';
  static const String keyRefreshToken = 'safe_refresh_token';
  static const String keyUserId = 'safe_user_id';
  static const String keyOnboardingComplete = 'safe_onboarding_complete';
  static const String keyFirstLaunch = 'safe_first_launch';

  // ─────────────────────────────────────────────
  // Deep Work
  // ─────────────────────────────────────────────

  static const int defaultFocusDurationMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int sessionsBeforeLongBreak = 4;

  // ─────────────────────────────────────────────
  // Pagination
  // ─────────────────────────────────────────────

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxPostLength = 2000;
  static const int maxCommentLength = 500;
}
