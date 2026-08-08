// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HabitAnalytics _$HabitAnalyticsFromJson(Map<String, dynamic> json) {
  return _HabitAnalytics.fromJson(json);
}

/// @nodoc
mixin _$HabitAnalytics {
  int get totalHabits => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get totalOpportunities => throw _privateConstructorUsedError;
  double get completionRate =>
      throw _privateConstructorUsedError; // Percentage (0-100)
  Map<String, int> get habitCompletions =>
      throw _privateConstructorUsedError; // habitId -> completion count
  Map<String, double> get habitCompletionRates =>
      throw _privateConstructorUsedError; // habitId -> rate
  List<String> get topHabits =>
      throw _privateConstructorUsedError; // Sorted by completion rate
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  Map<String, int> get categoryCompletions =>
      throw _privateConstructorUsedError; // category -> count
  List<DailyHabitData> get dailyData => throw _privateConstructorUsedError;

  /// Serializes this HabitAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitAnalyticsCopyWith<HabitAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitAnalyticsCopyWith<$Res> {
  factory $HabitAnalyticsCopyWith(
    HabitAnalytics value,
    $Res Function(HabitAnalytics) then,
  ) = _$HabitAnalyticsCopyWithImpl<$Res, HabitAnalytics>;
  @useResult
  $Res call({
    int totalHabits,
    int completedCount,
    int totalOpportunities,
    double completionRate,
    Map<String, int> habitCompletions,
    Map<String, double> habitCompletionRates,
    List<String> topHabits,
    int currentStreak,
    int longestStreak,
    Map<String, int> categoryCompletions,
    List<DailyHabitData> dailyData,
  });
}

/// @nodoc
class _$HabitAnalyticsCopyWithImpl<$Res, $Val extends HabitAnalytics>
    implements $HabitAnalyticsCopyWith<$Res> {
  _$HabitAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalHabits = null,
    Object? completedCount = null,
    Object? totalOpportunities = null,
    Object? completionRate = null,
    Object? habitCompletions = null,
    Object? habitCompletionRates = null,
    Object? topHabits = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? categoryCompletions = null,
    Object? dailyData = null,
  }) {
    return _then(
      _value.copyWith(
            totalHabits: null == totalHabits
                ? _value.totalHabits
                : totalHabits // ignore: cast_nullable_to_non_nullable
                      as int,
            completedCount: null == completedCount
                ? _value.completedCount
                : completedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalOpportunities: null == totalOpportunities
                ? _value.totalOpportunities
                : totalOpportunities // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            habitCompletions: null == habitCompletions
                ? _value.habitCompletions
                : habitCompletions // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            habitCompletionRates: null == habitCompletionRates
                ? _value.habitCompletionRates
                : habitCompletionRates // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            topHabits: null == topHabits
                ? _value.topHabits
                : topHabits // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryCompletions: null == categoryCompletions
                ? _value.categoryCompletions
                : categoryCompletions // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            dailyData: null == dailyData
                ? _value.dailyData
                : dailyData // ignore: cast_nullable_to_non_nullable
                      as List<DailyHabitData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitAnalyticsImplCopyWith<$Res>
    implements $HabitAnalyticsCopyWith<$Res> {
  factory _$$HabitAnalyticsImplCopyWith(
    _$HabitAnalyticsImpl value,
    $Res Function(_$HabitAnalyticsImpl) then,
  ) = __$$HabitAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalHabits,
    int completedCount,
    int totalOpportunities,
    double completionRate,
    Map<String, int> habitCompletions,
    Map<String, double> habitCompletionRates,
    List<String> topHabits,
    int currentStreak,
    int longestStreak,
    Map<String, int> categoryCompletions,
    List<DailyHabitData> dailyData,
  });
}

/// @nodoc
class __$$HabitAnalyticsImplCopyWithImpl<$Res>
    extends _$HabitAnalyticsCopyWithImpl<$Res, _$HabitAnalyticsImpl>
    implements _$$HabitAnalyticsImplCopyWith<$Res> {
  __$$HabitAnalyticsImplCopyWithImpl(
    _$HabitAnalyticsImpl _value,
    $Res Function(_$HabitAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalHabits = null,
    Object? completedCount = null,
    Object? totalOpportunities = null,
    Object? completionRate = null,
    Object? habitCompletions = null,
    Object? habitCompletionRates = null,
    Object? topHabits = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? categoryCompletions = null,
    Object? dailyData = null,
  }) {
    return _then(
      _$HabitAnalyticsImpl(
        totalHabits: null == totalHabits
            ? _value.totalHabits
            : totalHabits // ignore: cast_nullable_to_non_nullable
                  as int,
        completedCount: null == completedCount
            ? _value.completedCount
            : completedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalOpportunities: null == totalOpportunities
            ? _value.totalOpportunities
            : totalOpportunities // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        habitCompletions: null == habitCompletions
            ? _value._habitCompletions
            : habitCompletions // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        habitCompletionRates: null == habitCompletionRates
            ? _value._habitCompletionRates
            : habitCompletionRates // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        topHabits: null == topHabits
            ? _value._topHabits
            : topHabits // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryCompletions: null == categoryCompletions
            ? _value._categoryCompletions
            : categoryCompletions // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        dailyData: null == dailyData
            ? _value._dailyData
            : dailyData // ignore: cast_nullable_to_non_nullable
                  as List<DailyHabitData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitAnalyticsImpl implements _HabitAnalytics {
  const _$HabitAnalyticsImpl({
    required this.totalHabits,
    required this.completedCount,
    required this.totalOpportunities,
    required this.completionRate,
    required final Map<String, int> habitCompletions,
    required final Map<String, double> habitCompletionRates,
    required final List<String> topHabits,
    required this.currentStreak,
    required this.longestStreak,
    required final Map<String, int> categoryCompletions,
    required final List<DailyHabitData> dailyData,
  }) : _habitCompletions = habitCompletions,
       _habitCompletionRates = habitCompletionRates,
       _topHabits = topHabits,
       _categoryCompletions = categoryCompletions,
       _dailyData = dailyData;

  factory _$HabitAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitAnalyticsImplFromJson(json);

  @override
  final int totalHabits;
  @override
  final int completedCount;
  @override
  final int totalOpportunities;
  @override
  final double completionRate;
  // Percentage (0-100)
  final Map<String, int> _habitCompletions;
  // Percentage (0-100)
  @override
  Map<String, int> get habitCompletions {
    if (_habitCompletions is EqualUnmodifiableMapView) return _habitCompletions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_habitCompletions);
  }

  // habitId -> completion count
  final Map<String, double> _habitCompletionRates;
  // habitId -> completion count
  @override
  Map<String, double> get habitCompletionRates {
    if (_habitCompletionRates is EqualUnmodifiableMapView)
      return _habitCompletionRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_habitCompletionRates);
  }

  // habitId -> rate
  final List<String> _topHabits;
  // habitId -> rate
  @override
  List<String> get topHabits {
    if (_topHabits is EqualUnmodifiableListView) return _topHabits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topHabits);
  }

  // Sorted by completion rate
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  final Map<String, int> _categoryCompletions;
  @override
  Map<String, int> get categoryCompletions {
    if (_categoryCompletions is EqualUnmodifiableMapView)
      return _categoryCompletions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryCompletions);
  }

  // category -> count
  final List<DailyHabitData> _dailyData;
  // category -> count
  @override
  List<DailyHabitData> get dailyData {
    if (_dailyData is EqualUnmodifiableListView) return _dailyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyData);
  }

  @override
  String toString() {
    return 'HabitAnalytics(totalHabits: $totalHabits, completedCount: $completedCount, totalOpportunities: $totalOpportunities, completionRate: $completionRate, habitCompletions: $habitCompletions, habitCompletionRates: $habitCompletionRates, topHabits: $topHabits, currentStreak: $currentStreak, longestStreak: $longestStreak, categoryCompletions: $categoryCompletions, dailyData: $dailyData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitAnalyticsImpl &&
            (identical(other.totalHabits, totalHabits) ||
                other.totalHabits == totalHabits) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.totalOpportunities, totalOpportunities) ||
                other.totalOpportunities == totalOpportunities) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            const DeepCollectionEquality().equals(
              other._habitCompletions,
              _habitCompletions,
            ) &&
            const DeepCollectionEquality().equals(
              other._habitCompletionRates,
              _habitCompletionRates,
            ) &&
            const DeepCollectionEquality().equals(
              other._topHabits,
              _topHabits,
            ) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            const DeepCollectionEquality().equals(
              other._categoryCompletions,
              _categoryCompletions,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailyData,
              _dailyData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalHabits,
    completedCount,
    totalOpportunities,
    completionRate,
    const DeepCollectionEquality().hash(_habitCompletions),
    const DeepCollectionEquality().hash(_habitCompletionRates),
    const DeepCollectionEquality().hash(_topHabits),
    currentStreak,
    longestStreak,
    const DeepCollectionEquality().hash(_categoryCompletions),
    const DeepCollectionEquality().hash(_dailyData),
  );

  /// Create a copy of HabitAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitAnalyticsImplCopyWith<_$HabitAnalyticsImpl> get copyWith =>
      __$$HabitAnalyticsImplCopyWithImpl<_$HabitAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitAnalyticsImplToJson(this);
  }
}

abstract class _HabitAnalytics implements HabitAnalytics {
  const factory _HabitAnalytics({
    required final int totalHabits,
    required final int completedCount,
    required final int totalOpportunities,
    required final double completionRate,
    required final Map<String, int> habitCompletions,
    required final Map<String, double> habitCompletionRates,
    required final List<String> topHabits,
    required final int currentStreak,
    required final int longestStreak,
    required final Map<String, int> categoryCompletions,
    required final List<DailyHabitData> dailyData,
  }) = _$HabitAnalyticsImpl;

  factory _HabitAnalytics.fromJson(Map<String, dynamic> json) =
      _$HabitAnalyticsImpl.fromJson;

  @override
  int get totalHabits;
  @override
  int get completedCount;
  @override
  int get totalOpportunities;
  @override
  double get completionRate; // Percentage (0-100)
  @override
  Map<String, int> get habitCompletions; // habitId -> completion count
  @override
  Map<String, double> get habitCompletionRates; // habitId -> rate
  @override
  List<String> get topHabits; // Sorted by completion rate
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  Map<String, int> get categoryCompletions; // category -> count
  @override
  List<DailyHabitData> get dailyData;

  /// Create a copy of HabitAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitAnalyticsImplCopyWith<_$HabitAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyHabitData _$DailyHabitDataFromJson(Map<String, dynamic> json) {
  return _DailyHabitData.fromJson(json);
}

/// @nodoc
mixin _$DailyHabitData {
  DateTime get date => throw _privateConstructorUsedError;
  int get completions => throw _privateConstructorUsedError;
  int get opportunities => throw _privateConstructorUsedError;

  /// Serializes this DailyHabitData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyHabitData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyHabitDataCopyWith<DailyHabitData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyHabitDataCopyWith<$Res> {
  factory $DailyHabitDataCopyWith(
    DailyHabitData value,
    $Res Function(DailyHabitData) then,
  ) = _$DailyHabitDataCopyWithImpl<$Res, DailyHabitData>;
  @useResult
  $Res call({DateTime date, int completions, int opportunities});
}

/// @nodoc
class _$DailyHabitDataCopyWithImpl<$Res, $Val extends DailyHabitData>
    implements $DailyHabitDataCopyWith<$Res> {
  _$DailyHabitDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyHabitData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completions = null,
    Object? opportunities = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completions: null == completions
                ? _value.completions
                : completions // ignore: cast_nullable_to_non_nullable
                      as int,
            opportunities: null == opportunities
                ? _value.opportunities
                : opportunities // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyHabitDataImplCopyWith<$Res>
    implements $DailyHabitDataCopyWith<$Res> {
  factory _$$DailyHabitDataImplCopyWith(
    _$DailyHabitDataImpl value,
    $Res Function(_$DailyHabitDataImpl) then,
  ) = __$$DailyHabitDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int completions, int opportunities});
}

/// @nodoc
class __$$DailyHabitDataImplCopyWithImpl<$Res>
    extends _$DailyHabitDataCopyWithImpl<$Res, _$DailyHabitDataImpl>
    implements _$$DailyHabitDataImplCopyWith<$Res> {
  __$$DailyHabitDataImplCopyWithImpl(
    _$DailyHabitDataImpl _value,
    $Res Function(_$DailyHabitDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyHabitData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completions = null,
    Object? opportunities = null,
  }) {
    return _then(
      _$DailyHabitDataImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completions: null == completions
            ? _value.completions
            : completions // ignore: cast_nullable_to_non_nullable
                  as int,
        opportunities: null == opportunities
            ? _value.opportunities
            : opportunities // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyHabitDataImpl implements _DailyHabitData {
  const _$DailyHabitDataImpl({
    required this.date,
    required this.completions,
    required this.opportunities,
  });

  factory _$DailyHabitDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyHabitDataImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int completions;
  @override
  final int opportunities;

  @override
  String toString() {
    return 'DailyHabitData(date: $date, completions: $completions, opportunities: $opportunities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyHabitDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completions, completions) ||
                other.completions == completions) &&
            (identical(other.opportunities, opportunities) ||
                other.opportunities == opportunities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, completions, opportunities);

  /// Create a copy of DailyHabitData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyHabitDataImplCopyWith<_$DailyHabitDataImpl> get copyWith =>
      __$$DailyHabitDataImplCopyWithImpl<_$DailyHabitDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyHabitDataImplToJson(this);
  }
}

abstract class _DailyHabitData implements DailyHabitData {
  const factory _DailyHabitData({
    required final DateTime date,
    required final int completions,
    required final int opportunities,
  }) = _$DailyHabitDataImpl;

  factory _DailyHabitData.fromJson(Map<String, dynamic> json) =
      _$DailyHabitDataImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get completions;
  @override
  int get opportunities;

  /// Create a copy of DailyHabitData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyHabitDataImplCopyWith<_$DailyHabitDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HabitPerformance _$HabitPerformanceFromJson(Map<String, dynamic> json) {
  return _HabitPerformance.fromJson(json);
}

/// @nodoc
mixin _$HabitPerformance {
  String get habitId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get completions => throw _privateConstructorUsedError;
  int get opportunities => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastCompleted => throw _privateConstructorUsedError;
  List<DailyHabitData> get dailyData => throw _privateConstructorUsedError;

  /// Serializes this HabitPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitPerformanceCopyWith<HabitPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitPerformanceCopyWith<$Res> {
  factory $HabitPerformanceCopyWith(
    HabitPerformance value,
    $Res Function(HabitPerformance) then,
  ) = _$HabitPerformanceCopyWithImpl<$Res, HabitPerformance>;
  @useResult
  $Res call({
    String habitId,
    String title,
    String emoji,
    String color,
    String category,
    int completions,
    int opportunities,
    double completionRate,
    int currentStreak,
    int longestStreak,
    DateTime? lastCompleted,
    List<DailyHabitData> dailyData,
  });
}

/// @nodoc
class _$HabitPerformanceCopyWithImpl<$Res, $Val extends HabitPerformance>
    implements $HabitPerformanceCopyWith<$Res> {
  _$HabitPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habitId = null,
    Object? title = null,
    Object? emoji = null,
    Object? color = null,
    Object? category = null,
    Object? completions = null,
    Object? opportunities = null,
    Object? completionRate = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompleted = freezed,
    Object? dailyData = null,
  }) {
    return _then(
      _value.copyWith(
            habitId: null == habitId
                ? _value.habitId
                : habitId // ignore: cast_nullable_to_non_nullable
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
            completions: null == completions
                ? _value.completions
                : completions // ignore: cast_nullable_to_non_nullable
                      as int,
            opportunities: null == opportunities
                ? _value.opportunities
                : opportunities // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCompleted: freezed == lastCompleted
                ? _value.lastCompleted
                : lastCompleted // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dailyData: null == dailyData
                ? _value.dailyData
                : dailyData // ignore: cast_nullable_to_non_nullable
                      as List<DailyHabitData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitPerformanceImplCopyWith<$Res>
    implements $HabitPerformanceCopyWith<$Res> {
  factory _$$HabitPerformanceImplCopyWith(
    _$HabitPerformanceImpl value,
    $Res Function(_$HabitPerformanceImpl) then,
  ) = __$$HabitPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String habitId,
    String title,
    String emoji,
    String color,
    String category,
    int completions,
    int opportunities,
    double completionRate,
    int currentStreak,
    int longestStreak,
    DateTime? lastCompleted,
    List<DailyHabitData> dailyData,
  });
}

/// @nodoc
class __$$HabitPerformanceImplCopyWithImpl<$Res>
    extends _$HabitPerformanceCopyWithImpl<$Res, _$HabitPerformanceImpl>
    implements _$$HabitPerformanceImplCopyWith<$Res> {
  __$$HabitPerformanceImplCopyWithImpl(
    _$HabitPerformanceImpl _value,
    $Res Function(_$HabitPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habitId = null,
    Object? title = null,
    Object? emoji = null,
    Object? color = null,
    Object? category = null,
    Object? completions = null,
    Object? opportunities = null,
    Object? completionRate = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompleted = freezed,
    Object? dailyData = null,
  }) {
    return _then(
      _$HabitPerformanceImpl(
        habitId: null == habitId
            ? _value.habitId
            : habitId // ignore: cast_nullable_to_non_nullable
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
        completions: null == completions
            ? _value.completions
            : completions // ignore: cast_nullable_to_non_nullable
                  as int,
        opportunities: null == opportunities
            ? _value.opportunities
            : opportunities // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCompleted: freezed == lastCompleted
            ? _value.lastCompleted
            : lastCompleted // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dailyData: null == dailyData
            ? _value._dailyData
            : dailyData // ignore: cast_nullable_to_non_nullable
                  as List<DailyHabitData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitPerformanceImpl implements _HabitPerformance {
  const _$HabitPerformanceImpl({
    required this.habitId,
    required this.title,
    required this.emoji,
    required this.color,
    required this.category,
    required this.completions,
    required this.opportunities,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompleted,
    required final List<DailyHabitData> dailyData,
  }) : _dailyData = dailyData;

  factory _$HabitPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitPerformanceImplFromJson(json);

  @override
  final String habitId;
  @override
  final String title;
  @override
  final String emoji;
  @override
  final String color;
  @override
  final String category;
  @override
  final int completions;
  @override
  final int opportunities;
  @override
  final double completionRate;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime? lastCompleted;
  final List<DailyHabitData> _dailyData;
  @override
  List<DailyHabitData> get dailyData {
    if (_dailyData is EqualUnmodifiableListView) return _dailyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyData);
  }

  @override
  String toString() {
    return 'HabitPerformance(habitId: $habitId, title: $title, emoji: $emoji, color: $color, category: $category, completions: $completions, opportunities: $opportunities, completionRate: $completionRate, currentStreak: $currentStreak, longestStreak: $longestStreak, lastCompleted: $lastCompleted, dailyData: $dailyData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitPerformanceImpl &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.completions, completions) ||
                other.completions == completions) &&
            (identical(other.opportunities, opportunities) ||
                other.opportunities == opportunities) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCompleted, lastCompleted) ||
                other.lastCompleted == lastCompleted) &&
            const DeepCollectionEquality().equals(
              other._dailyData,
              _dailyData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    habitId,
    title,
    emoji,
    color,
    category,
    completions,
    opportunities,
    completionRate,
    currentStreak,
    longestStreak,
    lastCompleted,
    const DeepCollectionEquality().hash(_dailyData),
  );

  /// Create a copy of HabitPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitPerformanceImplCopyWith<_$HabitPerformanceImpl> get copyWith =>
      __$$HabitPerformanceImplCopyWithImpl<_$HabitPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitPerformanceImplToJson(this);
  }
}

abstract class _HabitPerformance implements HabitPerformance {
  const factory _HabitPerformance({
    required final String habitId,
    required final String title,
    required final String emoji,
    required final String color,
    required final String category,
    required final int completions,
    required final int opportunities,
    required final double completionRate,
    required final int currentStreak,
    required final int longestStreak,
    required final DateTime? lastCompleted,
    required final List<DailyHabitData> dailyData,
  }) = _$HabitPerformanceImpl;

  factory _HabitPerformance.fromJson(Map<String, dynamic> json) =
      _$HabitPerformanceImpl.fromJson;

  @override
  String get habitId;
  @override
  String get title;
  @override
  String get emoji;
  @override
  String get color;
  @override
  String get category;
  @override
  int get completions;
  @override
  int get opportunities;
  @override
  double get completionRate;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastCompleted;
  @override
  List<DailyHabitData> get dailyData;

  /// Create a copy of HabitPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitPerformanceImplCopyWith<_$HabitPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
