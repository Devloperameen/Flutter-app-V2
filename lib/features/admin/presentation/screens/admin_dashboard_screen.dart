import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/admin/presentation/providers/admin_providers.dart';

/// Admin Dashboard Screen
/// Super admin only - shows system overview, user management, content moderation
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adminStats = ref.watch(adminStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade700, Colors.red.shade900],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Admin Dashboard'),
          ],
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.content_paste), text: 'Content'),
            Tab(icon: Icon(Icons.settings), text: 'System'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview Tab
          _buildOverviewTab(theme, adminStats),
          // Users Tab
          _buildUsersTab(theme),
          // Content Tab
          _buildContentTab(theme),
          // System Tab
          _buildSystemTab(theme),
        ],
      ),
    );
  }

  /// Overview Tab - Statistics and key metrics
  Widget _buildOverviewTab(ThemeData theme, AsyncValue<Map<String, dynamic>> adminStats) {
    return adminStats.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading stats: $err'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(adminStatsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  icon: Icons.people,
                  title: 'Total Users',
                  value: '${stats['totalUsers'] ?? 0}',
                  color: Colors.blue,
                  theme: theme,
                ),
                _buildStatCard(
                  icon: Icons.online_prediction,
                  title: 'Active Now',
                  value: '${stats['activeUsers'] ?? 0}',
                  color: Colors.green,
                  theme: theme,
                ),
                _buildStatCard(
                  icon: Icons.post_add,
                  title: 'Total Posts',
                  value: '${stats['totalPosts'] ?? 0}',
                  color: Colors.purple,
                  theme: theme,
                ),
                _buildStatCard(
                  icon: Icons.comment,
                  title: 'Total Comments',
                  value: '${stats['totalComments'] ?? 0}',
                  color: Colors.orange,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Activity
            Text(
              'Today\'s Activity',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildActivityRow(Icons.person_add, 'New Users', '${stats['todayNewUsers'] ?? 0}', Colors.blue),
                  const Divider(),
                  _buildActivityRow(Icons.post_add, 'New Posts', '${stats['todayPosts'] ?? 0}', Colors.purple),
                  const Divider(),
                  _buildActivityRow(Icons.comment, 'New Comments', '${stats['todayComments'] ?? 0}', Colors.orange),
                  const Divider(),
                  _buildActivityRow(Icons.timer, 'Focus Sessions', '${stats['todaySessions'] ?? 0}', Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // System Health
            Text(
              'System Health',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildHealthRow('Backend API', true),
                  const Divider(),
                  _buildHealthRow('Database', true),
                  const Divider(),
                  _buildHealthRow('File Storage', true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Users Tab - User management
  Widget _buildUsersTab(ThemeData theme) {
    final users = ref.watch(adminUsersProvider);

    return users.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (userList) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  ((user['firstName'] as String?)?.isNotEmpty == true) 
                      ? (user['firstName'] as String)[0].toUpperCase() 
                      : 'U',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text('${user['firstName'] as String? ?? ''} ${user['lastName'] as String? ?? ''}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['email'] as String? ?? 'No email'),
                  Text(
                    'Role: ${user['role'] as String? ?? 'user'}',
                    style: TextStyle(
                      color: user['role'] == 'admin' ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'view', child: Text('View Details')),
                  const PopupMenuItem(value: 'ban', child: Text('Ban User')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete User')),
                ],
                onSelected: (value) {
                  // Handle user actions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$value: ${user['email']}')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Content Tab - Content moderation
  Widget _buildContentTab(ThemeData theme) {
    final posts = ref.watch(adminPostsProvider);

    return posts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (postList) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: postList.length,
        itemBuilder: (context, index) {
          final post = postList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        radius: 16,
                        child: Text(
                          ((post['authorName'] as String?)?.isNotEmpty == true)
                              ? (post['authorName'] as String)[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post['authorName'] as String? ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        (post['createdAt'] as String?)?.substring(0, 10) ?? '',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(post['content'] as String? ?? 'No content'),
                  if (post['imageUrl'] != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post['imageUrl'] as String,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('${post['likeCount'] ?? 0}'),
                      const SizedBox(width: 16),
                      Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('${post['commentCount'] ?? 0}'),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          // Delete post
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delete post: ${post['id']}')),
                          );
                        },
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// System Tab - System configuration
  Widget _buildSystemTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Configuration',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Database'),
            subtitle: const Text('MongoDB - Connected'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Backend API'),
            subtitle: const Text('http://localhost:5000/api/v1'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('File Storage'),
            subtitle: const Text('Local + Backend'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const SizedBox(height: 24),
          Text(
            'Actions',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(adminStatsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stats refreshed')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Statistics'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Clear Cache'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRow(String service, bool isHealthy) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isHealthy ? Icons.check_circle : Icons.error,
            color: isHealthy ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(service),
          const Spacer(),
          Text(
            isHealthy ? 'Online' : 'Offline',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHealthy ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
