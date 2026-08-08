// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentor_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MentorMessage _$MentorMessageFromJson(Map<String, dynamic> json) {
  return _MentorMessage.fromJson(json);
}

/// @nodoc
mixin _$MentorMessage {
  String get id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get tone =>
      throw _privateConstructorUsedError; // encouraging, motivational, disciplined, warm, supportive
  String get context =>
      throw _privateConstructorUsedError; // morning, afternoon, evening, after_success, after_failure
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MentorMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MentorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MentorMessageCopyWith<MentorMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentorMessageCopyWith<$Res> {
  factory $MentorMessageCopyWith(
    MentorMessage value,
    $Res Function(MentorMessage) then,
  ) = _$MentorMessageCopyWithImpl<$Res, MentorMessage>;
  @useResult
  $Res call({
    String id,
    String message,
    String tone,
    String context,
    bool isRead,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MentorMessageCopyWithImpl<$Res, $Val extends MentorMessage>
    implements $MentorMessageCopyWith<$Res> {
  _$MentorMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MentorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? tone = null,
    Object? context = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            tone: null == tone
                ? _value.tone
                : tone // ignore: cast_nullable_to_non_nullable
                      as String,
            context: null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                      as String,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MentorMessageImplCopyWith<$Res>
    implements $MentorMessageCopyWith<$Res> {
  factory _$$MentorMessageImplCopyWith(
    _$MentorMessageImpl value,
    $Res Function(_$MentorMessageImpl) then,
  ) = __$$MentorMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String message,
    String tone,
    String context,
    bool isRead,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MentorMessageImplCopyWithImpl<$Res>
    extends _$MentorMessageCopyWithImpl<$Res, _$MentorMessageImpl>
    implements _$$MentorMessageImplCopyWith<$Res> {
  __$$MentorMessageImplCopyWithImpl(
    _$MentorMessageImpl _value,
    $Res Function(_$MentorMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MentorMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? tone = null,
    Object? context = null,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MentorMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        tone: null == tone
            ? _value.tone
            : tone // ignore: cast_nullable_to_non_nullable
                  as String,
        context: null == context
            ? _value.context
            : context // ignore: cast_nullable_to_non_nullable
                  as String,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MentorMessageImpl implements _MentorMessage {
  const _$MentorMessageImpl({
    required this.id,
    required this.message,
    required this.tone,
    required this.context,
    this.isRead = false,
    required this.createdAt,
  });

  factory _$MentorMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentorMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String message;
  @override
  final String tone;
  // encouraging, motivational, disciplined, warm, supportive
  @override
  final String context;
  // morning, afternoon, evening, after_success, after_failure
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MentorMessage(id: $id, message: $message, tone: $tone, context: $context, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentorMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.tone, tone) || other.tone == tone) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, message, tone, context, isRead, createdAt);

  /// Create a copy of MentorMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MentorMessageImplCopyWith<_$MentorMessageImpl> get copyWith =>
      __$$MentorMessageImplCopyWithImpl<_$MentorMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentorMessageImplToJson(this);
  }
}

abstract class _MentorMessage implements MentorMessage {
  const factory _MentorMessage({
    required final String id,
    required final String message,
    required final String tone,
    required final String context,
    final bool isRead,
    required final DateTime createdAt,
  }) = _$MentorMessageImpl;

  factory _MentorMessage.fromJson(Map<String, dynamic> json) =
      _$MentorMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get message;
  @override
  String get tone; // encouraging, motivational, disciplined, warm, supportive
  @override
  String get context; // morning, afternoon, evening, after_success, after_failure
  @override
  bool get isRead;
  @override
  DateTime get createdAt;

  /// Create a copy of MentorMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MentorMessageImplCopyWith<_$MentorMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
