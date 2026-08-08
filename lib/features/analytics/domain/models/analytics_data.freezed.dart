// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  AnalyticsPeriod get period => throw _privateConstructorUsedError;
  HabitAnalytics get habitAnalytics => throw _privateConstructorUsedError;
  FocusAnalytics get focusAnalytics => throw _privateConstructorUsedError;
  PersonalRecords get personalRecords => throw _privateConstructorUsedError;
  List<AnalyticsInsight> get insights => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
    AnalyticsData value,
    $Res Function(AnalyticsData) then,
  ) = _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call({
    AnalyticsPeriod period,
    HabitAnalytics habitAnalytics,
    FocusAnalytics focusAnalytics,
    PersonalRecords personalRecords,
    List<AnalyticsInsight> insights,
    DateTime lastUpdated,
    String? selectedCategory,
  });

  $AnalyticsPeriodCopyWith<$Res> get period;
  $HabitAnalyticsCopyWith<$Res> get habitAnalytics;
  $FocusAnalyticsCopyWith<$Res> get focusAnalytics;
  $PersonalRecordsCopyWith<$Res> get personalRecords;
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? habitAnalytics = null,
    Object? focusAnalytics = null,
    Object? personalRecords = null,
    Object? insights = null,
    Object? lastUpdated = null,
    Object? selectedCategory = freezed,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as AnalyticsPeriod,
            habitAnalytics: null == habitAnalytics
                ? _value.habitAnalytics
                : habitAnalytics // ignore: cast_nullable_to_non_nullable
                      as HabitAnalytics,
            focusAnalytics: null == focusAnalytics
                ? _value.focusAnalytics
                : focusAnalytics // ignore: cast_nullable_to_non_nullable
                      as FocusAnalytics,
            personalRecords: null == personalRecords
                ? _value.personalRecords
                : personalRecords // ignore: cast_nullable_to_non_nullable
                      as PersonalRecords,
            insights: null == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as List<AnalyticsInsight>,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            selectedCategory: freezed == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsPeriodCopyWith<$Res> get period {
    return $AnalyticsPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HabitAnalyticsCopyWith<$Res> get habitAnalytics {
    return $HabitAnalyticsCopyWith<$Res>(_value.habitAnalytics, (value) {
      return _then(_value.copyWith(habitAnalytics: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FocusAnalyticsCopyWith<$Res> get focusAnalytics {
    return $FocusAnalyticsCopyWith<$Res>(_value.focusAnalytics, (value) {
      return _then(_value.copyWith(focusAnalytics: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonalRecordsCopyWith<$Res> get personalRecords {
    return $PersonalRecordsCopyWith<$Res>(_value.personalRecords, (value) {
      return _then(_value.copyWith(personalRecords: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
    _$AnalyticsDataImpl value,
    $Res Function(_$AnalyticsDataImpl) then,
  ) = __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AnalyticsPeriod period,
    HabitAnalytics habitAnalytics,
    FocusAnalytics focusAnalytics,
    PersonalRecords personalRecords,
    List<AnalyticsInsight> insights,
    DateTime lastUpdated,
    String? selectedCategory,
  });

  @override
  $AnalyticsPeriodCopyWith<$Res> get period;
  @override
  $HabitAnalyticsCopyWith<$Res> get habitAnalytics;
  @override
  $FocusAnalyticsCopyWith<$Res> get focusAnalytics;
  @override
  $PersonalRecordsCopyWith<$Res> get personalRecords;
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
    _$AnalyticsDataImpl _value,
    $Res Function(_$AnalyticsDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? habitAnalytics = null,
    Object? focusAnalytics = null,
    Object? personalRecords = null,
    Object? insights = null,
    Object? lastUpdated = null,
    Object? selectedCategory = freezed,
  }) {
    return _then(
      _$AnalyticsDataImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as AnalyticsPeriod,
        habitAnalytics: null == habitAnalytics
            ? _value.habitAnalytics
            : habitAnalytics // ignore: cast_nullable_to_non_nullable
                  as HabitAnalytics,
        focusAnalytics: null == focusAnalytics
            ? _value.focusAnalytics
            : focusAnalytics // ignore: cast_nullable_to_non_nullable
                  as FocusAnalytics,
        personalRecords: null == personalRecords
            ? _value.personalRecords
            : personalRecords // ignore: cast_nullable_to_non_nullable
                  as PersonalRecords,
        insights: null == insights
            ? _value._insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as List<AnalyticsInsight>,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        selectedCategory: freezed == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl({
    required this.period,
    required this.habitAnalytics,
    required this.focusAnalytics,
    required this.personalRecords,
    required final List<AnalyticsInsight> insights,
    required this.lastUpdated,
    this.selectedCategory,
  }) : _insights = insights;

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  final AnalyticsPeriod period;
  @override
  final HabitAnalytics habitAnalytics;
  @override
  final FocusAnalytics focusAnalytics;
  @override
  final PersonalRecords personalRecords;
  final List<AnalyticsInsight> _insights;
  @override
  List<AnalyticsInsight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  final DateTime lastUpdated;
  @override
  final String? selectedCategory;

  @override
  String toString() {
    return 'AnalyticsData(period: $period, habitAnalytics: $habitAnalytics, focusAnalytics: $focusAnalytics, personalRecords: $personalRecords, insights: $insights, lastUpdated: $lastUpdated, selectedCategory: $selectedCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.habitAnalytics, habitAnalytics) ||
                other.habitAnalytics == habitAnalytics) &&
            (identical(other.focusAnalytics, focusAnalytics) ||
                other.focusAnalytics == focusAnalytics) &&
            (identical(other.personalRecords, personalRecords) ||
                other.personalRecords == personalRecords) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    habitAnalytics,
    focusAnalytics,
    personalRecords,
    const DeepCollectionEquality().hash(_insights),
    lastUpdated,
    selectedCategory,
  );

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(this);
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData({
    required final AnalyticsPeriod period,
    required final HabitAnalytics habitAnalytics,
    required final FocusAnalytics focusAnalytics,
    required final PersonalRecords personalRecords,
    required final List<AnalyticsInsight> insights,
    required final DateTime lastUpdated,
    final String? selectedCategory,
  }) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  AnalyticsPeriod get period;
  @override
  HabitAnalytics get habitAnalytics;
  @override
  FocusAnalytics get focusAnalytics;
  @override
  PersonalRecords get personalRecords;
  @override
  List<AnalyticsInsight> get insights;
  @override
  DateTime get lastUpdated;
  @override
  String? get selectedCategory;

  /// Create a copy of AnalyticsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
