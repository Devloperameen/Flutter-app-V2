// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitsStreamHash() => r'b90fec00b8c6c8d12b454524bcf5fdbe0b5cc37c';

/// Stream all habits for the current user
/// Rebuilds UI automatically when Firestore data changes
/// NO manual refresh needed, NO optimistic updates
///
/// Copied from [habitsStream].
@ProviderFor(habitsStream)
final habitsStreamProvider = AutoDisposeStreamProvider<List<Habit>>.internal(
  habitsStream,
  name: r'habitsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$habitsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitsStreamRef = AutoDisposeStreamProviderRef<List<Habit>>;
String _$completionPercentageHash() =>
    r'86d157e8a665836e6f857440120e15470d205126';

/// Get total completion percentage
///
/// Copied from [completionPercentage].
@ProviderFor(completionPercentage)
final completionPercentageProvider = AutoDisposeFutureProvider<double>.internal(
  completionPercentage,
  name: r'completionPercentageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completionPercentageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletionPercentageRef = AutoDisposeFutureProviderRef<double>;
String _$totalCurrentStreakHash() =>
    r'e4bdf79a4863345e24a35dcdc29356c17a26e144';

/// Get total current streak sum
///
/// Copied from [totalCurrentStreak].
@ProviderFor(totalCurrentStreak)
final totalCurrentStreakProvider = AutoDisposeProvider<int>.internal(
  totalCurrentStreak,
  name: r'totalCurrentStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalCurrentStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalCurrentStreakRef = AutoDisposeProviderRef<int>;
String _$totalLongestStreakHash() =>
    r'ef9cc61d7b38295ccd2620bc8fd41fe0b6a79afd';

/// Get total longest streak sum
///
/// Copied from [totalLongestStreak].
@ProviderFor(totalLongestStreak)
final totalLongestStreakProvider = AutoDisposeProvider<int>.internal(
  totalLongestStreak,
  name: r'totalLongestStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalLongestStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalLongestStreakRef = AutoDisposeProviderRef<int>;
String _$completedHabitsTodayHash() =>
    r'55701d60bb66fc55ad2730a0019eddbefd440f50';

/// Get habits completed today
///
/// Copied from [completedHabitsToday].
@ProviderFor(completedHabitsToday)
final completedHabitsTodayProvider = AutoDisposeProvider<List<Habit>>.internal(
  completedHabitsToday,
  name: r'completedHabitsTodayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedHabitsTodayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedHabitsTodayRef = AutoDisposeProviderRef<List<Habit>>;
String _$pendingHabitsTodayHash() =>
    r'd3af51e4e4cc55ff2a34cdeb54ca627b89a63a4f';

/// Get habits not completed today
///
/// Copied from [pendingHabitsToday].
@ProviderFor(pendingHabitsToday)
final pendingHabitsTodayProvider = AutoDisposeProvider<List<Habit>>.internal(
  pendingHabitsToday,
  name: r'pendingHabitsTodayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingHabitsTodayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingHabitsTodayRef = AutoDisposeProviderRef<List<Habit>>;
String _$activeHabitsHash() => r'56e8d7784d9fa3c548a6768fe6eff1b998096940';

/// Get non-archived habits
///
/// Copied from [activeHabits].
@ProviderFor(activeHabits)
final activeHabitsProvider = AutoDisposeProvider<List<Habit>>.internal(
  activeHabits,
  name: r'activeHabitsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeHabitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveHabitsRef = AutoDisposeProviderRef<List<Habit>>;
String _$archivedHabitsHash() => r'36738a9e4e87328871145a267ef5da0e6b7ea341';

/// Get archived habits
///
/// Copied from [archivedHabits].
@ProviderFor(archivedHabits)
final archivedHabitsProvider = AutoDisposeProvider<List<Habit>>.internal(
  archivedHabits,
  name: r'archivedHabitsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$archivedHabitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArchivedHabitsRef = AutoDisposeProviderRef<List<Habit>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
