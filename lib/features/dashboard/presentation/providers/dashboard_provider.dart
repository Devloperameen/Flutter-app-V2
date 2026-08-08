import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:safe/features/dashboard/domain/models/dashboard_data.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  FutureOr<DashboardData> build() async {
    log.i('📊 DashboardNotifier.build() called');
    try {
      final data = await _fetchDashboardData();
      log.i('✅ Dashboard data loaded successfully');
      return data;
    } catch (e, st) {
      log.e('❌ Dashboard loading failed: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<DashboardData> _fetchDashboardData() async {
    final repository = ref.read(dashboardRepositoryProvider);
    return repository.getDashboardData();
  }

  Future<void> refresh() async {
    log.i('🔄 Dashboard refresh triggered');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
}
