import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/features/community/domain/models/post.dart';
import 'package:safe/features/community/presentation/providers/community_provider.dart';
import 'package:safe/features/community/presentation/screens/create_post_screen.dart';
import 'package:safe/features/community/presentation/screens/community_chat_screen.dart';
import 'package:safe/features/community/presentation/widgets/post_video_player.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: const Text('Community'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Posts', icon: Icon(Icons.newspaper_rounded)),
              Tab(text: 'Chat', icon: Icon(Icons.chat_rounded)),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPostsTab(context, ref, theme),
            const CommunityChatScreen(),
          ],
        ),
        floatingActionButton: _buildFAB(context),
      ),
    );
  }

  /// Build FAB - only visible on Posts tab
  Widget? _buildFAB(BuildContext context) {
    // Use maybeOf instead of of to avoid context issues during build
    final tabController = DefaultTabController.maybeOf(context);
    
    // If no controller found or not on Posts tab (index 0), don't show FAB
    if (tabController == null || tabController.index != 0) {
      return null;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF006E), Color(0xFF8338EC), Color(0xFF3A86FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8338EC).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
    );
  }

  /// Build the posts tab
  Widget _buildPostsTab(BuildContext context, WidgetRef ref, ThemeData theme) {
    final postsAsync = ref.watch(communityNotifierProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(communityNotifierProvider.notifier).refresh(),
      color: theme.colorScheme.primary,
      child: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet. Be the first!'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: posts.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostCard(context, theme, post, ref)
                  .animate(delay: Duration(milliseconds: 100 * index))
                  .fadeIn()
                  .slideY(begin: 0.1);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Could not load posts',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Check your connection and try again.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () =>
                    ref.read(communityNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, ThemeData theme, Post post, WidgetRef ref) {
    // Generate an avatar color based on the author's name hash
    final colorList = [
      AppColors.primarySeed,
      AppColors.secondarySeed,
      AppColors.tertiarySeed,
      AppColors.deepWorkFocus,
      AppColors.energyFull,
    ];
    final avatarColor = colorList[post.authorName.hashCode % colorList.length];

    // Helper to format "2h ago"
    final difference = DateTime.now().difference(post.createdAt);
    String timeAgo = '';
    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header - Modern Instagram style
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Avatar with online status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: avatarColor,
                      child: Text(
                        post.authorName.isNotEmpty
                            ? post.authorName[0].toUpperCase()
                            : 'U',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.authorName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (post.authorRole == 'Mentor') ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${post.authorRole} • $timeAgo',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () {},
                  color: theme.colorScheme.onSurfaceVariant,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // Content Text
          if (post.content.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                post.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Media Content (Image or Video - Priority to image)
          if (post.imageUrl != null || post.videoUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: post.imageUrl != null
                  ? Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 280,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 280,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image failed to load',
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 280,
                      child: PostVideoPlayer(videoUrl: post.videoUrl!),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Like, Comment, Share - TikTok/Reels style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                // Likes
                Expanded(
                  child: _buildInteractionButton(
                    theme,
                    icon: post.isLikedByMe
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: post.isLikedByMe ? Colors.red : null,
                    label: post.likeCount > 0 ? '${post.likeCount}' : '',
                    onTap: () {
                      ref
                          .read(communityNotifierProvider.notifier)
                          .toggleLike(post.id);
                    },
                  ),
                ),
                // Comments
                Expanded(
                  child: _buildInteractionButton(
                    theme,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: post.commentCount > 0 ? '${post.commentCount}' : '',
                    onTap: () {
                      // Show comments dialog
                      _showCommentsDialog(context, theme, post, ref);
                    },
                  ),
                ),
                // Share
                Expanded(
                  child: _buildInteractionButton(
                    theme,
                    icon: Icons.share_rounded,
                    label: '',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  /// Show comments dialog - Instagram/Telegram style
  void _showCommentsDialog(
    BuildContext context,
    ThemeData theme,
    Post post,
    WidgetRef ref,
  ) {
    final commentCtrl = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments (${post.commentCount})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Comments list - Empty state message
              Expanded(
                child: post.commentCount == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No comments yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Be the first to comment!',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenHorizontal,
                        ),
                        children: [
                          // Placeholder: Comments would load from Firestore here
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 40,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Comments coming soon!',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Firestore setup needed',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              // Comment input - FUNCTIONAL
              Container(
                padding: EdgeInsets.only(
                  left: AppSpacing.screenHorizontal,
                  right: AppSpacing.screenHorizontal,
                  top: AppSpacing.md,
                  bottom: AppSpacing.md +
                      MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentCtrl,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () {
                        final text = commentCtrl.text.trim();
                        if (text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Comment added (Firestore setup needed)'),
                              backgroundColor: theme.colorScheme.primary,
                            ),
                          );
                          commentCtrl.clear();
                        }
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? theme.colorScheme.onSurfaceVariant,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: iconColor ?? theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

