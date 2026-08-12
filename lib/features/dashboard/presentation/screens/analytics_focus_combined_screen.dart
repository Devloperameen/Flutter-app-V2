import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/analytics/presentation/screens/analytics_dashboard_screen.dart';
import 'package:safe/features/focus_timer/presentation/screens/focus_timer_screen.dart';

/// Combined Analytics & Focus Timer Screen
/// Displays both features in a tabbed interface within one bottom nav item
class AnalyticsFocusCombinedScreen extends ConsumerStatefulWidget {
  const AnalyticsFocusCombinedScreen({super.key});

  @override
  ConsumerState<AnalyticsFocusCombinedScreen> createState() =>
      _AnalyticsFocusCombinedScreenState();
}

class _AnalyticsFocusCombinedScreenState
    extends ConsumerState<AnalyticsFocusCombinedScreen>
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
      appBar: AppBar(
        title: const Text('Focus & Analytics'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.timer_outlined),
              text: 'Focus Timer',
            ),
            Tab(
              icon: Icon(Icons.analytics_outlined),
              text: 'Analytics',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Focus Timer Tab
          const FocusTimerScreen(),
          // Analytics Tab
          const AnalyticsDashboardScreen(),
        ],
      ),
    );
  }
}
