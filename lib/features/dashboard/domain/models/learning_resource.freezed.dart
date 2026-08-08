// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LearningResource _$LearningResourceFromJson(Map<String, dynamic> json) {
  return _LearningResource.fromJson(json);
}

/// @nodoc
mixin _$LearningResource {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get resourceUrl => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // book, course, video, article
  String get category => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // in minutes
  bool get isRecommended => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LearningResource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningResource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningResourceCopyWith<LearningResource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningResourceCopyWith<$Res> {
  factory $LearningResourceCopyWith(
    LearningResource value,
    $Res Function(LearningResource) then,
  ) = _$LearningResourceCopyWithImpl<$Res, LearningResource>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String thumbnailUrl,
    String resourceUrl,
    String type,
    String category,
    String author,
    int duration,
    bool isRecommended,
    bool isCompleted,
    List<String> tags,
    DateTime createdAt,
  });
}

/// @nodoc
class _$LearningResourceCopyWithImpl<$Res, $Val extends LearningResource>
    implements $LearningResourceCopyWith<$Res> {
  _$LearningResourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningResource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? resourceUrl = null,
    Object? type = null,
    Object? category = null,
    Object? author = null,
    Object? duration = null,
    Object? isRecommended = null,
    Object? isCompleted = null,
    Object? tags = null,
    Object? createdAt = null,
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
            thumbnailUrl: null == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            resourceUrl: null == resourceUrl
                ? _value.resourceUrl
                : resourceUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            isRecommended: null == isRecommended
                ? _value.isRecommended
                : isRecommended // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$LearningResourceImplCopyWith<$Res>
    implements $LearningResourceCopyWith<$Res> {
  factory _$$LearningResourceImplCopyWith(
    _$LearningResourceImpl value,
    $Res Function(_$LearningResourceImpl) then,
  ) = __$$LearningResourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String thumbnailUrl,
    String resourceUrl,
    String type,
    String category,
    String author,
    int duration,
    bool isRecommended,
    bool isCompleted,
    List<String> tags,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$LearningResourceImplCopyWithImpl<$Res>
    extends _$LearningResourceCopyWithImpl<$Res, _$LearningResourceImpl>
    implements _$$LearningResourceImplCopyWith<$Res> {
  __$$LearningResourceImplCopyWithImpl(
    _$LearningResourceImpl _value,
    $Res Function(_$LearningResourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningResource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? resourceUrl = null,
    Object? type = null,
    Object? category = null,
    Object? author = null,
    Object? duration = null,
    Object? isRecommended = null,
    Object? isCompleted = null,
    Object? tags = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$LearningResourceImpl(
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
        thumbnailUrl: null == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        resourceUrl: null == resourceUrl
            ? _value.resourceUrl
            : resourceUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        isRecommended: null == isRecommended
            ? _value.isRecommended
            : isRecommended // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$LearningResourceImpl implements _LearningResource {
  const _$LearningResourceImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.resourceUrl,
    required this.type,
    required this.category,
    required this.author,
    this.duration = 0,
    this.isRecommended = false,
    this.isCompleted = false,
    final List<String> tags = const [],
    required this.createdAt,
  }) : _tags = tags;

  factory _$LearningResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningResourceImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String thumbnailUrl;
  @override
  final String resourceUrl;
  @override
  final String type;
  // book, course, video, article
  @override
  final String category;
  @override
  final String author;
  @override
  @JsonKey()
  final int duration;
  // in minutes
  @override
  @JsonKey()
  final bool isRecommended;
  @override
  @JsonKey()
  final bool isCompleted;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'LearningResource(id: $id, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, resourceUrl: $resourceUrl, type: $type, category: $category, author: $author, duration: $duration, isRecommended: $isRecommended, isCompleted: $isCompleted, tags: $tags, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningResourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.resourceUrl, resourceUrl) ||
                other.resourceUrl == resourceUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    thumbnailUrl,
    resourceUrl,
    type,
    category,
    author,
    duration,
    isRecommended,
    isCompleted,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
  );

  /// Create a copy of LearningResource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningResourceImplCopyWith<_$LearningResourceImpl> get copyWith =>
      __$$LearningResourceImplCopyWithImpl<_$LearningResourceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningResourceImplToJson(this);
  }
}

abstract class _LearningResource implements LearningResource {
  const factory _LearningResource({
    required final String id,
    required final String title,
    required final String description,
    required final String thumbnailUrl,
    required final String resourceUrl,
    required final String type,
    required final String category,
    required final String author,
    final int duration,
    final bool isRecommended,
    final bool isCompleted,
    final List<String> tags,
    required final DateTime createdAt,
  }) = _$LearningResourceImpl;

  factory _LearningResource.fromJson(Map<String, dynamic> json) =
      _$LearningResourceImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get thumbnailUrl;
  @override
  String get resourceUrl;
  @override
  String get type; // book, course, video, article
  @override
  String get category;
  @override
  String get author;
  @override
  int get duration; // in minutes
  @override
  bool get isRecommended;
  @override
  bool get isCompleted;
  @override
  List<String> get tags;
  @override
  DateTime get createdAt;

  /// Create a copy of LearningResource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningResourceImplCopyWith<_$LearningResourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
