import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/dashboard/presentation/screens/video_player_screen.dart';

/// Fallback motivational videos (shown when backend is offline)
const _fallbackVideos = [
  {
    'title': 'Mindset Transformation',
    'category': 'MOTIVATION',
    'videoId': 'kuxuGGVx_p8',
    'url': 'https://www.youtube.com/watch?v=kuxuGGVx_p8',
  },
  {
    'title': 'Power of Deep Work',
    'category': 'PRODUCTIVITY',
    'videoId': 'l6ZcFa8pybE',
    'url': 'https://www.youtube.com/watch?v=l6ZcFa8pybE',
  },
  {
    'title': 'Success Habits',
    'category': 'HABITS',
    'videoId': 'ZXGWYe01Ya8',
    'url': 'https://www.youtube.com/watch?v=ZXGWYe01Ya8',
  },
  {
    'title': 'Motivation & Focus',
    'category': 'MOTIVATION',
    'videoId': 'TLKxdTmk-zc',
    'url': 'https://www.youtube.com/watch?v=TLKxdTmk-zc',
  },
  {
    'title': 'Change Your Life',
    'category': 'MINDSET',
    'videoId': 'd9gwmyPMByM',
    'url': 'https://www.youtube.com/watch?v=d9gwmyPMByM',
  },
];

/// Learning / Videos Screen
/// Plays videos inside the app. Shows built-in curated videos when backend is offline.
class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Videos'),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _fallbackVideos.length,
        itemBuilder: (context, index) {
          final v = _fallbackVideos[index];
          return _VideoCard(
            title: v['title']!,
            category: v['category']!,
            videoId: v['videoId']!,
            videoUrl: v['url']!,
          );
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.title,
    required this.category,
    required this.videoId,
    required this.videoUrl,
  });

  final String title;
  final String category;
  final String videoId;
  final String videoUrl;

  void _play(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(videoUrl: videoUrl, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => _play(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail + play overlay
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    thumbUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black87,
                      child: const Icon(Icons.play_circle_outline,
                          size: 64, color: Colors.white54),
                    ),
                  ),
                  // Gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  // Play button
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          size: 40, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(category,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_filled_rounded,
                        color: Colors.red, size: 36),
                    onPressed: () => _play(context),
                    tooltip: 'Watch',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
