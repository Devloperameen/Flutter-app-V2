import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/analytics/domain/models/analytics_data.dart';
import 'package:safe/features/analytics/domain/models/analytics_period.dart';

part 'analytics_notifier.g.dart';

/// State for analytics dashboard
class AnalyticsState {

  const AnalyticsState({
    this.data,
    required this.isLoading,
    this.error,
    required this.selectedPeriod,
    this.selectedCategory,
    required this.isOffline,
  });
  final AnalyticsData? data;
  final bool isLoading;
  final String? error;
  final AnalyticsPeriod selectedPeriod;
  final String? selectedCategory;
  final bool isOffline;

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

@riverpod
class AnalyticsNotifier extends _$AnalyticsNotifier {
  @override
  AnalyticsState build() {
    return AnalyticsState(
      isLoading: true,
      selectedPeriod: AnalyticsPeriodType.week.toPeriod(),
      isOffline: false,
    );
  }

  /// Change the selected time period
  void setPeriod(AnalyticsPeriodType type) {
    final period = type.toPeriod();
    state = state.copyWith(
      selectedPeriod: period,
      isLoading: true,
    );
    // Fetch data for new period
    _fetchAnalytics();
  }

  /// Filter by category
  void setCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      isLoading: true,
    );
    _fetchAnalytics();
  }

  /// Set loading state
  void setLoading({required bool isLoading}) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set analytics data
  void setAnalyticsData(AnalyticsData data) {
    state = state.copyWith(
      data: data,
      isLoading: false,
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
  void setOffline({required bool isOffline}) {
    state = state.copyWith(isOffline: isOffline);
  }

  /// Fetch analytics data
  void _fetchAnalytics() {
    // TODO: Implement fetching from repository
    setLoading(isLoading: false);
  }

  /// Refresh analytics data
  Future<void> refresh() async {
    setLoading(isLoading: true);
    try {
      _fetchAnalytics();
    } catch (e) {
      setError(e.toString());
    }
  }
}
