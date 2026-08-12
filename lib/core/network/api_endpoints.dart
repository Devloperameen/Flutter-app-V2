/// SAFE — API Endpoint Definitions
///
/// Centralized endpoint constants prevent string duplication
/// and make backend URL changes a single-point update.
///
/// Convention: Static methods for parameterised paths,
/// static constants for fixed paths.
abstract final class ApiEndpoints {
  /// Base URL — points to Express.js backend
  /// Production: https://flutter-app-v2.onrender.com/api/v1
  static const String baseUrl = 'https://flutter-app-v2.onrender.com/api/v1';  // ✅ Using deployed backend on Render

  // ─── Auth ───────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';  // Changed from /refresh
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // ─── Users ──────────────────────────────────────
  static const String users = '/users';
  static String user(String id) => '/users/$id';

  // ─── Habits ─────────────────────────────────────
  static const String habits = '/habits';
  static String habit(String id) => '/habits/$id';
  static String habitComplete(String id) => '/habits/$id/complete';
  static String habitUndo(String id) => '/habits/$id/undo';
  static String habitStats = '/habits/stats';

  // ─── Community / Chat ───────────────────────────
  static const String messages = '/community/messages';
  static String conversation(String userId) => '/community/messages/$userId';
  static String roomMessages(String roomId) => '/community/rooms/$roomId/messages';
  static String unreadCount = '/community/messages/unread/count';
  static String unreadMessages = '/community/messages/unread';
  
  // ─── Community / Posts ───────────────────────────
  static const String posts = '/community/posts';
  static String post(String id) => '/community/posts/$id';
  static String postLikes(String postId) => '/community/posts/$postId/likes';
  static String postComments(String postId) => '/community/posts/$postId/comments';

  // ─── PHASE 3: Focus Sessions ────────────────────
  static const String focusSessions = '/focus';
  static const String focusActive = '/focus/active';
  static const String focusHistory = '/focus/history';
  static String focusComplete(String id) => '/focus/$id/complete';
  static String focusAbandon(String id) => '/focus/$id/abandon';
  static const String focusDailyStats = '/focus/stats/today';
  static const String focusWeeklyStats = '/focus/stats/weekly';

  // ─── PHASE 3: Analytics ────────────────────────
  static const String analytics = '/analytics';
  static const String analyticsHabits = '/analytics/habits';
  static const String analyticsFocus = '/analytics/focus';
  static const String analyticsXpChart = '/analytics/xp-chart';
  static const String analyticsHeatmap = '/analytics/heatmap';
  static const String analyticsLeaderboard = '/analytics/leaderboard';
  static const String analyticsMyRank = '/analytics/my-rank';
  static const String analyticsInsights = '/analytics/insights';

  // ─── PHASE 3: Activity ─────────────────────────
  static const String activityFeed = '/activity/feed';
  static const String activityToday = '/activity/today';
  static String activityByType(String type) => '/activity/by-type/$type';
  static const String activitySummary = '/activity/summary';
  static const String activityAchievements = '/activity/achievements';
  static String activityShare(String id) => '/activity/$id/share';

  // ─── PHASE 3: Content ──────────────────────────
  // Quotes
  static const String contentQuote = '/content/quote';
  static const String contentQuoteToday = '/content/quote/today';
  static const String contentQuotes = '/content/quotes';
  static String contentUpdateQuote(String id) => '/content/quote/$id';
  static String contentDeleteQuote(String id) => '/content/quote/$id';
  static String contentToggleQuote(String id) => '/content/quote/$id/toggle';
  
  // Videos
  static const String contentVideo = '/content/video';
  static const String contentVideos = '/content/videos';
  static String contentUpdateVideo(String id) => '/content/video/$id';
  static String contentDeleteVideo(String id) => '/content/video/$id';
  static String contentToggleVideo(String id) => '/content/video/$id/toggle';
  
  // Reports & Moderation
  static const String contentReport = '/content/report';
  static const String contentReportQueue = '/content/reports/queue';
  static String contentResolveReport(String id) => '/content/report/$id/resolve';
  
  // ─── Dashboard ────────────────────────────────────
  static const String dashboardStats = '/dashboard';

  // ─── Uploads ────────────────────────────────────
  static const String uploadAvatar = '/uploads/avatar';
  static const String uploadCommunity = '/uploads/community';
}
