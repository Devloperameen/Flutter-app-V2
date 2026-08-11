import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';

part 'admin_providers.g.dart';

/// Admin Statistics Provider
/// Fetches system-wide statistics for admin dashboard
@riverpod
Future<Map<String, dynamic>> adminStats(AdminStatsRef ref) async {
  try {
    final apiClient = ref.read(apiClientProvider);
    
    // Try to fetch from backend
    try {
      final response = await apiClient.get('/admin/stats');
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      log.w('Backend admin stats not available, using mock data: $e');
      
      // Return mock data for now (until backend endpoint is implemented)
      return {
        'totalUsers': 156,
        'activeUsers': 23,
        'totalPosts': 342,
        'totalComments': 891,
        'todayNewUsers': 5,
        'todayPosts': 12,
        'todayComments': 34,
        'todaySessions': 78,
      };
    }
  } catch (e) {
    log.e('Error fetching admin stats: $e');
    rethrow;
  }
}

/// Admin Users Provider
/// Fetches all users for user management
@riverpod
Future<List<Map<String, dynamic>>> adminUsers(AdminUsersRef ref) async {
  try {
    final apiClient = ref.read(apiClientProvider);
    
    try {
      final response = await apiClient.get('/admin/users');
      return List<Map<String, dynamic>>.from((response['data'] as List<dynamic>?) ?? []);
    } catch (e) {
      log.w('Backend admin users not available, using mock data: $e');
      
      // Mock data for now
      return [
        {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john@example.com',
          'role': 'user',
          'createdAt': DateTime.now().subtract(const Duration(days: 30)),
        },
        {
          'id': '2',
          'firstName': 'Jane',
          'lastName': 'Smith',
          'email': 'jane@example.com',
          'role': 'user',
          'createdAt': DateTime.now().subtract(const Duration(days: 15)),
        },
        {
          'id': '3',
          'firstName': 'Admin',
          'lastName': 'User',
          'email': 'admin@fitflow.com',
          'role': 'super_admin',
          'createdAt': DateTime.now().subtract(const Duration(days: 90)),
        },
      ];
    }
  } catch (e) {
    log.e('Error fetching admin users: $e');
    rethrow;
  }
}

/// Admin Posts Provider
/// Fetches all posts for content moderation
@riverpod
Future<List<Map<String, dynamic>>> adminPosts(AdminPostsRef ref) async {
  try {
    final apiClient = ref.read(apiClientProvider);
    
    try {
      final response = await apiClient.get('/admin/posts');
      return List<Map<String, dynamic>>.from((response['data'] as List<dynamic>?) ?? []);
    } catch (e) {
      log.w('Backend admin posts not available, using mock data: $e');
      
      // Mock data for now
      return [
        {
          'id': '1',
          'authorName': 'John Doe',
          'authorId': '1',
          'content': 'Just completed my first 25-minute focus session! 🎯',
          'likeCount': 12,
          'commentCount': 3,
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'id': '2',
          'authorName': 'Jane Smith',
          'authorId': '2',
          'content': "Morning workout done! Time to crush today's goals 💪",
          'imageUrl': 'https://picsum.photos/400/300',
          'likeCount': 25,
          'commentCount': 7,
          'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
        },
        {
          'id': '3',
          'authorName': 'User Three',
          'authorId': '4',
          'content': 'Looking for an accountability partner. Who wants to join me?',
          'likeCount': 8,
          'commentCount': 15,
          'createdAt': DateTime.now().subtract(const Duration(hours: 8)),
        },
      ];
    }
  } catch (e) {
    log.e('Error fetching admin posts: $e');
    rethrow;
  }
}
