// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return _Habit.fromJson(json);
}

/// @nodoc
mixin _$Habit {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError; // Hex color code
  String get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get reminderEnabled => throw _privateConstructorUsedError;
  String? get reminderTime =>
      throw _privateConstructorUsedError; // HH:mm format
  int get targetMinutes =>
      throw _privateConstructorUsedError; // 0 if not time-based
  bool get completedToday => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get totalCompletions => throw _privateConstructorUsedError;
  DateTime? get lastCompletedDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCopyWith<Habit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) then) =
      _$HabitCopyWithImpl<$Res, Habit>;
  @useResult
  $Res call({
    String id,
    String title,
    String emoji,
    String color,
    String category,
    String? description,
    bool reminderEnabled,
    String? reminderTime,
    int targetMinutes,
    bool completedToday,
    int currentStreak,
    int longestStreak,
    int totalCompletions,
    DateTime? lastCompletedDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool archived,
    int order,
  });
}

/// @nodoc
class _$HabitCopyWithImpl<$Res, $Val extends Habit>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? emoji = null,
    Object? color = null,
    Object? category = null,
    Object? description = freezed,
    Object? reminderEnabled = null,
    Object? reminderTime = freezed,
    Object? targetMinutes = null,
    Object? completedToday = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalCompletions = null,
    Object? lastCompletedDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? archived = null,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderEnabled: null == reminderEnabled
                ? _value.reminderEnabled
                : reminderEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            reminderTime: freezed == reminderTime
                ? _value.reminderTime
                : reminderTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetMinutes: null == targetMinutes
                ? _value.targetMinutes
                : targetMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            completedToday: null == completedToday
                ? _value.completedToday
                : completedToday // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCompletions: null == totalCompletions
                ? _value.totalCompletions
                : totalCompletions // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCompletedDate: freezed == lastCompletedDate
                ? _value.lastCompletedDate
                : lastCompletedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            archived: null == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitImplCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$$HabitImplCopyWith(
    _$HabitImpl value,
    $Res Function(_$HabitImpl) then,
  ) = __$$HabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String emoji,
    String color,
    String category,
    String? description,
    bool reminderEnabled,
    String? reminderTime,
    int targetMinutes,
    bool completedToday,
    int currentStreak,
    int longestStreak,
    int totalCompletions,
    DateTime? lastCompletedDate,
    DateTime createdAt,
    DateTime updatedAt,
    bool archived,
    int order,
  });
}

/// @nodoc
class __$$HabitImplCopyWithImpl<$Res>
    extends _$HabitCopyWithImpl<$Res, _$HabitImpl>
    implements _$$HabitImplCopyWith<$Res> {
  __$$HabitImplCopyWithImpl(
    _$HabitImpl _value,
    $Res Function(_$HabitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? emoji = null,
    Object? color = null,
    Object? category = null,
    Object? description = freezed,
    Object? reminderEnabled = null,
    Object? reminderTime = freezed,
    Object? targetMinutes = null,
    Object? completedToday = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalCompletions = null,
    Object? lastCompletedDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? archived = null,
    Object? order = null,
  }) {
    return _then(
      _$HabitImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderEnabled: null == reminderEnabled
            ? _value.reminderEnabled
            : reminderEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        reminderTime: freezed == reminderTime
            ? _value.reminderTime
            : reminderTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetMinutes: null == targetMinutes
            ? _value.targetMinutes
            : targetMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        completedToday: null == completedToday
            ? _value.completedToday
            : completedToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCompletions: null == totalCompletions
            ? _value.totalCompletions
            : totalCompletions // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCompletedDate: freezed == lastCompletedDate
            ? _value.lastCompletedDate
            : lastCompletedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        archived: null == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitImpl implements _Habit {
  const _$HabitImpl({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.category,
    this.description,
    this.reminderEnabled = false,
    this.reminderTime,
    this.targetMinutes = 0,
    this.completedToday = false,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletions = 0,
    this.lastCompletedDate,
    required this.createdAt,
    required this.updatedAt,
    this.archived = false,
    this.order = 0,
  });

  factory _$HabitImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String emoji;
  @override
  final String color;
  // Hex color code
  @override
  final String category;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool reminderEnabled;
  @override
  final String? reminderTime;
  // HH:mm format
  @override
  @JsonKey()
  final int targetMinutes;
  // 0 if not time-based
  @override
  @JsonKey()
  final bool completedToday;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  @JsonKey()
  final int totalCompletions;
  @override
  final DateTime? lastCompletedDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool archived;
  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, emoji: $emoji, color: $color, category: $category, description: $description, reminderEnabled: $reminderEnabled, reminderTime: $reminderTime, targetMinutes: $targetMinutes, completedToday: $completedToday, currentStreak: $currentStreak, longestStreak: $longestStreak, totalCompletions: $totalCompletions, lastCompletedDate: $lastCompletedDate, createdAt: $createdAt, updatedAt: $updatedAt, archived: $archived, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.reminderEnabled, reminderEnabled) ||
                other.reminderEnabled == reminderEnabled) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            (identical(other.targetMinutes, targetMinutes) ||
                other.targetMinutes == targetMinutes) &&
            (identical(other.completedToday, completedToday) ||
                other.completedToday == completedToday) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.totalCompletions, totalCompletions) ||
                other.totalCompletions == totalCompletions) &&
            (identical(other.lastCompletedDate, lastCompletedDate) ||
                other.lastCompletedDate == lastCompletedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    emoji,
    color,
    category,
    description,
    reminderEnabled,
    reminderTime,
    targetMinutes,
    completedToday,
    currentStreak,
    longestStreak,
    totalCompletions,
    lastCompletedDate,
    createdAt,
    updatedAt,
    archived,
    order,
  );

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      __$$HabitImplCopyWithImpl<_$HabitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitImplToJson(this);
  }
}

abstract class _Habit implements Habit {
  const factory _Habit({
    required final String id,
    required final String title,
    required final String emoji,
    required final String color,
    required final String category,
    final String? description,
    final bool reminderEnabled,
    final String? reminderTime,
    final int targetMinutes,
    final bool completedToday,
    final int currentStreak,
    final int longestStreak,
    final int totalCompletions,
    final DateTime? lastCompletedDate,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool archived,
    final int order,
  }) = _$HabitImpl;

  factory _Habit.fromJson(Map<String, dynamic> json) = _$HabitImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get emoji;
  @override
  String get color; // Hex color code
  @override
  String get category;
  @override
  String? get description;
  @override
  bool get reminderEnabled;
  @override
  String? get reminderTime; // HH:mm format
  @override
  int get targetMinutes; // 0 if not time-based
  @override
  bool get completedToday;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  int get totalCompletions;
  @override
  DateTime? get lastCompletedDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get archived;
  @override
  int get order;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
