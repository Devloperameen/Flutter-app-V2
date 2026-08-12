import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/analytics/presentation/screens/analytics_dashboard_screen.dart';

/// Analytics Only Screen
/// Displays analytics data without Focus Timer tab
class AnalyticsFocusCombinedScreen extends ConsumerWidget {
  const AnalyticsFocusCombinedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Removed Focus Timer tab - showing only Analytics
    return const AnalyticsDashboardScreen();
  }
}
