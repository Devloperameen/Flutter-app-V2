import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/community/presentation/screens/community_chat_screen.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simplified: Only show Chat (no posts for project submission)
    return const CommunityChatScreen();
  }
}

