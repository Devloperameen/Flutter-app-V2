import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });
  final String videoUrl;
  final String title;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  /// Extract YouTube video ID from various URL formats
  String? _extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    // youtube.com/watch?v=VIDEO_ID
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
            // Inject JavaScript to hide YouTube mobile web UI (header, related videos, open-in-app prompts)
            _controller.runJavaScript('''
              try {
                var header = document.querySelector('ytm-header-bar');
                if (header) header.style.display = 'none';
                
                var promos = document.querySelectorAll('ytm-promoted-sparkles-web-renderer, ytm-companion-ad-renderer');
                promos.forEach(p => p.style.display = 'none');
                
                var related = document.querySelector('ytm-item-section-renderer[section-identifier="related-items"]');
                if (related) related.style.display = 'none';
                
                var pageContainer = document.querySelector('.page-container');
                if (pageContainer) pageContainer.style.paddingTop = '0px';
              } catch(e) {}
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
        actions: [
          // Fullscreen toggle
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            onPressed: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading video...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
