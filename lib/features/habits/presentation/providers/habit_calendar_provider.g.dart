// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitCompletionsHash() => r'71fbd7b4869d96fb664db10cb6722b42bd9beb41';

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

/// Provider for getting completion history of a habit
/// Returns list of dates when habit was completed
///
/// Copied from [habitCompletions].
@ProviderFor(habitCompletions)
const habitCompletionsProvider = HabitCompletionsFamily();

/// Provider for getting completion history of a habit
/// Returns list of dates when habit was completed
///
/// Copied from [habitCompletions].
class HabitCompletionsFamily extends Family<AsyncValue<List<DateTime>>> {
  /// Provider for getting completion history of a habit
  /// Returns list of dates when habit was completed
  ///
  /// Copied from [habitCompletions].
  const HabitCompletionsFamily();

  /// Provider for getting completion history of a habit
  /// Returns list of dates when habit was completed
  ///
  /// Copied from [habitCompletions].
  HabitCompletionsProvider call(String habitId) {
    return HabitCompletionsProvider(habitId);
  }

  @override
  HabitCompletionsProvider getProviderOverride(
    covariant HabitCompletionsProvider provider,
  ) {
    return call(provider.habitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'habitCompletionsProvider';
}

/// Provider for getting completion history of a habit
/// Returns list of dates when habit was completed
///
/// Copied from [habitCompletions].
class HabitCompletionsProvider
    extends AutoDisposeFutureProvider<List<DateTime>> {
  /// Provider for getting completion history of a habit
  /// Returns list of dates when habit was completed
  ///
  /// Copied from [habitCompletions].
  HabitCompletionsProvider(String habitId)
    : this._internal(
        (ref) => habitCompletions(ref as HabitCompletionsRef, habitId),
        from: habitCompletionsProvider,
        name: r'habitCompletionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$habitCompletionsHash,
        dependencies: HabitCompletionsFamily._dependencies,
        allTransitiveDependencies:
            HabitCompletionsFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  HabitCompletionsProvider._internal(
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
    FutureOr<List<DateTime>> Function(HabitCompletionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HabitCompletionsProvider._internal(
        (ref) => create(ref as HabitCompletionsRef),
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
  AutoDisposeFutureProviderElement<List<DateTime>> createElement() {
    return _HabitCompletionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitCompletionsProvider && other.habitId == habitId;
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
mixin HabitCompletionsRef on AutoDisposeFutureProviderRef<List<DateTime>> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _HabitCompletionsProviderElement
    extends AutoDisposeFutureProviderElement<List<DateTime>>
    with HabitCompletionsRef {
  _HabitCompletionsProviderElement(super.provider);

  @override
  String get habitId => (origin as HabitCompletionsProvider).habitId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
