/// SAFE — API Endpoint Definitions
///
/// Centralized endpoint constants prevent string duplication
/// and make backend URL changes a single-point update.
///
/// Convention: Static methods for parameterised paths,
/// static constants for fixed paths.
abstract final class ApiEndpoints {
  /// Base URL — points to the Spring Boot backend.
  /// Using adb reverse tcp:8080 tcp:8080 allows physical devices to use localhost
  static const String baseUrl = 'http://127.0.0.1:8080/api/v1';

  // ─── Auth ───────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String googleLogin = '/auth/google';
  static const String me = '/auth/me';

  // ─── Users ──────────────────────────────────────
  static const String users = '/users';
  static String user(String id) => '/users/$id';

  // ─── Habits ─────────────────────────────────────
  static const String habits = '/habits';
  static String habit(String id) => '/habits/$id';
  static String habitLogs(String habitId) => '/habits/$habitId/logs';

  // ─── Deep Work ──────────────────────────────────
  static const String deepWorkSessions = '/deep-work/sessions';
  static String deepWorkSession(String id) => '/deep-work/sessions/$id';
  static const String deepWorkStats = '/deep-work/stats';

  // ─── Dashboard ──────────────────────────────────
  static const String dailyMission = '/dashboard/mission';
  static const String dailyQuote = '/dashboard/quote';
  static const String dashboardStats = '/dashboard/stats';

  // ─── Talks / My Talk with Sadiq ─────────────────
  static const String talks = '/talks';
  static String talk(String id) => '/talks/$id';
  static const String talksFeatured = '/talks/featured';
  static const String talksDaily = '/talks/daily';

  // ─── Community ──────────────────────────────────
  static const String posts = '/community/posts';
  static String post(String id) => '/community/posts/$id';
  static String postLikes(String id) => '/community/posts/$id/likes';
  static String postComments(String id) => '/community/posts/$id/comments';

  // ─── Energy ─────────────────────────────────────
  static const String energyLogs = '/energy/logs';
  static const String energyStats = '/energy/stats';

  // ─── Learning ───────────────────────────────────
  static const String courses = '/learning/courses';
  static String course(String id) => '/learning/courses/$id';

  // ─── Achievements ───────────────────────────────
  static const String achievements = '/achievements';
  static const String badges = '/achievements/badges';

  // ─── AI Coach ───────────────────────────────────
  static const String aiCoachChat = '/ai-coach/chat';
  static const String aiCoachSuggestions = '/ai-coach/suggestions';

  // ─── Notifications ──────────────────────────────
  static const String notifications = '/notifications';
}
