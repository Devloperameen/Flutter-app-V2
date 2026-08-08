// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyChallenge _$DailyChallengeFromJson(Map<String, dynamic> json) {
  return _DailyChallenge.fromJson(json);
}

/// @nodoc
mixin _$DailyChallenge {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // focus, habit, learning, productivity
  bool get isCompleted => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError; // 0-100 percentage
  int get targetValue => throw _privateConstructorUsedError;
  int get currentValue => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this DailyChallenge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyChallengeCopyWith<DailyChallenge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyChallengeCopyWith<$Res> {
  factory $DailyChallengeCopyWith(
    DailyChallenge value,
    $Res Function(DailyChallenge) then,
  ) = _$DailyChallengeCopyWithImpl<$Res, DailyChallenge>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String icon,
    int xpReward,
    String category,
    bool isCompleted,
    int progress,
    int targetValue,
    int currentValue,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$DailyChallengeCopyWithImpl<$Res, $Val extends DailyChallenge>
    implements $DailyChallengeCopyWith<$Res> {
  _$DailyChallengeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? xpReward = null,
    Object? category = null,
    Object? isCompleted = null,
    Object? progress = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? expiresAt = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            xpReward: null == xpReward
                ? _value.xpReward
                : xpReward // ignore: cast_nullable_to_non_nullable
                      as int,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as int,
            targetValue: null == targetValue
                ? _value.targetValue
                : targetValue // ignore: cast_nullable_to_non_nullable
                      as int,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as int,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyChallengeImplCopyWith<$Res>
    implements $DailyChallengeCopyWith<$Res> {
  factory _$$DailyChallengeImplCopyWith(
    _$DailyChallengeImpl value,
    $Res Function(_$DailyChallengeImpl) then,
  ) = __$$DailyChallengeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String icon,
    int xpReward,
    String category,
    bool isCompleted,
    int progress,
    int targetValue,
    int currentValue,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$$DailyChallengeImplCopyWithImpl<$Res>
    extends _$DailyChallengeCopyWithImpl<$Res, _$DailyChallengeImpl>
    implements _$$DailyChallengeImplCopyWith<$Res> {
  __$$DailyChallengeImplCopyWithImpl(
    _$DailyChallengeImpl _value,
    $Res Function(_$DailyChallengeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? xpReward = null,
    Object? category = null,
    Object? isCompleted = null,
    Object? progress = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$DailyChallengeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        xpReward: null == xpReward
            ? _value.xpReward
            : xpReward // ignore: cast_nullable_to_non_nullable
                  as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
        targetValue: null == targetValue
            ? _value.targetValue
            : targetValue // ignore: cast_nullable_to_non_nullable
                  as int,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as int,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyChallengeImpl implements _DailyChallenge {
  const _$DailyChallengeImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.category,
    this.isCompleted = false,
    this.progress = 0,
    required this.targetValue,
    required this.currentValue,
    required this.expiresAt,
  });

  factory _$DailyChallengeImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyChallengeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String icon;
  @override
  final int xpReward;
  @override
  final String category;
  // focus, habit, learning, productivity
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final int progress;
  // 0-100 percentage
  @override
  final int targetValue;
  @override
  final int currentValue;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'DailyChallenge(id: $id, title: $title, description: $description, icon: $icon, xpReward: $xpReward, category: $category, isCompleted: $isCompleted, progress: $progress, targetValue: $targetValue, currentValue: $currentValue, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyChallengeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    icon,
    xpReward,
    category,
    isCompleted,
    progress,
    targetValue,
    currentValue,
    expiresAt,
  );

  /// Create a copy of DailyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyChallengeImplCopyWith<_$DailyChallengeImpl> get copyWith =>
      __$$DailyChallengeImplCopyWithImpl<_$DailyChallengeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyChallengeImplToJson(this);
  }
}

abstract class _DailyChallenge implements DailyChallenge {
  const factory _DailyChallenge({
    required final String id,
    required final String title,
    required final String description,
    required final String icon,
    required final int xpReward,
    required final String category,
    final bool isCompleted,
    final int progress,
    required final int targetValue,
    required final int currentValue,
    required final DateTime expiresAt,
  }) = _$DailyChallengeImpl;

  factory _DailyChallenge.fromJson(Map<String, dynamic> json) =
      _$DailyChallengeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get icon;
  @override
  int get xpReward;
  @override
  String get category; // focus, habit, learning, productivity
  @override
  bool get isCompleted;
  @override
  int get progress; // 0-100 percentage
  @override
  int get targetValue;
  @override
  int get currentValue;
  @override
  DateTime get expiresAt;

  /// Create a copy of DailyChallenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyChallengeImplCopyWith<_$DailyChallengeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
