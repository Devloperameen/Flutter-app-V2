// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FocusAnalytics _$FocusAnalyticsFromJson(Map<String, dynamic> json) {
  return _FocusAnalytics.fromJson(json);
}

/// @nodoc
mixin _$FocusAnalytics {
  int get totalSessions => throw _privateConstructorUsedError;
  int get completedSessions => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  int get completedMinutes => throw _privateConstructorUsedError;
  int get totalXpEarned => throw _privateConstructorUsedError;
  double get averageSessionMinutes => throw _privateConstructorUsedError;
  int get longestSessionMinutes => throw _privateConstructorUsedError;
  Map<String, int> get sessionsByType =>
      throw _privateConstructorUsedError; // sessionType -> count
  Map<String, int> get minutesByType =>
      throw _privateConstructorUsedError; // sessionType -> minutes
  List<DailyFocusData> get dailyData => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;

  /// Serializes this FocusAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusAnalyticsCopyWith<FocusAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusAnalyticsCopyWith<$Res> {
  factory $FocusAnalyticsCopyWith(
    FocusAnalytics value,
    $Res Function(FocusAnalytics) then,
  ) = _$FocusAnalyticsCopyWithImpl<$Res, FocusAnalytics>;
  @useResult
  $Res call({
    int totalSessions,
    int completedSessions,
    int totalMinutes,
    int completedMinutes,
    int totalXpEarned,
    double averageSessionMinutes,
    int longestSessionMinutes,
    Map<String, int> sessionsByType,
    Map<String, int> minutesByType,
    List<DailyFocusData> dailyData,
    int longestStreak,
  });
}

/// @nodoc
class _$FocusAnalyticsCopyWithImpl<$Res, $Val extends FocusAnalytics>
    implements $FocusAnalyticsCopyWith<$Res> {
  _$FocusAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? completedSessions = null,
    Object? totalMinutes = null,
    Object? completedMinutes = null,
    Object? totalXpEarned = null,
    Object? averageSessionMinutes = null,
    Object? longestSessionMinutes = null,
    Object? sessionsByType = null,
    Object? minutesByType = null,
    Object? dailyData = null,
    Object? longestStreak = null,
  }) {
    return _then(
      _value.copyWith(
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            completedSessions: null == completedSessions
                ? _value.completedSessions
                : completedSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMinutes: null == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            completedMinutes: null == completedMinutes
                ? _value.completedMinutes
                : completedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalXpEarned: null == totalXpEarned
                ? _value.totalXpEarned
                : totalXpEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            averageSessionMinutes: null == averageSessionMinutes
                ? _value.averageSessionMinutes
                : averageSessionMinutes // ignore: cast_nullable_to_non_nullable
                      as double,
            longestSessionMinutes: null == longestSessionMinutes
                ? _value.longestSessionMinutes
                : longestSessionMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsByType: null == sessionsByType
                ? _value.sessionsByType
                : sessionsByType // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            minutesByType: null == minutesByType
                ? _value.minutesByType
                : minutesByType // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            dailyData: null == dailyData
                ? _value.dailyData
                : dailyData // ignore: cast_nullable_to_non_nullable
                      as List<DailyFocusData>,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FocusAnalyticsImplCopyWith<$Res>
    implements $FocusAnalyticsCopyWith<$Res> {
  factory _$$FocusAnalyticsImplCopyWith(
    _$FocusAnalyticsImpl value,
    $Res Function(_$FocusAnalyticsImpl) then,
  ) = __$$FocusAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalSessions,
    int completedSessions,
    int totalMinutes,
    int completedMinutes,
    int totalXpEarned,
    double averageSessionMinutes,
    int longestSessionMinutes,
    Map<String, int> sessionsByType,
    Map<String, int> minutesByType,
    List<DailyFocusData> dailyData,
    int longestStreak,
  });
}

/// @nodoc
class __$$FocusAnalyticsImplCopyWithImpl<$Res>
    extends _$FocusAnalyticsCopyWithImpl<$Res, _$FocusAnalyticsImpl>
    implements _$$FocusAnalyticsImplCopyWith<$Res> {
  __$$FocusAnalyticsImplCopyWithImpl(
    _$FocusAnalyticsImpl _value,
    $Res Function(_$FocusAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FocusAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSessions = null,
    Object? completedSessions = null,
    Object? totalMinutes = null,
    Object? completedMinutes = null,
    Object? totalXpEarned = null,
    Object? averageSessionMinutes = null,
    Object? longestSessionMinutes = null,
    Object? sessionsByType = null,
    Object? minutesByType = null,
    Object? dailyData = null,
    Object? longestStreak = null,
  }) {
    return _then(
      _$FocusAnalyticsImpl(
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        completedSessions: null == completedSessions
            ? _value.completedSessions
            : completedSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMinutes: null == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        completedMinutes: null == completedMinutes
            ? _value.completedMinutes
            : completedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalXpEarned: null == totalXpEarned
            ? _value.totalXpEarned
            : totalXpEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        averageSessionMinutes: null == averageSessionMinutes
            ? _value.averageSessionMinutes
            : averageSessionMinutes // ignore: cast_nullable_to_non_nullable
                  as double,
        longestSessionMinutes: null == longestSessionMinutes
            ? _value.longestSessionMinutes
            : longestSessionMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsByType: null == sessionsByType
            ? _value._sessionsByType
            : sessionsByType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        minutesByType: null == minutesByType
            ? _value._minutesByType
            : minutesByType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        dailyData: null == dailyData
            ? _value._dailyData
            : dailyData // ignore: cast_nullable_to_non_nullable
                  as List<DailyFocusData>,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusAnalyticsImpl implements _FocusAnalytics {
  const _$FocusAnalyticsImpl({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalMinutes,
    required this.completedMinutes,
    required this.totalXpEarned,
    required this.averageSessionMinutes,
    required this.longestSessionMinutes,
    required final Map<String, int> sessionsByType,
    required final Map<String, int> minutesByType,
    required final List<DailyFocusData> dailyData,
    required this.longestStreak,
  }) : _sessionsByType = sessionsByType,
       _minutesByType = minutesByType,
       _dailyData = dailyData;

  factory _$FocusAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusAnalyticsImplFromJson(json);

  @override
  final int totalSessions;
  @override
  final int completedSessions;
  @override
  final int totalMinutes;
  @override
  final int completedMinutes;
  @override
  final int totalXpEarned;
  @override
  final double averageSessionMinutes;
  @override
  final int longestSessionMinutes;
  final Map<String, int> _sessionsByType;
  @override
  Map<String, int> get sessionsByType {
    if (_sessionsByType is EqualUnmodifiableMapView) return _sessionsByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sessionsByType);
  }

  // sessionType -> count
  final Map<String, int> _minutesByType;
  // sessionType -> count
  @override
  Map<String, int> get minutesByType {
    if (_minutesByType is EqualUnmodifiableMapView) return _minutesByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_minutesByType);
  }

  // sessionType -> minutes
  final List<DailyFocusData> _dailyData;
  // sessionType -> minutes
  @override
  List<DailyFocusData> get dailyData {
    if (_dailyData is EqualUnmodifiableListView) return _dailyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyData);
  }

  @override
  final int longestStreak;

  @override
  String toString() {
    return 'FocusAnalytics(totalSessions: $totalSessions, completedSessions: $completedSessions, totalMinutes: $totalMinutes, completedMinutes: $completedMinutes, totalXpEarned: $totalXpEarned, averageSessionMinutes: $averageSessionMinutes, longestSessionMinutes: $longestSessionMinutes, sessionsByType: $sessionsByType, minutesByType: $minutesByType, dailyData: $dailyData, longestStreak: $longestStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusAnalyticsImpl &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.completedSessions, completedSessions) ||
                other.completedSessions == completedSessions) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.completedMinutes, completedMinutes) ||
                other.completedMinutes == completedMinutes) &&
            (identical(other.totalXpEarned, totalXpEarned) ||
                other.totalXpEarned == totalXpEarned) &&
            (identical(other.averageSessionMinutes, averageSessionMinutes) ||
                other.averageSessionMinutes == averageSessionMinutes) &&
            (identical(other.longestSessionMinutes, longestSessionMinutes) ||
                other.longestSessionMinutes == longestSessionMinutes) &&
            const DeepCollectionEquality().equals(
              other._sessionsByType,
              _sessionsByType,
            ) &&
            const DeepCollectionEquality().equals(
              other._minutesByType,
              _minutesByType,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailyData,
              _dailyData,
            ) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalSessions,
    completedSessions,
    totalMinutes,
    completedMinutes,
    totalXpEarned,
    averageSessionMinutes,
    longestSessionMinutes,
    const DeepCollectionEquality().hash(_sessionsByType),
    const DeepCollectionEquality().hash(_minutesByType),
    const DeepCollectionEquality().hash(_dailyData),
    longestStreak,
  );

  /// Create a copy of FocusAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusAnalyticsImplCopyWith<_$FocusAnalyticsImpl> get copyWith =>
      __$$FocusAnalyticsImplCopyWithImpl<_$FocusAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusAnalyticsImplToJson(this);
  }
}

abstract class _FocusAnalytics implements FocusAnalytics {
  const factory _FocusAnalytics({
    required final int totalSessions,
    required final int completedSessions,
    required final int totalMinutes,
    required final int completedMinutes,
    required final int totalXpEarned,
    required final double averageSessionMinutes,
    required final int longestSessionMinutes,
    required final Map<String, int> sessionsByType,
    required final Map<String, int> minutesByType,
    required final List<DailyFocusData> dailyData,
    required final int longestStreak,
  }) = _$FocusAnalyticsImpl;

  factory _FocusAnalytics.fromJson(Map<String, dynamic> json) =
      _$FocusAnalyticsImpl.fromJson;

  @override
  int get totalSessions;
  @override
  int get completedSessions;
  @override
  int get totalMinutes;
  @override
  int get completedMinutes;
  @override
  int get totalXpEarned;
  @override
  double get averageSessionMinutes;
  @override
  int get longestSessionMinutes;
  @override
  Map<String, int> get sessionsByType; // sessionType -> count
  @override
  Map<String, int> get minutesByType; // sessionType -> minutes
  @override
  List<DailyFocusData> get dailyData;
  @override
  int get longestStreak;

  /// Create a copy of FocusAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusAnalyticsImplCopyWith<_$FocusAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyFocusData _$DailyFocusDataFromJson(Map<String, dynamic> json) {
  return _DailyFocusData.fromJson(json);
}

/// @nodoc
mixin _$DailyFocusData {
  DateTime get date => throw _privateConstructorUsedError;
  int get sessions => throw _privateConstructorUsedError;
  int get minutes => throw _privateConstructorUsedError;
  int get xpEarned => throw _privateConstructorUsedError;

  /// Serializes this DailyFocusData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyFocusData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyFocusDataCopyWith<DailyFocusData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyFocusDataCopyWith<$Res> {
  factory $DailyFocusDataCopyWith(
    DailyFocusData value,
    $Res Function(DailyFocusData) then,
  ) = _$DailyFocusDataCopyWithImpl<$Res, DailyFocusData>;
  @useResult
  $Res call({DateTime date, int sessions, int minutes, int xpEarned});
}

/// @nodoc
class _$DailyFocusDataCopyWithImpl<$Res, $Val extends DailyFocusData>
    implements $DailyFocusDataCopyWith<$Res> {
  _$DailyFocusDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyFocusData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? sessions = null,
    Object? minutes = null,
    Object? xpEarned = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sessions: null == sessions
                ? _value.sessions
                : sessions // ignore: cast_nullable_to_non_nullable
                      as int,
            minutes: null == minutes
                ? _value.minutes
                : minutes // ignore: cast_nullable_to_non_nullable
                      as int,
            xpEarned: null == xpEarned
                ? _value.xpEarned
                : xpEarned // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyFocusDataImplCopyWith<$Res>
    implements $DailyFocusDataCopyWith<$Res> {
  factory _$$DailyFocusDataImplCopyWith(
    _$DailyFocusDataImpl value,
    $Res Function(_$DailyFocusDataImpl) then,
  ) = __$$DailyFocusDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int sessions, int minutes, int xpEarned});
}

/// @nodoc
class __$$DailyFocusDataImplCopyWithImpl<$Res>
    extends _$DailyFocusDataCopyWithImpl<$Res, _$DailyFocusDataImpl>
    implements _$$DailyFocusDataImplCopyWith<$Res> {
  __$$DailyFocusDataImplCopyWithImpl(
    _$DailyFocusDataImpl _value,
    $Res Function(_$DailyFocusDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyFocusData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? sessions = null,
    Object? minutes = null,
    Object? xpEarned = null,
  }) {
    return _then(
      _$DailyFocusDataImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sessions: null == sessions
            ? _value.sessions
            : sessions // ignore: cast_nullable_to_non_nullable
                  as int,
        minutes: null == minutes
            ? _value.minutes
            : minutes // ignore: cast_nullable_to_non_nullable
                  as int,
        xpEarned: null == xpEarned
            ? _value.xpEarned
            : xpEarned // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyFocusDataImpl implements _DailyFocusData {
  const _$DailyFocusDataImpl({
    required this.date,
    required this.sessions,
    required this.minutes,
    required this.xpEarned,
  });

  factory _$DailyFocusDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyFocusDataImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int sessions;
  @override
  final int minutes;
  @override
  final int xpEarned;

  @override
  String toString() {
    return 'DailyFocusData(date: $date, sessions: $sessions, minutes: $minutes, xpEarned: $xpEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyFocusDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.sessions, sessions) ||
                other.sessions == sessions) &&
            (identical(other.minutes, minutes) || other.minutes == minutes) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, sessions, minutes, xpEarned);

  /// Create a copy of DailyFocusData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyFocusDataImplCopyWith<_$DailyFocusDataImpl> get copyWith =>
      __$$DailyFocusDataImplCopyWithImpl<_$DailyFocusDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyFocusDataImplToJson(this);
  }
}

abstract class _DailyFocusData implements DailyFocusData {
  const factory _DailyFocusData({
    required final DateTime date,
    required final int sessions,
    required final int minutes,
    required final int xpEarned,
  }) = _$DailyFocusDataImpl;

  factory _DailyFocusData.fromJson(Map<String, dynamic> json) =
      _$DailyFocusDataImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get sessions;
  @override
  int get minutes;
  @override
  int get xpEarned;

  /// Create a copy of DailyFocusData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyFocusDataImplCopyWith<_$DailyFocusDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
