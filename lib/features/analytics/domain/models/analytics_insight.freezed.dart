// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsInsight _$AnalyticsInsightFromJson(Map<String, dynamic> json) {
  return _AnalyticsInsight.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsInsight {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  InsightType get type => throw _privateConstructorUsedError;
  InsightPriority get priority => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsInsightCopyWith<AnalyticsInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsInsightCopyWith<$Res> {
  factory $AnalyticsInsightCopyWith(
    AnalyticsInsight value,
    $Res Function(AnalyticsInsight) then,
  ) = _$AnalyticsInsightCopyWithImpl<$Res, AnalyticsInsight>;
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    InsightType type,
    InsightPriority priority,
    DateTime generatedAt,
    String? emoji,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$AnalyticsInsightCopyWithImpl<$Res, $Val extends AnalyticsInsight>
    implements $AnalyticsInsightCopyWith<$Res> {
  _$AnalyticsInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? generatedAt = null,
    Object? emoji = freezed,
    Object? metadata = freezed,
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
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as InsightType,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as InsightPriority,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            emoji: freezed == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsInsightImplCopyWith<$Res>
    implements $AnalyticsInsightCopyWith<$Res> {
  factory _$$AnalyticsInsightImplCopyWith(
    _$AnalyticsInsightImpl value,
    $Res Function(_$AnalyticsInsightImpl) then,
  ) = __$$AnalyticsInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String message,
    InsightType type,
    InsightPriority priority,
    DateTime generatedAt,
    String? emoji,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$AnalyticsInsightImplCopyWithImpl<$Res>
    extends _$AnalyticsInsightCopyWithImpl<$Res, _$AnalyticsInsightImpl>
    implements _$$AnalyticsInsightImplCopyWith<$Res> {
  __$$AnalyticsInsightImplCopyWithImpl(
    _$AnalyticsInsightImpl _value,
    $Res Function(_$AnalyticsInsightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? priority = null,
    Object? generatedAt = null,
    Object? emoji = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$AnalyticsInsightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as InsightType,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as InsightPriority,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        emoji: freezed == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsInsightImpl implements _AnalyticsInsight {
  const _$AnalyticsInsightImpl({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.generatedAt,
    this.emoji,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$AnalyticsInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsInsightImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String message;
  @override
  final InsightType type;
  @override
  final InsightPriority priority;
  @override
  final DateTime generatedAt;
  @override
  final String? emoji;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AnalyticsInsight(id: $id, title: $title, message: $message, type: $type, priority: $priority, generatedAt: $generatedAt, emoji: $emoji, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    message,
    type,
    priority,
    generatedAt,
    emoji,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of AnalyticsInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsInsightImplCopyWith<_$AnalyticsInsightImpl> get copyWith =>
      __$$AnalyticsInsightImplCopyWithImpl<_$AnalyticsInsightImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsInsightImplToJson(this);
  }
}

abstract class _AnalyticsInsight implements AnalyticsInsight {
  const factory _AnalyticsInsight({
    required final String id,
    required final String title,
    required final String message,
    required final InsightType type,
    required final InsightPriority priority,
    required final DateTime generatedAt,
    final String? emoji,
    final Map<String, dynamic>? metadata,
  }) = _$AnalyticsInsightImpl;

  factory _AnalyticsInsight.fromJson(Map<String, dynamic> json) =
      _$AnalyticsInsightImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get message;
  @override
  InsightType get type;
  @override
  InsightPriority get priority;
  @override
  DateTime get generatedAt;
  @override
  String? get emoji;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of AnalyticsInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsInsightImplCopyWith<_$AnalyticsInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
