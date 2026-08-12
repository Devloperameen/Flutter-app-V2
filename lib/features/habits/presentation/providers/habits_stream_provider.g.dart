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
    r'91a6457b8464e51c3d415b08faad9dbde169c77e';

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
    r'e63902dcdfd0bf6f0d8d81dad9f77a93bd024158';

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
    r'7851be122d18d74023b99c4774c6b35665d160ef';

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
    r'afcd94905510da543532c59cb02f22216ef5b479';

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
String _$activeHabitsHash() => r'ad35e1dc0c0d1bfd51bf4f0660be23c10ffbeb3c';

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
String _$archivedHabitsHash() => r'7c9e2253c398c39043516cb21c5a1a8f79d02346';

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
