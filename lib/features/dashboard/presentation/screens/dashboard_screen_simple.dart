import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';

/// Talk with Sadiq App - Dashboard
/// Transforming young minds through mindset and habit change
class DashboardScreenSimple extends ConsumerStatefulWidget {
  const DashboardScreenSimple({super.key});

  @override
  ConsumerState<DashboardScreenSimple> createState() => _DashboardScreenSimpleState();
}

class _DashboardScreenSimpleState extends ConsumerState<DashboardScreenSimple> {
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;

  final List<Map<String, String>> _motivationalQuotes = [
    {
      'quote': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs'
    },
    {
      'quote': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      'author': 'Winston Churchill'
    },
    {
      'quote': 'Your time is limited, don\'t waste it living someone else\'s life.',
      'author': 'Steve Jobs'
    },
    {
      'quote': 'The future belongs to those who believe in the beauty of their dreams.',
      'author': 'Eleanor Roosevelt'
    },
    {
      'quote': 'Believe you can and you\'re halfway there.',
      'author': 'Theodore Roosevelt'
    },
    {
      'quote': 'It does not matter how slowly you go as long as you do not stop.',
      'author': 'Confucius'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Change quote every 10 seconds
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
    super.dispose();
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
                      colors: [Color(0xFFFF006E), Color(0xFF8338EC)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Talk with Sadiq',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                const SizedBox(height: AppSpacing.md),
                
                // Hero Section
                _buildHeroCard(theme),
                const SizedBox(height: AppSpacing.lg),
                
                // Motivational Quote (Changes every 10 seconds)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: _buildQuoteCard(theme),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Deep Work Timer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: _buildDeepWorkSection(theme),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // AI Motivation Videos (Horizontal Scroll)
                _buildVideosSection(theme),
                const SizedBox(height: AppSpacing.lg),
                
                // Book Reviews (Horizontal Scroll)
                _buildBooksSection(theme),
                const SizedBox(height: AppSpacing.lg),
                
                // About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                  child: _buildAboutSection(theme),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF006E), Color(0xFF8338EC), Color(0xFF3A86FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8338EC).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Transform Your Mindset',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Changing millions of young minds and habits for a better future',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(ThemeData theme) {
    final currentQuote = _motivationalQuotes[_currentQuoteIndex];
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(_currentQuoteIndex),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.format_quote_rounded,
              color: theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              currentQuote['quote']!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '— ${currentQuote['author']}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepWorkSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deep Work Timer',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pomodoro Technique for focused productivity',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTimerCard(
                theme,
                'Deep Work Focus',
                '25:00',
                '+50 XP',
                Icons.psychology_rounded,
                const Color(0xFFFF006E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimerCard(
                theme,
                'Start Mission',
                '50:00',
                '+100 XP',
                Icons.rocket_launch_rounded,
                const Color(0xFF8338EC),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerCard(
    ThemeData theme,
    String title,
    String time,
    String xp,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            xp,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Start'),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(double.infinity, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosSection(ThemeData theme) {
    final videos = [
      {
        'title': '20 Minutes to Change Your Life',
        'duration': '20:00',
        'thumbnail': Icons.play_circle_filled_rounded,
      },
      {
        'title': 'Morning Motivation',
        'duration': '15:30',
        'thumbnail': Icons.wb_sunny_rounded,
      },
      {
        'title': 'Success Mindset',
        'duration': '18:45',
        'thumbnail': Icons.trending_up_rounded,
      },
      {
        'title': 'Overcome Procrastination',
        'duration': '12:20',
        'thumbnail': Icons.timer_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Motivation Videos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: index < videos.length - 1 ? 12 : 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFF006E).withValues(alpha: 0.8),
                      const Color(0xFF8338EC).withValues(alpha: 0.8),
                    ],
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
                          color: Colors.black.withValues(alpha: 0.6),
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
                    Center(
                      child: Icon(
                        video['thumbnail'] as IconData,
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
                              Colors.black.withValues(alpha: 0.8),
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBooksSection(ThemeData theme) {
    final books = [
      {
        'title': 'Atomic Habits',
        'author': 'James Clear',
        'rating': '4.8',
      },
      {
        'title': 'Deep Work',
        'author': 'Cal Newport',
        'rating': '4.6',
      },
      {
        'title': 'The Power of Now',
        'author': 'Eckhart Tolle',
        'rating': '4.7',
      },
      {
        'title': 'Can\'t Hurt Me',
        'author': 'David Goggins',
        'rating': '4.9',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Book Reviews',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(right: index < books.length - 1 ? 12 : 0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book['title']!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${book['author']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                book['rating']!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
          Text(
            'About Talk with Sadiq',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'An app dedicated to transforming the mindset and habits of young people for a better future. Through deep work techniques, motivational content, and habit tracking, we help you become the best version of yourself.',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Changing millions of lives, one habit at a time',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
