import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/analytics/domain/models/analytics_data.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';

part 'analytics_notifier.g.dart';

/// State for analytics dashboard
class AnalyticsState {
  final AnalyticsData? data;
  final bool isLoading;
  final String? error;
  final AnalyticsPeriod selectedPeriod;
  final String? selectedCategory;
  final bool isOffline;

  const AnalyticsState({
    this.data,
    required this.isLoading,
    this.error,
    required this.selectedPeriod,
    this.selectedCategory,
    required this.isOffline,
  });

  AnalyticsState copyWith({
    AnalyticsData? data,
    bool? isLoading,
    String? error,
    AnalyticsPeriod? selectedPeriod,
    String? selectedCategory,
    bool? isOffline,
  }) {
    return AnalyticsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Notifier for managing analytics state
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier()
      : super(
          AnalyticsState(
            isLoading: true,
            selectedPeriod: AnalyticsPeriodType.week.toPeriod(),
            isOffline: false,
          ),
        );

  /// Change the selected time period
  void setPeriod(AnalyticsPeriodType type) {
    final period = type.toPeriod();
    state = state.copyWith(
      selectedPeriod: period,
      isLoading: true,
      error: null,
    );
    // Fetch data for new period
    _fetchAnalytics();
  }

  /// Filter by category
  void setCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      isLoading: true,
      error: null,
    );
    _fetchAnalytics();
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set analytics data
  void setAnalyticsData(AnalyticsData data) {
    state = state.copyWith(
      data: data,
      isLoading: false,
      error: null,
    );
  }

  /// Set error
  void setError(String error) {
    state = state.copyWith(
      error: error,
      isLoading: false,
    );
  }

  /// Set offline status
  void setOffline(bool isOffline) {
    state = state.copyWith(isOffline: isOffline);
  }

  /// Fetch analytics data
  void _fetchAnalytics() {
    // TODO: Implement fetching from repository
    setLoading(false);
  }

  /// Refresh analytics data
  Future<void> refresh() async {
    setLoading(true);
    try {
      _fetchAnalytics();
    } catch (e) {
      setError(e.toString());
    }
  }
}

@riverpod
StateNotifier<AnalyticsState> analyticsNotifier(AnalyticsNotifierRef ref) {
  return AnalyticsNotifier();
}

@riverpod
AnalyticsState analytics(AnalyticsRef ref) {
  return ref.watch(analyticsNotifierProvider);
}
