import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/core/design/design.dart';

/// Simplified Dashboard for Project Submission
/// Shows static "About App" content instead of Firebase data
class DashboardScreenSimple extends ConsumerWidget {
  const DashboardScreenSimple({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'FitFlow Gym',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  
                  // Hero Section
                  _buildHeroCard(theme),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // About Section
                  _buildAboutSection(theme),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Features Section
                  _buildFeaturesSection(theme),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Tech Stack
                  _buildTechStackSection(theme),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Footer
                  _buildFooter(theme),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme) {
    return Container(
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
            Icons.fitness_center_rounded,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Transform Your Fitness Journey',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track habits, stay focused, and connect with the community',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About FitFlow Gym',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'FitFlow Gym is a comprehensive fitness tracking application designed to help you achieve your fitness goals through habit formation, focus sessions, and community support.',
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Built with Flutter and Firebase, this app combines modern UI/UX design with powerful backend capabilities to deliver a seamless fitness tracking experience.',
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(ThemeData theme) {
    final features = [
      {
        'icon': Icons.calendar_today_rounded,
        'title': 'Habit Tracking',
        'description': 'Create and monitor daily fitness habits with streaks and progress visualization',
        'color': const Color(0xFFFF006E),
      },
      {
        'icon': Icons.timer_rounded,
        'title': 'Focus Timer',
        'description': 'Pomodoro-style timer to stay focused during workouts and training sessions',
        'color': const Color(0xFF8338EC),
      },
      {
        'icon': Icons.chat_rounded,
        'title': 'Community Chat',
        'description': 'Connect with other fitness enthusiasts, share progress, and stay motivated',
        'color': const Color(0xFF3A86FF),
      },
      {
        'icon': Icons.person_rounded,
        'title': 'User Profile',
        'description': 'Track your fitness journey with XP, levels, and personal achievements',
        'color': const Color(0xFFFB5607),
      },
      {
        'icon': Icons.security_rounded,
        'title': 'Secure Authentication',
        'description': 'Firebase Authentication ensures your data is safe and secure',
        'color': const Color(0xFF06FFA5),
      },
      {
        'icon': Icons.dark_mode_rounded,
        'title': 'Dark Mode',
        'description': 'Beautiful dark and light themes for comfortable viewing anytime',
        'color': const Color(0xFFFFBE0B),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildFeatureCard(
            theme,
            feature['icon'] as IconData,
            feature['title'] as String,
            feature['description'] as String,
            feature['color'] as Color,
          ),
        )),
      ],
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackSection(ThemeData theme) {
    final techStack = [
      {'name': 'Flutter', 'icon': Icons.phone_android_rounded},
      {'name': 'Firebase', 'icon': Icons.cloud_rounded},
      {'name': 'Riverpod', 'icon': Icons.account_tree_rounded},
      {'name': 'Clean Architecture', 'icon': Icons.architecture_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technology Stack',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: techStack.map((tech) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tech['icon'] as IconData,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  tech['name'] as String,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Built with ❤️ for Fitness Enthusiasts',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 FitFlow Gym. All rights reserved.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
