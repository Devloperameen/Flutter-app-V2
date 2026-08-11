import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/router/route_names.dart';

/// SAFE — Dashboard Shell
///
/// The persistent navigation shell that wraps all main tabs.
/// Uses Material 3 NavigationBar with 5 destinations.
///
/// This widget receives a [child] from GoRouter's ShellRoute
/// and displays it above the bottom navigation bar.
///
/// Architecture note:
/// The shell persists across tab switches, maintaining each tab's
/// scroll position and state. The child widget changes based on
/// the current route.
class DashboardShell extends StatelessWidget {
  const DashboardShell({
    required this.child,
    super.key,
  });

  final Widget child;

  // Map route paths to their tab indices
  static const _tabs = [
    RoutePaths.dashboard,
    RoutePaths.habits,
    RoutePaths.analyticsFocus,  // Combined Analytics & Focus
    RoutePaths.community,
    RoutePaths.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    final currentIndex = _currentIndex(context);
    if (index == currentIndex) return; // Don't re-navigate to current tab

    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex(context),
          onDestinationSelected: (index) => _onTabTapped(context, index),
          height: AppSpacing.bottomNavHeight,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.track_changes_outlined),
              selectedIcon: Icon(Icons.track_changes_rounded),
              label: 'Habits',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline_rounded),
              selectedIcon: Icon(Icons.people_rounded),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
