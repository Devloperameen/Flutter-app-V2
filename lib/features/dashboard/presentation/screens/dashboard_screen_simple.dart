import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:url_launcher/url_launcher.dart';

/// Talk with Sadiq - Mindset & Habit Transformation App
class DashboardScreenSimple extends ConsumerStatefulWidget {
  const DashboardScreenSimple({super.key});

  @override
  ConsumerState<DashboardScreenSimple> createState() => _DashboardScreenSimpleState();
}

class _DashboardScreenSimpleState extends ConsumerState<DashboardScreenSimple> {
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  String _timerType = '';

  // Consistent Blue Color Theme
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);

  final List<Map<String, String>> _motivationalQuotes = [
    {'quote': 'The only way to do great work is to love what you do.', 'author': 'Steve Jobs'},
    {'quote': 'Success is not final, failure is not fatal: it is the courage to continue that counts.', 'author': 'Winston Churchill'},
    {'quote': 'Your time is limited, don\'t waste it living someone else\'s life.', 'author': 'Steve Jobs'},
    {'quote': 'The future belongs to those who believe in the beauty of their dreams.', 'author': 'Eleanor Roosevelt'},
    {'quote': 'Believe you can and you\'re halfway there.', 'author': 'Theodore Roosevelt'},
    {'quote': 'It does not matter how slowly you go as long as you do not stop.', 'author': 'Confucius'},
    {'quote': 'The only impossible journey is the one you never begin.', 'author': 'Tony Robbins'},
    {'quote': 'Don\'t watch the clock; do what it does. Keep going.', 'author': 'Sam Levenson'},
  ];

  // Real YouTube motivational videos
  final List<Map<String, String>> _videos = [
    {
      'title': 'MINDSET - Best Motivational Video',
      'duration': '12:04',
      'url': 'https://www.youtube.com/watch?v=g-jwWYX7Jlo',
    },
    {
      'title': 'THE POWER OF DISCIPLINE',
      'duration': '15:30',
      'url': 'https://www.youtube.com/watch?v=P3fIZuW9P_M',
    },
    {
      'title': 'WHY DO WE FALL - Motivational Video',
      'duration': '3:47',
      'url': 'https://www.youtube.com/watch?v=mgmVOuLgFB0',
    },
    {
      'title': 'CHANGE YOUR MIND - Motivational Speech',
      'duration': '10:26',
      'url': 'https://www.youtube.com/watch?v=nPAVhCy7Xzs',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-change quote every 10 seconds
    _quoteTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _motivationalQuotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer(int minutes, String type) {
    setState(() {
      _remainingSeconds = minutes * 60;
      _isTimerRunning = true;
      _timerType = type;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        _showTimerComplete();
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
    });
  }

  void _showTimerComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Great Work!'),
        content: Text('You completed your $_timerType session!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open video')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryBlue, darkBlue],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Talk with Sadiq',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Hero Card
                _buildHeroCard(theme),
                const SizedBox(height: 24),
                
                // Auto-changing Quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuoteCard(theme),
                ),
                const SizedBox(height: 24),
                
                // Functional Timer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTimerSection(theme),
                ),
                const SizedBox(height: 24),
                
                // Real YouTube Videos
                _buildVideosSection(theme),
                const SizedBox(height: 24),
                
                // About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildAboutSection(theme),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryBlue, darkBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.psychology_rounded, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Transform Your Mindset',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Changing millions of young minds and habits for a better future',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(ThemeData theme) {
    final quote = _motivationalQuotes[_currentQuoteIndex];
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(_currentQuoteIndex),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryBlue.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.format_quote_rounded, color: primaryBlue, size: 32),
            const SizedBox(height: 12),
            Text(
              quote['quote']!,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '— ${quote['author']}',
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deep Work Timer',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Pomodoro Technique for focused productivity',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        
        if (_isTimerRunning) ...[
          // Active Timer Display
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primaryBlue, darkBlue]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _timerType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryBlue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Stop Timer'),
                ),
              ],
            ),
          ),
        ] else ...[
          // Timer Options
          Row(
            children: [
              Expanded(
                child: _buildTimerCard(
                  theme,
                  'Deep Work',
                  '25 min',
                  Icons.psychology_rounded,
                  () => _startTimer(25, 'Deep Work'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimerCard(
                  theme,
                  'Extended',
                  '50 min',
                  Icons.rocket_launch_rounded,
                  () => _startTimer(50, 'Extended Focus'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimerCard(ThemeData theme, String title, String time, IconData icon, VoidCallback onStart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryBlue, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Motivational Videos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              return GestureDetector(
                onTap: () => _openVideo(video['url']!),
                child: Container(
                  width: 280,
                  margin: EdgeInsets.only(right: index < _videos.length - 1 ? 12 : 0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryBlue, darkBlue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            video['duration']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.play_circle_filled_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            video['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Talk with Sadiq',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'An app dedicated to transforming the mindset and habits of young people for a better future. Through deep work techniques, motivational content, and habit tracking, we help you become the best version of yourself.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: primaryBlue, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Changing millions of lives, one habit at a time',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
