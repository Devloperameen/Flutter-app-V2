// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FocusSession _$FocusSessionFromJson(Map<String, dynamic> json) {
  return _FocusSession.fromJson(json);
}

/// @nodoc
mixin _$FocusSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int get durationSeconds =>
      throw _privateConstructorUsedError; // Target duration (usually 1500 for 25 min)
  int get completedSeconds =>
      throw _privateConstructorUsedError; // How much was actually completed
  String get status =>
      throw _privateConstructorUsedError; // 'active', 'paused', 'completed', 'abandoned'
  String get sessionType =>
      throw _privateConstructorUsedError; // 'focus', 'break', 'long_break'
  String? get missionTitle => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FocusSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusSessionCopyWith<FocusSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusSessionCopyWith<$Res> {
  factory $FocusSessionCopyWith(
    FocusSession value,
    $Res Function(FocusSession) then,
  ) = _$FocusSessionCopyWithImpl<$Res, FocusSession>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startedAt,
    DateTime? endedAt,
    int durationSeconds,
    int completedSeconds,
    String status,
    String sessionType,
    String? missionTitle,
    int xpReward,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$FocusSessionCopyWithImpl<$Res, $Val extends FocusSession>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? durationSeconds = null,
    Object? completedSeconds = null,
    Object? status = null,
    Object? sessionType = null,
    Object? missionTitle = freezed,
    Object? xpReward = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            completedSeconds: null == completedSeconds
                ? _value.completedSeconds
                : completedSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionType: null == sessionType
                ? _value.sessionType
                : sessionType // ignore: cast_nullable_to_non_nullable
                      as String,
            missionTitle: freezed == missionTitle
                ? _value.missionTitle
                : missionTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            xpReward: null == xpReward
                ? _value.xpReward
                : xpReward // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FocusSessionImplCopyWith<$Res>
    implements $FocusSessionCopyWith<$Res> {
  factory _$$FocusSessionImplCopyWith(
    _$FocusSessionImpl value,
    $Res Function(_$FocusSessionImpl) then,
  ) = __$$FocusSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startedAt,
    DateTime? endedAt,
    int durationSeconds,
    int completedSeconds,
    String status,
    String sessionType,
    String? missionTitle,
    int xpReward,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$FocusSessionImplCopyWithImpl<$Res>
    extends _$FocusSessionCopyWithImpl<$Res, _$FocusSessionImpl>
    implements _$$FocusSessionImplCopyWith<$Res> {
  __$$FocusSessionImplCopyWithImpl(
    _$FocusSessionImpl _value,
    $Res Function(_$FocusSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? durationSeconds = null,
    Object? completedSeconds = null,
    Object? status = null,
    Object? sessionType = null,
    Object? missionTitle = freezed,
    Object? xpReward = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$FocusSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        completedSeconds: null == completedSeconds
            ? _value.completedSeconds
            : completedSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionType: null == sessionType
            ? _value.sessionType
            : sessionType // ignore: cast_nullable_to_non_nullable
                  as String,
        missionTitle: freezed == missionTitle
            ? _value.missionTitle
            : missionTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        xpReward: null == xpReward
            ? _value.xpReward
            : xpReward // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusSessionImpl implements _FocusSession {
  const _$FocusSessionImpl({
    required this.id,
    required this.userId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.completedSeconds,
    required this.status,
    required this.sessionType,
    required this.missionTitle,
    required this.xpReward,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$FocusSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  final int durationSeconds;
  // Target duration (usually 1500 for 25 min)
  @override
  final int completedSeconds;
  // How much was actually completed
  @override
  final String status;
  // 'active', 'paused', 'completed', 'abandoned'
  @override
  final String sessionType;
  // 'focus', 'break', 'long_break'
  @override
  final String? missionTitle;
  @override
  final int xpReward;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FocusSession(id: $id, userId: $userId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, completedSeconds: $completedSeconds, status: $status, sessionType: $sessionType, missionTitle: $missionTitle, xpReward: $xpReward, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.completedSeconds, completedSeconds) ||
                other.completedSeconds == completedSeconds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.missionTitle, missionTitle) ||
                other.missionTitle == missionTitle) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    startedAt,
    endedAt,
    durationSeconds,
    completedSeconds,
    status,
    sessionType,
    missionTitle,
    xpReward,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      __$$FocusSessionImplCopyWithImpl<_$FocusSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusSessionImplToJson(this);
  }
}

abstract class _FocusSession implements FocusSession {
  const factory _FocusSession({
    required final String id,
    required final String userId,
    required final DateTime startedAt,
    required final DateTime? endedAt,
    required final int durationSeconds,
    required final int completedSeconds,
    required final String status,
    required final String sessionType,
    required final String? missionTitle,
    required final int xpReward,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$FocusSessionImpl;

  factory _FocusSession.fromJson(Map<String, dynamic> json) =
      _$FocusSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;
  @override
  int get durationSeconds; // Target duration (usually 1500 for 25 min)
  @override
  int get completedSeconds; // How much was actually completed
  @override
  String get status; // 'active', 'paused', 'completed', 'abandoned'
  @override
  String get sessionType; // 'focus', 'break', 'long_break'
  @override
  String? get missionTitle;
  @override
  int get xpReward;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of FocusSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimerState _$TimerStateFromJson(Map<String, dynamic> json) {
  return _TimerState.fromJson(json);
}

/// @nodoc
mixin _$TimerState {
  int get secondsRemaining => throw _privateConstructorUsedError;
  int get totalSeconds => throw _privateConstructorUsedError;
  bool get isRunning => throw _privateConstructorUsedError;
  bool get isPaused => throw _privateConstructorUsedError;
  String get currentPhase =>
      throw _privateConstructorUsedError; // 'focus', 'break', 'long_break'
  int get cycleCount => throw _privateConstructorUsedError;

  /// Serializes this TimerState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimerStateCopyWith<TimerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerStateCopyWith<$Res> {
  factory $TimerStateCopyWith(
    TimerState value,
    $Res Function(TimerState) then,
  ) = _$TimerStateCopyWithImpl<$Res, TimerState>;
  @useResult
  $Res call({
    int secondsRemaining,
    int totalSeconds,
    bool isRunning,
    bool isPaused,
    String currentPhase,
    int cycleCount,
  });
}

/// @nodoc
class _$TimerStateCopyWithImpl<$Res, $Val extends TimerState>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? secondsRemaining = null,
    Object? totalSeconds = null,
    Object? isRunning = null,
    Object? isPaused = null,
    Object? currentPhase = null,
    Object? cycleCount = null,
  }) {
    return _then(
      _value.copyWith(
            secondsRemaining: null == secondsRemaining
                ? _value.secondsRemaining
                : secondsRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSeconds: null == totalSeconds
                ? _value.totalSeconds
                : totalSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            isRunning: null == isRunning
                ? _value.isRunning
                : isRunning // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPaused: null == isPaused
                ? _value.isPaused
                : isPaused // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentPhase: null == currentPhase
                ? _value.currentPhase
                : currentPhase // ignore: cast_nullable_to_non_nullable
                      as String,
            cycleCount: null == cycleCount
                ? _value.cycleCount
                : cycleCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimerStateImplCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory _$$TimerStateImplCopyWith(
    _$TimerStateImpl value,
    $Res Function(_$TimerStateImpl) then,
  ) = __$$TimerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int secondsRemaining,
    int totalSeconds,
    bool isRunning,
    bool isPaused,
    String currentPhase,
    int cycleCount,
  });
}

/// @nodoc
class __$$TimerStateImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerStateImpl>
    implements _$$TimerStateImplCopyWith<$Res> {
  __$$TimerStateImplCopyWithImpl(
    _$TimerStateImpl _value,
    $Res Function(_$TimerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? secondsRemaining = null,
    Object? totalSeconds = null,
    Object? isRunning = null,
    Object? isPaused = null,
    Object? currentPhase = null,
    Object? cycleCount = null,
  }) {
    return _then(
      _$TimerStateImpl(
        secondsRemaining: null == secondsRemaining
            ? _value.secondsRemaining
            : secondsRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSeconds: null == totalSeconds
            ? _value.totalSeconds
            : totalSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        isRunning: null == isRunning
            ? _value.isRunning
            : isRunning // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaused: null == isPaused
            ? _value.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentPhase: null == currentPhase
            ? _value.currentPhase
            : currentPhase // ignore: cast_nullable_to_non_nullable
                  as String,
        cycleCount: null == cycleCount
            ? _value.cycleCount
            : cycleCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerStateImpl implements _TimerState {
  const _$TimerStateImpl({
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.currentPhase,
    required this.cycleCount,
  });

  factory _$TimerStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerStateImplFromJson(json);

  @override
  final int secondsRemaining;
  @override
  final int totalSeconds;
  @override
  final bool isRunning;
  @override
  final bool isPaused;
  @override
  final String currentPhase;
  // 'focus', 'break', 'long_break'
  @override
  final int cycleCount;

  @override
  String toString() {
    return 'TimerState(secondsRemaining: $secondsRemaining, totalSeconds: $totalSeconds, isRunning: $isRunning, isPaused: $isPaused, currentPhase: $currentPhase, cycleCount: $cycleCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerStateImpl &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining) &&
            (identical(other.totalSeconds, totalSeconds) ||
                other.totalSeconds == totalSeconds) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            (identical(other.cycleCount, cycleCount) ||
                other.cycleCount == cycleCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    secondsRemaining,
    totalSeconds,
    isRunning,
    isPaused,
    currentPhase,
    cycleCount,
  );

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerStateImplCopyWith<_$TimerStateImpl> get copyWith =>
      __$$TimerStateImplCopyWithImpl<_$TimerStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerStateImplToJson(this);
  }
}

abstract class _TimerState implements TimerState {
  const factory _TimerState({
    required final int secondsRemaining,
    required final int totalSeconds,
    required final bool isRunning,
    required final bool isPaused,
    required final String currentPhase,
    required final int cycleCount,
  }) = _$TimerStateImpl;

  factory _TimerState.fromJson(Map<String, dynamic> json) =
      _$TimerStateImpl.fromJson;

  @override
  int get secondsRemaining;
  @override
  int get totalSeconds;
  @override
  bool get isRunning;
  @override
  bool get isPaused;
  @override
  String get currentPhase; // 'focus', 'break', 'long_break'
  @override
  int get cycleCount;

  /// Create a copy of TimerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerStateImplCopyWith<_$TimerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
