// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsPeriod _$AnalyticsPeriodFromJson(Map<String, dynamic> json) {
  return _AnalyticsPeriod.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsPeriod {
  AnalyticsPeriodType get type => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsPeriodCopyWith<AnalyticsPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsPeriodCopyWith<$Res> {
  factory $AnalyticsPeriodCopyWith(
    AnalyticsPeriod value,
    $Res Function(AnalyticsPeriod) then,
  ) = _$AnalyticsPeriodCopyWithImpl<$Res, AnalyticsPeriod>;
  @useResult
  $Res call({AnalyticsPeriodType type, DateTime startDate, DateTime endDate});
}

/// @nodoc
class _$AnalyticsPeriodCopyWithImpl<$Res, $Val extends AnalyticsPeriod>
    implements $AnalyticsPeriodCopyWith<$Res> {
  _$AnalyticsPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AnalyticsPeriodType,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsPeriodImplCopyWith<$Res>
    implements $AnalyticsPeriodCopyWith<$Res> {
  factory _$$AnalyticsPeriodImplCopyWith(
    _$AnalyticsPeriodImpl value,
    $Res Function(_$AnalyticsPeriodImpl) then,
  ) = __$$AnalyticsPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AnalyticsPeriodType type, DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$$AnalyticsPeriodImplCopyWithImpl<$Res>
    extends _$AnalyticsPeriodCopyWithImpl<$Res, _$AnalyticsPeriodImpl>
    implements _$$AnalyticsPeriodImplCopyWith<$Res> {
  __$$AnalyticsPeriodImplCopyWithImpl(
    _$AnalyticsPeriodImpl _value,
    $Res Function(_$AnalyticsPeriodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$AnalyticsPeriodImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AnalyticsPeriodType,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsPeriodImpl implements _AnalyticsPeriod {
  const _$AnalyticsPeriodImpl({
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  factory _$AnalyticsPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsPeriodImplFromJson(json);

  @override
  final AnalyticsPeriodType type;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'AnalyticsPeriod(type: $type, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsPeriodImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, startDate, endDate);

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsPeriodImplCopyWith<_$AnalyticsPeriodImpl> get copyWith =>
      __$$AnalyticsPeriodImplCopyWithImpl<_$AnalyticsPeriodImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsPeriodImplToJson(this);
  }
}

abstract class _AnalyticsPeriod implements AnalyticsPeriod {
  const factory _AnalyticsPeriod({
    required final AnalyticsPeriodType type,
    required final DateTime startDate,
    required final DateTime endDate,
  }) = _$AnalyticsPeriodImpl;

  factory _AnalyticsPeriod.fromJson(Map<String, dynamic> json) =
      _$AnalyticsPeriodImpl.fromJson;

  @override
  AnalyticsPeriodType get type;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of AnalyticsPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsPeriodImplCopyWith<_$AnalyticsPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
