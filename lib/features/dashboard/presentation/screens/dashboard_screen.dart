import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/core/widgets/widgets.dart';
import 'package:safe/features/dashboard/domain/models/mentor_message.dart';
import 'package:safe/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:safe/features/dashboard/presentation/widgets/mentor_message_card.dart';
import 'package:safe/features/focus_timer/domain/models/timer_config.dart';
import 'package:safe/features/focus_timer/presentation/screens/focus_timer_screen.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/presentation/providers/habits_stream_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dashboardAsync = ref.watch(dashboardNotifierProvider);
    final habitsAsync = ref.watch(habitsStreamProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // ─── Custom App Bar ───
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: dashboardAsync.maybeWhen(
                      data: (data) => Text(
                        data.userName.isNotEmpty
                            ? data.userName[0].toUpperCase()
                            : 'U',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      orElse: () => const Icon(Icons.person, size: 16),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: dashboardAsync.maybeWhen(
                      data: (data) => Text(
                        'Welcome back, ${data.userName}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      orElse: () => Text(
                        'Welcome back',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),

            // Combine dashboard data with habits and content data
            dashboardAsync.when(
              data: (data) => habitsAsync.when(
                data: (habits) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                        // ─── Get first habit for today's mission ───
                        if (habits.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                            child: _buildMissionCard(theme, habits.first)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0, duration: 400.ms),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                            child: _buildEmptyMissionCard(theme)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1, end: 0, duration: 400.ms),
                          ),
                      
                        const SizedBox(height: AppSpacing.xl),
                        
                        // ─── AI Mentor Message ───
                        MentorMessageCard(
                        message: MentorMessage.generateMessage(
                          userName: data.userName,
                          streakDays: data.streakDays,
                          energyLevel: data.energyLevel,
                          completedHabits: habits.where((h) => h.completedToday).length,
                          totalHabits: habits.length,
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // ─── Quick Stats Row ───
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                        child: Row(
                          children: [
                            Expanded(
                              child: SafeStatCard(
                                title: 'Energy',
                                value: _calculateEnergyLevel(habits),
                                icon: Icons.bolt_rounded,
                                iconColor: _calculateEnergyLevel(habits).toLowerCase() == 'high' 
                                    ? AppColors.energyHigh 
                                    : theme.colorScheme.primary,
                              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: SafeStatCard(
                                title: 'Streak',
                                value: '${data.streakDays} Days',
                                icon: Icons.local_fire_department_rounded,
                                iconColor: data.streakDays > 0 
                                    ? AppColors.streakActive 
                                    : theme.colorScheme.onSurfaceVariant,
                              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // ─── Focus Timer Options Row ───
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                        child: Text(
                          'Focus Sessions',
                          style: theme.textTheme.titleLarge,
                        ).animate(delay: 300.ms).fadeIn(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      
                      // Two timer options side by side
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                        child: Row(
                          children: [
                            // Deep Work Focus - 25 min
                            Expanded(
                              child: _buildTimerCard(
                                theme,
                                config: TimerConfig.presets[0], // Deep Work
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const FocusTimerScreen(),
                                    ),
                                  );
                                },
                              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            // Start Mission - 50 min
                            Expanded(
                              child: _buildTimerCard(
                                theme,
                                config: TimerConfig.presets[1], // Start Mission
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const FocusTimerScreen(),
                                    ),
                                  );
                                },
                              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // ─── Today's Quote ───
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                        child: _buildQuoteCard(theme, data.dailyQuote.text)
                            .animate(delay: 500.ms)
                            .fadeIn()
                            .slideY(begin: 0.1),
                      ),
                      
                      // ─── Completed Habits Summary ───
                      if (habits.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                          child: Text(
                            "Today's Habits",
                            style: theme.textTheme.titleLarge,
                          ).animate(delay: 600.ms).fadeIn(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                          child: _buildHabitsSummary(theme, habits)
                              .animate(delay: 600.ms)
                              .fadeIn()
                              .slideY(begin: 0.1),
                        ),
                      ],
                        
                      const SizedBox(height: AppSpacing.xxxl), // Bottom padding
                    ]),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate energy level based on habits completed
  String _calculateEnergyLevel(List<Habit> habits) {
    if (habits.isEmpty) return 'Medium';
    
    final completedCount = habits.where((h) => h.completedToday).length;
    final totalCount = habits.length;
    final percentage = (completedCount / totalCount) * 100;
    
    if (percentage >= 80) return 'High';
    if (percentage >= 40) return 'Medium';
    return 'Low';
  }

  /// Build mission card from first habit
  Widget _buildMissionCard(ThemeData theme, Habit habit) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppShadows.primaryGlow(AppColors.primarySeed),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: Text(
                    "TODAY'S HABIT",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  habit.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              habit.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Streak: ${habit.currentStreak} days',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SafeButton(
              text: habit.completedToday ? 'Completed Today ✓' : 'Complete Habit',
              onPressed: () {
                Navigator.of(context).pushNamed('/habits');
              },
              type: habit.completedToday ? SafeButtonType.secondary : SafeButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty mission card when no habits
  Widget _buildEmptyMissionCard(ThemeData theme) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppShadows.primaryGlow(AppColors.primarySeed),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: Text(
                    'NO HABITS YET',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Icon(
                  Icons.flag_rounded,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Create Your First Habit',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start building better habits today and track your progress',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SafeButton(
              text: 'Create Habit',
              onPressed: () {
                Navigator.of(context).pushNamed('/habits');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build a timer card for focus sessions
  Widget _buildTimerCard(
    ThemeData theme, {
    required TimerConfig config,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and name
          Row(
            children: [
              Text(
                config.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      config.description,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Duration display
          Text(
            config.formattedDuration,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
          
          // XP reward
          Text(
            '+${config.xpReward} XP',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Play button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build quote card
  Widget _buildQuoteCard(ThemeData theme, String quoteText) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            size: AppSpacing.iconLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '"$quoteText"',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  /// Build habits summary
  Widget _buildHabitsSummary(ThemeData theme, List<Habit> habits) {
    final completedCount = habits.where((h) => h.completedToday).length;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount / ${habits.length} Completed',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${((completedCount / habits.length) * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completedCount / habits.length,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
