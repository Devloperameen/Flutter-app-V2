// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsHash() => r'c456c534f5d08e917a3c98be1de42c66fa5348e1';

/// Main analytics state provider
///
/// Copied from [analytics].
@ProviderFor(analytics)
final analyticsProvider = AutoDisposeProvider<AnalyticsState>.internal(
  analytics,
  name: r'analyticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsRef = AutoDisposeProviderRef<AnalyticsState>;
String _$habitAnalyticsHash() => r'b654fadd7fe4f727977994bece606c870275987e';

/// Habit analytics provider with real-time updates
///
/// Copied from [habitAnalytics].
@ProviderFor(habitAnalytics)
final habitAnalyticsProvider =
    AutoDisposeFutureProvider<HabitAnalytics>.internal(
      habitAnalytics,
      name: r'habitAnalyticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$habitAnalyticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitAnalyticsRef = AutoDisposeFutureProviderRef<HabitAnalytics>;
String _$selectedPeriodLabelHash() =>
    r'45d97f1b88a15815ecf913eee4a49816b4e0d753';

/// Get selected period label
///
/// Copied from [selectedPeriodLabel].
@ProviderFor(selectedPeriodLabel)
final selectedPeriodLabelProvider = AutoDisposeProvider<String>.internal(
  selectedPeriodLabel,
  name: r'selectedPeriodLabelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPeriodLabelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedPeriodLabelRef = AutoDisposeProviderRef<String>;
String _$availableCategoriesHash() =>
    r'14db9222d0c67bdc9477d3e2efb4c7f98021d5ce';

/// Get filtered categories
///
/// Copied from [availableCategories].
@ProviderFor(availableCategories)
final availableCategoriesProvider = AutoDisposeProvider<List<String>>.internal(
  availableCategories,
  name: r'availableCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCategoriesRef = AutoDisposeProviderRef<List<String>>;
String _$isAnalyticsEmptyHash() => r'2e9b20382fdcc8ad828c173399f287844846a897';

/// Check if analytics data is empty
///
/// Copied from [isAnalyticsEmpty].
@ProviderFor(isAnalyticsEmpty)
final isAnalyticsEmptyProvider = AutoDisposeProvider<bool>.internal(
  isAnalyticsEmpty,
  name: r'isAnalyticsEmptyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAnalyticsEmptyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAnalyticsEmptyRef = AutoDisposeProviderRef<bool>;
String _$periodComparisonHash() => r'b136de1766bb6184b8a9e5f4f1034d3fd753fd1a';

/// Get comparison with previous period
///
/// Copied from [periodComparison].
@ProviderFor(periodComparison)
final periodComparisonProvider =
    AutoDisposeFutureProvider<AnalyticsComparison>.internal(
      periodComparison,
      name: r'periodComparisonProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$periodComparisonHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PeriodComparisonRef = AutoDisposeFutureProviderRef<AnalyticsComparison>;
String _$percentageChangeHash() => r'575c78f198c3fdfbc3e2c1e92f47b2ed0414d8f0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Calculate percentage change between periods
///
/// Copied from [percentageChange].
@ProviderFor(percentageChange)
const percentageChangeProvider = PercentageChangeFamily();

/// Calculate percentage change between periods
///
/// Copied from [percentageChange].
class PercentageChangeFamily extends Family<double> {
  /// Calculate percentage change between periods
  ///
  /// Copied from [percentageChange].
  const PercentageChangeFamily();

  /// Calculate percentage change between periods
  ///
  /// Copied from [percentageChange].
  PercentageChangeProvider call({required int current, required int previous}) {
    return PercentageChangeProvider(current: current, previous: previous);
  }

  @override
  PercentageChangeProvider getProviderOverride(
    covariant PercentageChangeProvider provider,
  ) {
    return call(current: provider.current, previous: provider.previous);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'percentageChangeProvider';
}

/// Calculate percentage change between periods
///
/// Copied from [percentageChange].
class PercentageChangeProvider extends AutoDisposeProvider<double> {
  /// Calculate percentage change between periods
  ///
  /// Copied from [percentageChange].
  PercentageChangeProvider({required int current, required int previous})
    : this._internal(
        (ref) => percentageChange(
          ref as PercentageChangeRef,
          current: current,
          previous: previous,
        ),
        from: percentageChangeProvider,
        name: r'percentageChangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$percentageChangeHash,
        dependencies: PercentageChangeFamily._dependencies,
        allTransitiveDependencies:
            PercentageChangeFamily._allTransitiveDependencies,
        current: current,
        previous: previous,
      );

  PercentageChangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.current,
    required this.previous,
  }) : super.internal();

  final int current;
  final int previous;

  @override
  Override overrideWith(double Function(PercentageChangeRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: PercentageChangeProvider._internal(
        (ref) => create(ref as PercentageChangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        current: current,
        previous: previous,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _PercentageChangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PercentageChangeProvider &&
        other.current == current &&
        other.previous == previous;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, current.hashCode);
    hash = _SystemHash.combine(hash, previous.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PercentageChangeRef on AutoDisposeProviderRef<double> {
  /// The parameter `current` of this provider.
  int get current;

  /// The parameter `previous` of this provider.
  int get previous;
}

class _PercentageChangeProviderElement
    extends AutoDisposeProviderElement<double>
    with PercentageChangeRef {
  _PercentageChangeProviderElement(super.provider);

  @override
  int get current => (origin as PercentageChangeProvider).current;
  @override
  int get previous => (origin as PercentageChangeProvider).previous;
}

String _$habitPerformanceHash() => r'a3ce3d351a27094309f2e9c7ad6f24cb9605fcd9';

/// Get analytics state for a specific habit
///
/// Copied from [habitPerformance].
@ProviderFor(habitPerformance)
const habitPerformanceProvider = HabitPerformanceFamily();

/// Get analytics state for a specific habit
///
/// Copied from [habitPerformance].
class HabitPerformanceFamily extends Family<AsyncValue<HabitPerformance?>> {
  /// Get analytics state for a specific habit
  ///
  /// Copied from [habitPerformance].
  const HabitPerformanceFamily();

  /// Get analytics state for a specific habit
  ///
  /// Copied from [habitPerformance].
  HabitPerformanceProvider call({required String habitId}) {
    return HabitPerformanceProvider(habitId: habitId);
  }

  @override
  HabitPerformanceProvider getProviderOverride(
    covariant HabitPerformanceProvider provider,
  ) {
    return call(habitId: provider.habitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'habitPerformanceProvider';
}

/// Get analytics state for a specific habit
///
/// Copied from [habitPerformance].
class HabitPerformanceProvider
    extends AutoDisposeFutureProvider<HabitPerformance?> {
  /// Get analytics state for a specific habit
  ///
  /// Copied from [habitPerformance].
  HabitPerformanceProvider({required String habitId})
    : this._internal(
        (ref) => habitPerformance(ref as HabitPerformanceRef, habitId: habitId),
        from: habitPerformanceProvider,
        name: r'habitPerformanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$habitPerformanceHash,
        dependencies: HabitPerformanceFamily._dependencies,
        allTransitiveDependencies:
            HabitPerformanceFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  HabitPerformanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitId,
  }) : super.internal();

  final String habitId;

  @override
  Override overrideWith(
    FutureOr<HabitPerformance?> Function(HabitPerformanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HabitPerformanceProvider._internal(
        (ref) => create(ref as HabitPerformanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitId: habitId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HabitPerformance?> createElement() {
    return _HabitPerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitPerformanceProvider && other.habitId == habitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HabitPerformanceRef on AutoDisposeFutureProviderRef<HabitPerformance?> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _HabitPerformanceProviderElement
    extends AutoDisposeFutureProviderElement<HabitPerformance?>
    with HabitPerformanceRef {
  _HabitPerformanceProviderElement(super.provider);

  @override
  String get habitId => (origin as HabitPerformanceProvider).habitId;
}

String _$analyticsInsightsHash() => r'a79ddcffec41064e5ffeba740cfed5bf6acfba75';

/// Get analytics insights as a stream
///
/// Copied from [analyticsInsights].
@ProviderFor(analyticsInsights)
final analyticsInsightsProvider =
    AutoDisposeStreamProvider<List<String>>.internal(
      analyticsInsights,
      name: r'analyticsInsightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsInsightsRef = AutoDisposeStreamProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
