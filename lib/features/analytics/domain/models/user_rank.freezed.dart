// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_rank.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserRank _$UserRankFromJson(Map<String, dynamic> json) {
  return _UserRank.fromJson(json);
}

/// @nodoc
mixin _$UserRank {
  int get rank => throw _privateConstructorUsedError;
  int get totalUsers => throw _privateConstructorUsedError;
  double get percentile => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get totalXp => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  int get focusHours => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;

  /// Serializes this UserRank to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRankCopyWith<UserRank> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRankCopyWith<$Res> {
  factory $UserRankCopyWith(UserRank value, $Res Function(UserRank) then) =
      _$UserRankCopyWithImpl<$Res, UserRank>;
  @useResult
  $Res call({
    int rank,
    int totalUsers,
    double percentile,
    int level,
    int totalXp,
    String userName,
    int focusHours,
    int streakDays,
  });
}

/// @nodoc
class _$UserRankCopyWithImpl<$Res, $Val extends UserRank>
    implements $UserRankCopyWith<$Res> {
  _$UserRankCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? totalUsers = null,
    Object? percentile = null,
    Object? level = null,
    Object? totalXp = null,
    Object? userName = null,
    Object? focusHours = null,
    Object? streakDays = null,
  }) {
    return _then(
      _value.copyWith(
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            totalUsers: null == totalUsers
                ? _value.totalUsers
                : totalUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            percentile: null == percentile
                ? _value.percentile
                : percentile // ignore: cast_nullable_to_non_nullable
                      as double,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            focusHours: null == focusHours
                ? _value.focusHours
                : focusHours // ignore: cast_nullable_to_non_nullable
                      as int,
            streakDays: null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRankImplCopyWith<$Res>
    implements $UserRankCopyWith<$Res> {
  factory _$$UserRankImplCopyWith(
    _$UserRankImpl value,
    $Res Function(_$UserRankImpl) then,
  ) = __$$UserRankImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int rank,
    int totalUsers,
    double percentile,
    int level,
    int totalXp,
    String userName,
    int focusHours,
    int streakDays,
  });
}

/// @nodoc
class __$$UserRankImplCopyWithImpl<$Res>
    extends _$UserRankCopyWithImpl<$Res, _$UserRankImpl>
    implements _$$UserRankImplCopyWith<$Res> {
  __$$UserRankImplCopyWithImpl(
    _$UserRankImpl _value,
    $Res Function(_$UserRankImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRank
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? totalUsers = null,
    Object? percentile = null,
    Object? level = null,
    Object? totalXp = null,
    Object? userName = null,
    Object? focusHours = null,
    Object? streakDays = null,
  }) {
    return _then(
      _$UserRankImpl(
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUsers: null == totalUsers
            ? _value.totalUsers
            : totalUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        percentile: null == percentile
            ? _value.percentile
            : percentile // ignore: cast_nullable_to_non_nullable
                  as double,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        focusHours: null == focusHours
            ? _value.focusHours
            : focusHours // ignore: cast_nullable_to_non_nullable
                  as int,
        streakDays: null == streakDays
            ? _value.streakDays
            : streakDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRankImpl implements _UserRank {
  const _$UserRankImpl({
    required this.rank,
    required this.totalUsers,
    required this.percentile,
    required this.level,
    required this.totalXp,
    required this.userName,
    required this.focusHours,
    required this.streakDays,
  });

  factory _$UserRankImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRankImplFromJson(json);

  @override
  final int rank;
  @override
  final int totalUsers;
  @override
  final double percentile;
  @override
  final int level;
  @override
  final int totalXp;
  @override
  final String userName;
  @override
  final int focusHours;
  @override
  final int streakDays;

  @override
  String toString() {
    return 'UserRank(rank: $rank, totalUsers: $totalUsers, percentile: $percentile, level: $level, totalXp: $totalXp, userName: $userName, focusHours: $focusHours, streakDays: $streakDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRankImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.percentile, percentile) ||
                other.percentile == percentile) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.focusHours, focusHours) ||
                other.focusHours == focusHours) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rank,
    totalUsers,
    percentile,
    level,
    totalXp,
    userName,
    focusHours,
    streakDays,
  );

  /// Create a copy of UserRank
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRankImplCopyWith<_$UserRankImpl> get copyWith =>
      __$$UserRankImplCopyWithImpl<_$UserRankImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRankImplToJson(this);
  }
}

abstract class _UserRank implements UserRank {
  const factory _UserRank({
    required final int rank,
    required final int totalUsers,
    required final double percentile,
    required final int level,
    required final int totalXp,
    required final String userName,
    required final int focusHours,
    required final int streakDays,
  }) = _$UserRankImpl;

  factory _UserRank.fromJson(Map<String, dynamic> json) =
      _$UserRankImpl.fromJson;

  @override
  int get rank;
  @override
  int get totalUsers;
  @override
  double get percentile;
  @override
  int get level;
  @override
  int get totalXp;
  @override
  String get userName;
  @override
  int get focusHours;
  @override
  int get streakDays;

  /// Create a copy of UserRank
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRankImplCopyWith<_$UserRankImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
