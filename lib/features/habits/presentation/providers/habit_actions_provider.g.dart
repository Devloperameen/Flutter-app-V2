// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createHabitActionHash() => r'dcccad12fbcb1b8c401d5787c6b82bd7890902c1';

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

/// Provider for creating a new habit
///
/// Copied from [createHabitAction].
@ProviderFor(createHabitAction)
const createHabitActionProvider = CreateHabitActionFamily();

/// Provider for creating a new habit
///
/// Copied from [createHabitAction].
class CreateHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for creating a new habit
  ///
  /// Copied from [createHabitAction].
  const CreateHabitActionFamily();

  /// Provider for creating a new habit
  ///
  /// Copied from [createHabitAction].
  CreateHabitActionProvider call({
    required String title,
    required String emoji,
    required String color,
    required String category,
    String? description,
    bool reminderEnabled = false,
    String? reminderTime,
    int targetMinutes = 0,
  }) {
    return CreateHabitActionProvider(
      title: title,
      emoji: emoji,
      color: color,
      category: category,
      description: description,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      targetMinutes: targetMinutes,
    );
  }

  @override
  CreateHabitActionProvider getProviderOverride(
    covariant CreateHabitActionProvider provider,
  ) {
    return call(
      title: provider.title,
      emoji: provider.emoji,
      color: provider.color,
      category: provider.category,
      description: provider.description,
      reminderEnabled: provider.reminderEnabled,
      reminderTime: provider.reminderTime,
      targetMinutes: provider.targetMinutes,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createHabitActionProvider';
}

/// Provider for creating a new habit
///
/// Copied from [createHabitAction].
class CreateHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for creating a new habit
  ///
  /// Copied from [createHabitAction].
  CreateHabitActionProvider({
    required String title,
    required String emoji,
    required String color,
    required String category,
    String? description,
    bool reminderEnabled = false,
    String? reminderTime,
    int targetMinutes = 0,
  }) : this._internal(
         (ref) => createHabitAction(
           ref as CreateHabitActionRef,
           title: title,
           emoji: emoji,
           color: color,
           category: category,
           description: description,
           reminderEnabled: reminderEnabled,
           reminderTime: reminderTime,
           targetMinutes: targetMinutes,
         ),
         from: createHabitActionProvider,
         name: r'createHabitActionProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$createHabitActionHash,
         dependencies: CreateHabitActionFamily._dependencies,
         allTransitiveDependencies:
             CreateHabitActionFamily._allTransitiveDependencies,
         title: title,
         emoji: emoji,
         color: color,
         category: category,
         description: description,
         reminderEnabled: reminderEnabled,
         reminderTime: reminderTime,
         targetMinutes: targetMinutes,
       );

  CreateHabitActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.emoji,
    required this.color,
    required this.category,
    required this.description,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.targetMinutes,
  }) : super.internal();

  final String title;
  final String emoji;
  final String color;
  final String category;
  final String? description;
  final bool reminderEnabled;
  final String? reminderTime;
  final int targetMinutes;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateHabitActionProvider._internal(
        (ref) => create(ref as CreateHabitActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        emoji: emoji,
        color: color,
        category: category,
        description: description,
        reminderEnabled: reminderEnabled,
        reminderTime: reminderTime,
        targetMinutes: targetMinutes,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateHabitActionProvider &&
        other.title == title &&
        other.emoji == emoji &&
        other.color == color &&
        other.category == category &&
        other.description == description &&
        other.reminderEnabled == reminderEnabled &&
        other.reminderTime == reminderTime &&
        other.targetMinutes == targetMinutes;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, emoji.hashCode);
    hash = _SystemHash.combine(hash, color.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, description.hashCode);
    hash = _SystemHash.combine(hash, reminderEnabled.hashCode);
    hash = _SystemHash.combine(hash, reminderTime.hashCode);
    hash = _SystemHash.combine(hash, targetMinutes.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `emoji` of this provider.
  String get emoji;

  /// The parameter `color` of this provider.
  String get color;

  /// The parameter `category` of this provider.
  String get category;

  /// The parameter `description` of this provider.
  String? get description;

  /// The parameter `reminderEnabled` of this provider.
  bool get reminderEnabled;

  /// The parameter `reminderTime` of this provider.
  String? get reminderTime;

  /// The parameter `targetMinutes` of this provider.
  int get targetMinutes;
}

class _CreateHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CreateHabitActionRef {
  _CreateHabitActionProviderElement(super.provider);

  @override
  String get title => (origin as CreateHabitActionProvider).title;
  @override
  String get emoji => (origin as CreateHabitActionProvider).emoji;
  @override
  String get color => (origin as CreateHabitActionProvider).color;
  @override
  String get category => (origin as CreateHabitActionProvider).category;
  @override
  String? get description => (origin as CreateHabitActionProvider).description;
  @override
  bool get reminderEnabled =>
      (origin as CreateHabitActionProvider).reminderEnabled;
  @override
  String? get reminderTime =>
      (origin as CreateHabitActionProvider).reminderTime;
  @override
  int get targetMinutes => (origin as CreateHabitActionProvider).targetMinutes;
}

String _$completeHabitActionHash() =>
    r'8370d037bd90a52909652bbf8f2150b633007bb1';

/// Provider for completing a habit
///
/// Copied from [completeHabitAction].
@ProviderFor(completeHabitAction)
const completeHabitActionProvider = CompleteHabitActionFamily();

/// Provider for completing a habit
///
/// Copied from [completeHabitAction].
class CompleteHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for completing a habit
  ///
  /// Copied from [completeHabitAction].
  const CompleteHabitActionFamily();

  /// Provider for completing a habit
  ///
  /// Copied from [completeHabitAction].
  CompleteHabitActionProvider call(String habitId) {
    return CompleteHabitActionProvider(habitId);
  }

  @override
  CompleteHabitActionProvider getProviderOverride(
    covariant CompleteHabitActionProvider provider,
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
  String? get name => r'completeHabitActionProvider';
}

/// Provider for completing a habit
///
/// Copied from [completeHabitAction].
class CompleteHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for completing a habit
  ///
  /// Copied from [completeHabitAction].
  CompleteHabitActionProvider(String habitId)
    : this._internal(
        (ref) => completeHabitAction(ref as CompleteHabitActionRef, habitId),
        from: completeHabitActionProvider,
        name: r'completeHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$completeHabitActionHash,
        dependencies: CompleteHabitActionFamily._dependencies,
        allTransitiveDependencies:
            CompleteHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  CompleteHabitActionProvider._internal(
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
    FutureOr<void> Function(CompleteHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompleteHabitActionProvider._internal(
        (ref) => create(ref as CompleteHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CompleteHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompleteHabitActionProvider && other.habitId == habitId;
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
mixin CompleteHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _CompleteHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CompleteHabitActionRef {
  _CompleteHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as CompleteHabitActionProvider).habitId;
}

String _$undoHabitActionHash() => r'47b4481196027083c0a074e9cd21c14fa7c60ed2';

/// Provider for undoing habit completion
///
/// Copied from [undoHabitAction].
@ProviderFor(undoHabitAction)
const undoHabitActionProvider = UndoHabitActionFamily();

/// Provider for undoing habit completion
///
/// Copied from [undoHabitAction].
class UndoHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for undoing habit completion
  ///
  /// Copied from [undoHabitAction].
  const UndoHabitActionFamily();

  /// Provider for undoing habit completion
  ///
  /// Copied from [undoHabitAction].
  UndoHabitActionProvider call(String habitId) {
    return UndoHabitActionProvider(habitId);
  }

  @override
  UndoHabitActionProvider getProviderOverride(
    covariant UndoHabitActionProvider provider,
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
  String? get name => r'undoHabitActionProvider';
}

/// Provider for undoing habit completion
///
/// Copied from [undoHabitAction].
class UndoHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for undoing habit completion
  ///
  /// Copied from [undoHabitAction].
  UndoHabitActionProvider(String habitId)
    : this._internal(
        (ref) => undoHabitAction(ref as UndoHabitActionRef, habitId),
        from: undoHabitActionProvider,
        name: r'undoHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$undoHabitActionHash,
        dependencies: UndoHabitActionFamily._dependencies,
        allTransitiveDependencies:
            UndoHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  UndoHabitActionProvider._internal(
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
    FutureOr<void> Function(UndoHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UndoHabitActionProvider._internal(
        (ref) => create(ref as UndoHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UndoHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UndoHabitActionProvider && other.habitId == habitId;
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
mixin UndoHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _UndoHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UndoHabitActionRef {
  _UndoHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as UndoHabitActionProvider).habitId;
}

String _$deleteHabitActionHash() => r'de7bdf919926b49b41aeece07056db969369eb90';

/// Provider for deleting a habit
///
/// Copied from [deleteHabitAction].
@ProviderFor(deleteHabitAction)
const deleteHabitActionProvider = DeleteHabitActionFamily();

/// Provider for deleting a habit
///
/// Copied from [deleteHabitAction].
class DeleteHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for deleting a habit
  ///
  /// Copied from [deleteHabitAction].
  const DeleteHabitActionFamily();

  /// Provider for deleting a habit
  ///
  /// Copied from [deleteHabitAction].
  DeleteHabitActionProvider call(String habitId) {
    return DeleteHabitActionProvider(habitId);
  }

  @override
  DeleteHabitActionProvider getProviderOverride(
    covariant DeleteHabitActionProvider provider,
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
  String? get name => r'deleteHabitActionProvider';
}

/// Provider for deleting a habit
///
/// Copied from [deleteHabitAction].
class DeleteHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for deleting a habit
  ///
  /// Copied from [deleteHabitAction].
  DeleteHabitActionProvider(String habitId)
    : this._internal(
        (ref) => deleteHabitAction(ref as DeleteHabitActionRef, habitId),
        from: deleteHabitActionProvider,
        name: r'deleteHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteHabitActionHash,
        dependencies: DeleteHabitActionFamily._dependencies,
        allTransitiveDependencies:
            DeleteHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  DeleteHabitActionProvider._internal(
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
    FutureOr<void> Function(DeleteHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteHabitActionProvider._internal(
        (ref) => create(ref as DeleteHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteHabitActionProvider && other.habitId == habitId;
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
mixin DeleteHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _DeleteHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DeleteHabitActionRef {
  _DeleteHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as DeleteHabitActionProvider).habitId;
}

String _$archiveHabitActionHash() =>
    r'22c4d6af716046e42573b18ebe480cb31a2f32cb';

/// Provider for archiving a habit
///
/// Copied from [archiveHabitAction].
@ProviderFor(archiveHabitAction)
const archiveHabitActionProvider = ArchiveHabitActionFamily();

/// Provider for archiving a habit
///
/// Copied from [archiveHabitAction].
class ArchiveHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for archiving a habit
  ///
  /// Copied from [archiveHabitAction].
  const ArchiveHabitActionFamily();

  /// Provider for archiving a habit
  ///
  /// Copied from [archiveHabitAction].
  ArchiveHabitActionProvider call(String habitId) {
    return ArchiveHabitActionProvider(habitId);
  }

  @override
  ArchiveHabitActionProvider getProviderOverride(
    covariant ArchiveHabitActionProvider provider,
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
  String? get name => r'archiveHabitActionProvider';
}

/// Provider for archiving a habit
///
/// Copied from [archiveHabitAction].
class ArchiveHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for archiving a habit
  ///
  /// Copied from [archiveHabitAction].
  ArchiveHabitActionProvider(String habitId)
    : this._internal(
        (ref) => archiveHabitAction(ref as ArchiveHabitActionRef, habitId),
        from: archiveHabitActionProvider,
        name: r'archiveHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$archiveHabitActionHash,
        dependencies: ArchiveHabitActionFamily._dependencies,
        allTransitiveDependencies:
            ArchiveHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  ArchiveHabitActionProvider._internal(
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
    FutureOr<void> Function(ArchiveHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArchiveHabitActionProvider._internal(
        (ref) => create(ref as ArchiveHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ArchiveHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveHabitActionProvider && other.habitId == habitId;
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
mixin ArchiveHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _ArchiveHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with ArchiveHabitActionRef {
  _ArchiveHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as ArchiveHabitActionProvider).habitId;
}

String _$restoreHabitActionHash() =>
    r'7d31ec3bd6ea48d14f8c98eace1735542d800634';

/// Provider for restoring a habit
///
/// Copied from [restoreHabitAction].
@ProviderFor(restoreHabitAction)
const restoreHabitActionProvider = RestoreHabitActionFamily();

/// Provider for restoring a habit
///
/// Copied from [restoreHabitAction].
class RestoreHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for restoring a habit
  ///
  /// Copied from [restoreHabitAction].
  const RestoreHabitActionFamily();

  /// Provider for restoring a habit
  ///
  /// Copied from [restoreHabitAction].
  RestoreHabitActionProvider call(String habitId) {
    return RestoreHabitActionProvider(habitId);
  }

  @override
  RestoreHabitActionProvider getProviderOverride(
    covariant RestoreHabitActionProvider provider,
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
  String? get name => r'restoreHabitActionProvider';
}

/// Provider for restoring a habit
///
/// Copied from [restoreHabitAction].
class RestoreHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for restoring a habit
  ///
  /// Copied from [restoreHabitAction].
  RestoreHabitActionProvider(String habitId)
    : this._internal(
        (ref) => restoreHabitAction(ref as RestoreHabitActionRef, habitId),
        from: restoreHabitActionProvider,
        name: r'restoreHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$restoreHabitActionHash,
        dependencies: RestoreHabitActionFamily._dependencies,
        allTransitiveDependencies:
            RestoreHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  RestoreHabitActionProvider._internal(
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
    FutureOr<void> Function(RestoreHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreHabitActionProvider._internal(
        (ref) => create(ref as RestoreHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RestoreHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreHabitActionProvider && other.habitId == habitId;
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
mixin RestoreHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _RestoreHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RestoreHabitActionRef {
  _RestoreHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as RestoreHabitActionProvider).habitId;
}

String _$duplicateHabitActionHash() =>
    r'd39a1c27e7ba4f529abb610c646bdfb076c84a5b';

/// Provider for duplicating a habit
///
/// Copied from [duplicateHabitAction].
@ProviderFor(duplicateHabitAction)
const duplicateHabitActionProvider = DuplicateHabitActionFamily();

/// Provider for duplicating a habit
///
/// Copied from [duplicateHabitAction].
class DuplicateHabitActionFamily extends Family<AsyncValue<void>> {
  /// Provider for duplicating a habit
  ///
  /// Copied from [duplicateHabitAction].
  const DuplicateHabitActionFamily();

  /// Provider for duplicating a habit
  ///
  /// Copied from [duplicateHabitAction].
  DuplicateHabitActionProvider call(String habitId) {
    return DuplicateHabitActionProvider(habitId);
  }

  @override
  DuplicateHabitActionProvider getProviderOverride(
    covariant DuplicateHabitActionProvider provider,
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
  String? get name => r'duplicateHabitActionProvider';
}

/// Provider for duplicating a habit
///
/// Copied from [duplicateHabitAction].
class DuplicateHabitActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for duplicating a habit
  ///
  /// Copied from [duplicateHabitAction].
  DuplicateHabitActionProvider(String habitId)
    : this._internal(
        (ref) => duplicateHabitAction(ref as DuplicateHabitActionRef, habitId),
        from: duplicateHabitActionProvider,
        name: r'duplicateHabitActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$duplicateHabitActionHash,
        dependencies: DuplicateHabitActionFamily._dependencies,
        allTransitiveDependencies:
            DuplicateHabitActionFamily._allTransitiveDependencies,
        habitId: habitId,
      );

  DuplicateHabitActionProvider._internal(
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
    FutureOr<void> Function(DuplicateHabitActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DuplicateHabitActionProvider._internal(
        (ref) => create(ref as DuplicateHabitActionRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DuplicateHabitActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DuplicateHabitActionProvider && other.habitId == habitId;
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
mixin DuplicateHabitActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _DuplicateHabitActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DuplicateHabitActionRef {
  _DuplicateHabitActionProviderElement(super.provider);

  @override
  String get habitId => (origin as DuplicateHabitActionProvider).habitId;
}

String _$reorderHabitsActionHash() =>
    r'018b0706a778ba232f415c709fa33a6013980209';

/// Provider for reordering habits
///
/// Copied from [reorderHabitsAction].
@ProviderFor(reorderHabitsAction)
const reorderHabitsActionProvider = ReorderHabitsActionFamily();

/// Provider for reordering habits
///
/// Copied from [reorderHabitsAction].
class ReorderHabitsActionFamily extends Family<AsyncValue<void>> {
  /// Provider for reordering habits
  ///
  /// Copied from [reorderHabitsAction].
  const ReorderHabitsActionFamily();

  /// Provider for reordering habits
  ///
  /// Copied from [reorderHabitsAction].
  ReorderHabitsActionProvider call(List<String> habitIds) {
    return ReorderHabitsActionProvider(habitIds);
  }

  @override
  ReorderHabitsActionProvider getProviderOverride(
    covariant ReorderHabitsActionProvider provider,
  ) {
    return call(provider.habitIds);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reorderHabitsActionProvider';
}

/// Provider for reordering habits
///
/// Copied from [reorderHabitsAction].
class ReorderHabitsActionProvider extends AutoDisposeFutureProvider<void> {
  /// Provider for reordering habits
  ///
  /// Copied from [reorderHabitsAction].
  ReorderHabitsActionProvider(List<String> habitIds)
    : this._internal(
        (ref) => reorderHabitsAction(ref as ReorderHabitsActionRef, habitIds),
        from: reorderHabitsActionProvider,
        name: r'reorderHabitsActionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$reorderHabitsActionHash,
        dependencies: ReorderHabitsActionFamily._dependencies,
        allTransitiveDependencies:
            ReorderHabitsActionFamily._allTransitiveDependencies,
        habitIds: habitIds,
      );

  ReorderHabitsActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitIds,
  }) : super.internal();

  final List<String> habitIds;

  @override
  Override overrideWith(
    FutureOr<void> Function(ReorderHabitsActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReorderHabitsActionProvider._internal(
        (ref) => create(ref as ReorderHabitsActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitIds: habitIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ReorderHabitsActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReorderHabitsActionProvider && other.habitIds == habitIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReorderHabitsActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `habitIds` of this provider.
  List<String> get habitIds;
}

class _ReorderHabitsActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with ReorderHabitsActionRef {
  _ReorderHabitsActionProviderElement(super.provider);

  @override
  List<String> get habitIds => (origin as ReorderHabitsActionProvider).habitIds;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
