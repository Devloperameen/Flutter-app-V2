import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/dashboard/presentation/screens/timer_page.dart';
import 'package:safe/features/habits/presentation/providers/habits_stream_provider.dart';
import 'package:safe/features/habits/presentation/providers/habit_actions_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Talk with Sadiq - Mindset & Habit Transformation App
class DashboardScreenSimple extends ConsumerStatefulWidget {
  const DashboardScreenSimple({super.key});

  @override
  ConsumerState<DashboardScreenSimple> createState() => _DashboardScreenSimpleState();
}

class _DashboardScreenSimpleState extends ConsumerState<DashboardScreenSimple> {
  late PageController _carouselController;
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;
  Timer? _quoteTimer;
  bool _isCarouselAutoScrolling = true;
  int _currentQuoteIndex = 0;

  // Consistent Blue Color Theme
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);

  final List<Map<String, String>> _motivationalQuotes = [
    {'quote': 'The only way to do great work is to love what you do.', 'author': 'Steve Jobs'},
    {'quote': 'Success is not final, failure is not fatal: it is the courage to continue that counts.', 'author': 'Winston Churchill'},
    {'quote': "Your time is limited, don't waste it living someone else's life.", 'author': 'Steve Jobs'},
    {'quote': 'The future belongs to those who believe in the beauty of their dreams.', 'author': 'Eleanor Roosevelt'},
    {'quote': "Believe you can and you're halfway there.", 'author': 'Theodore Roosevelt'},
    {'quote': 'It does not matter how slowly you go as long as you do not stop.', 'author': 'Confucius'},
    {'quote': 'The only impossible journey is the one you never begin.', 'author': 'Tony Robbins'},
    {'quote': "Don't watch the clock; do what it does. Keep going.", 'author': 'Sam Levenson'},
  ];

  // Real YouTube motivational videos from your links
  final List<Map<String, String>> _videos = [
    {
      'title': 'Mindset Transformation',
      'duration': '10:30',
      'url': 'https://www.youtube.com/watch?v=kuxuGGVx_p8',
    },
    {
      'title': 'Power of Deep Work',
      'duration': '15:20',
      'url': 'https://www.youtube.com/watch?v=l6ZcFa8pybE',
    },
    {
      'title': 'Success Habits',
      'duration': '12:45',
      'url': 'https://www.youtube.com/watch?v=ZXGWYe01Ya8',
    },
    {
      'title': 'Motivation & Focus',
      'duration': '8:15',
      'url': 'https://www.youtube.com/watch?v=TLKxdTmk-zc',
    },
    {
      'title': 'Change Your Life',
      'duration': '14:00',
      'url': 'https://www.youtube.com/watch?v=d9gwmyPMByM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController();
    
    // Auto-change quote every 10 seconds
    _quoteTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _motivationalQuotes.length;
        });
      }
    });

    // Auto-change carousel every 5 seconds
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isCarouselAutoScrolling && _carouselController.hasClients) {
        final nextPage = (_currentCarouselIndex + 1) % _videos.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
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
    final authState = ref.watch(authNotifierProvider);
    final now = DateTime.now();
    final greeting = _getTimeBasedGreeting();
    final dateString = DateFormat('EEEE, MMMM d').format(now);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(habitsStreamProvider);
          // Wait a tiny bit for UI to feel responsive
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: primaryBlue,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                
                // A. HEADER with greeting, date, profile
                _buildHeaderSection(theme, authState, greeting, dateString),
                const SizedBox(height: 24),

                // B. DAILY PROGRESS OVERVIEW
                _buildDailyProgressSection(theme, ref),
                const SizedBox(height: 24),

                // C. FEATURED QUOTE / VIDEO CAROUSEL
                _buildCarouselSection(theme),
                const SizedBox(height: 24),

                // D. FOCUS TIMER
                _buildTimerSection(theme),
                const SizedBox(height: 24),

                // E. TODAY'S HABITS
                _buildHabitsSection(theme, ref),
                const SizedBox(height: 24),

                // F. DAILY MISSION
                _buildMissionSection(theme),
                const SizedBox(height: 24),

                // G. COMMUNITY PREVIEW
                _buildCommunityPreviewSection(theme),
                const SizedBox(height: 24),

                // H. LEARNING / VIDEOS
                _buildLearningVideosSection(theme),
                const SizedBox(height: 24),

                // I. STATISTICS
                _buildStatisticsSection(theme),
                const SizedBox(height: 24),

                // J. QUICK ACTIONS
                _buildQuickActionsSection(theme),
                const SizedBox(height: 24),

                // K. BOTTOM MOTIVATION
                _buildMotivationSection(theme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '🌅 Good Morning';
    if (hour < 18) return '☀️ Good Afternoon';
    return '🌙 Good Evening';
  }

  // A. HEADER SECTION
  Widget _buildHeaderSection(ThemeData theme, AsyncValue<User?> authState, String greeting, String dateString) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                dateString,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryBlue, darkBlue],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 8,
                )
              ],
            ),
            child: const Icon(Icons.account_circle_rounded, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  // B. DAILY PROGRESS OVERVIEW
  Widget _buildDailyProgressSection(ThemeData theme, WidgetRef ref) {
    final completionAsync = ref.watch(completionPercentageProvider);
    final activeHabitsList = ref.watch(activeHabitsProvider);
    final currentStreak = ref.watch(totalCurrentStreakProvider);
    final completedHabits = ref.watch(completedHabitsTodayProvider);
    
    final habitsText = '${completedHabits.length}/${activeHabitsList.length}';
    final streakText = '$currentStreak days';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Progress bar
            completionAsync.when(
              data: (percentage) {
                final displayPct = (percentage).clamp(0, 100).toInt();
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Completion',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        Text('$displayPct%', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (percentage / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: primaryBlue.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation(primaryBlue),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: LinearProgressIndicator()),
              error: (e, _) => Text('Error loading progress', style: TextStyle(color: theme.colorScheme.error)),
            ),
            
            const SizedBox(height: 16),
            
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer_rounded,
                    label: 'Focus Time',
                    value: '0h 0m', // Connect to focus timer data later
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.task_alt_rounded,
                    label: 'Habits',
                    value: habitsText,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.whatshot_rounded,
                    label: 'Streak',
                    value: streakText,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryBlue, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // C. FEATURED CAROUSEL SECTION
  Widget _buildCarouselSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Content',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              final videoId = video['url']!.split('v=').last.split('&').first;
              final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

              return GestureDetector(
                onTap: () {
                  setState(() => _isCarouselAutoScrolling = false);
                  _openVideo(video['url']!).then((_) {
                    setState(() => _isCarouselAutoScrolling = true);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return ColoredBox(
                              color: primaryBlue,
                              child: const Center(
                                child: Icon(
                                  Icons.video_library_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return ColoredBox(
                              color: primaryBlue,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                            );
                          },
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
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  video['duration']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _videos.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentCarouselIndex
                      ? primaryBlue
                      : primaryBlue.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // D. FOCUS TIMER SECTION
  Widget _buildTimerSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deep Work Timer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Pomodoro Technique for focused productivity', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _openTimerPage(context, 25, 'Deep Work'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: lightBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.psychology_rounded, color: primaryBlue, size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text('Deep Work', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        const Text('25 min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _openTimerPage(context, 25, 'Deep Work'),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 36),
                            elevation: 2,
                            shadowColor: primaryBlue.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openTimerPage(context, 50, 'Extended Focus'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: lightBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.rocket_launch_rounded, color: primaryBlue, size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text('Extended', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        const Text('50 min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _openTimerPage(context, 50, 'Extended Focus'),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 36),
                            elevation: 2,
                            shadowColor: primaryBlue.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Open timer on a separate page/screen
  void _openTimerPage(BuildContext context, int minutes, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerPage(minutes: minutes, timerType: type),
      ),
    );
  }

  // E. TODAY'S HABITS SECTION
  Widget _buildHabitsSection(ThemeData theme, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("Today's Habits", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: habitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (habits) {
              final activeHabits = habits.where((h) => !h.archived).toList();
              
              if (activeHabits.isEmpty) {
                return const Center(
                  child: Text('No habits yet. Start building good habits!'),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: activeHabits.length,
                itemBuilder: (context, index) {
                  final habit = activeHabits[index];
                  final done = habit.completedToday;
                  
                  return GestureDetector(
                    onTap: () {
                      if (done) {
                        ref.read(undoHabitActionProvider(habit.id).future);
                      } else {
                        ref.read(completeHabitActionProvider(habit.id).future);
                      }
                    },
                    child: Container(
                      width: 140,
                      margin: EdgeInsets.only(right: index < activeHabits.length - 1 ? 12 : 0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: done ? primaryBlue.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: done ? primaryBlue : theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                color: done ? primaryBlue : theme.colorScheme.outlineVariant, size: 20),
                              const Spacer(),
                              Text(done ? '✓' : '→', style: TextStyle(color: done ? primaryBlue : theme.colorScheme.outlineVariant, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          const Text('+ 50 XP', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // F. DAILY MISSION SECTION
  Widget _buildMissionSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryBlue.withValues(alpha: 0.1), lightBlue.withValues(alpha: 0.1)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryBlue.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.star_rounded, color: primaryBlue, size: 24)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Today's Mission", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Complete one deep work session', style: TextStyle(fontSize: 13, color: Colors.grey)),
                ])),
              ],
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Progress', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              const Text('75%', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: 0.75, minHeight: 6, backgroundColor: primaryBlue.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(primaryBlue))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white), child: const Text('Continue Mission'))),
            const SizedBox(height: 8),
            Text('Reward: +200 XP', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // G. COMMUNITY PREVIEW SECTION
  Widget _buildCommunityPreviewSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Community', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryBlue, darkBlue]), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person_rounded, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Sadiq Ahmed', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Just completed a 50-minute focus session!', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ])),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(children: [
                  Icon(Icons.favorite_rounded, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text('45', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 16),
                  Icon(Icons.message_rounded, color: primaryBlue, size: 18),
                  SizedBox(width: 4),
                  Text('12', style: TextStyle(fontSize: 12)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.forum_rounded), label: const Text('Open Community Chat'), style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white))),
        ],
      ),
    );
  }

  // H. LEARNING / VIDEOS SECTION
  Widget _buildLearningVideosSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Learning Resources', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              final videoId = video['url']!.split('v=').last.split('&').first;
              final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
              return GestureDetector(
                onTap: () => _openVideo(video['url']!),
                child: Container(
                  width: 180,
                  margin: EdgeInsets.only(right: index < _videos.length - 1 ? 12 : 0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(thumbnailUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => ColoredBox(color: primaryBlue, child: const Center(child: Icon(Icons.video_library_rounded, color: Colors.white, size: 32)))),
                        const Center(child: Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 48)),
                        Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(6)), child: Text(video['duration']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // I. STATISTICS SECTION
  Widget _buildStatisticsSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weekly Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildStatBox(icon: Icons.timer_rounded, label: 'Focus Time', value: '12.5h', theme: theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox(icon: Icons.task_alt_rounded, label: 'Habits Done', value: '24/28', theme: theme)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildStatBox(icon: Icons.whatshot_rounded, label: 'Current Streak', value: '7 days', theme: theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox(icon: Icons.star_rounded, label: 'XP Earned', value: '+850', theme: theme)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({required IconData icon, required String label, required String value, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: primaryBlue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryBlue.withValues(alpha: 0.2))),
      child: Column(
        children: [
          Icon(icon, color: primaryBlue, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // J. QUICK ACTIONS SECTION
  Widget _buildQuickActionsSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildActionButton(icon: Icons.play_arrow_rounded, label: 'Focus', color: primaryBlue, onTap: () => _openTimerPage(context, 25, 'Deep Work')),
              _buildActionButton(icon: Icons.task_alt_rounded, label: 'Habits', color: const Color(0xFF4CAF50), onTap: () {}),
              _buildActionButton(icon: Icons.forum_rounded, label: 'Community', color: const Color(0xFFFFC107), onTap: () {}),
              _buildActionButton(icon: Icons.video_library_rounded, label: 'Learning', color: const Color(0xFF9C27B0), onTap: () {}),
              _buildActionButton(icon: Icons.trending_up_rounded, label: 'Progress', color: const Color(0xFFE91E63), onTap: () {}),
              _buildActionButton(icon: Icons.account_circle_rounded, label: 'Profile', color: const Color(0xFF00BCD4), onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  // K. MOTIVATION SECTION
  Widget _buildMotivationSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryBlue.withValues(alpha: 0.15), darkBlue.withValues(alpha: 0.15)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryBlue.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote_rounded, color: primaryBlue, size: 28),
            const SizedBox(height: 12),
            Text(_motivationalQuotes[_currentQuoteIndex]['quote']!, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5)),
            const SizedBox(height: 12),
            Text('— ${_motivationalQuotes[_currentQuoteIndex]['author']}', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(children: const [
                Icon(Icons.star_rounded, color: primaryBlue),
                SizedBox(width: 8),
                Expanded(child: Text("Keep going! You're making progress every day.", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
