/// SAFE — Storage Key Constants
///
/// Centralised keys for SharedPreferences and Flutter Secure Storage.
/// Prefixed with 'safe_' to avoid collisions with other packages.
abstract final class StorageKeys {
  // ─── Secure Storage (tokens, secrets) ───────────
  static const String accessToken = 'safe_access_token';
  static const String refreshToken = 'safe_refresh_token';
  static const String userId = 'safe_user_id';

  // ─── Local Storage (preferences) ────────────────
  static const String themeMode = 'safe_theme_mode';
  static const String onboardingComplete = 'safe_onboarding_complete';
  static const String firstLaunch = 'safe_first_launch';
  static const String userName = 'safe_user_name';
  static const String userEmail = 'safe_user_email';
  static const String userAvatarUrl = 'safe_user_avatar_url';
  static const String lastSyncTimestamp = 'safe_last_sync';
  static const String cachedHabits = 'safe_cached_habits';
  static const String cachedDailyMission = 'safe_cached_daily_mission';
}
