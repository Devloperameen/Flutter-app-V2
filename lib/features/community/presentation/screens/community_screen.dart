import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/community/presentation/screens/community_chat_screen.dart';
import 'package:safe/features/community/presentation/screens/community_posts_screen.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(
              icon: Icon(Icons.chat_bubble_outline),
              text: 'Chat',
            ),
            Tab(
              icon: Icon(Icons.article_outlined),
              text: 'Posts',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CommunityChatScreen(),
          CommunityPostsScreen(),
        ],
      ),
    );
  }
}

