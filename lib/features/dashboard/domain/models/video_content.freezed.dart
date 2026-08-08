// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoContent _$VideoContentFromJson(Map<String, dynamic> json) {
  return _VideoContent.fromJson(json);
}

/// @nodoc
mixin _$VideoContent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // motivation, discipline, business, study, programming, cybersecurity, ai, productivity
  int get duration => throw _privateConstructorUsedError; // in seconds
  int get views => throw _privateConstructorUsedError;
  bool get isWatched => throw _privateConstructorUsedError;
  int get watchProgress =>
      throw _privateConstructorUsedError; // percentage 0-100
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VideoContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoContentCopyWith<VideoContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoContentCopyWith<$Res> {
  factory $VideoContentCopyWith(
    VideoContent value,
    $Res Function(VideoContent) then,
  ) = _$VideoContentCopyWithImpl<$Res, VideoContent>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String thumbnailUrl,
    String videoUrl,
    String category,
    int duration,
    int views,
    bool isWatched,
    int watchProgress,
    DateTime createdAt,
  });
}

/// @nodoc
class _$VideoContentCopyWithImpl<$Res, $Val extends VideoContent>
    implements $VideoContentCopyWith<$Res> {
  _$VideoContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? videoUrl = null,
    Object? category = null,
    Object? duration = null,
    Object? views = null,
    Object? isWatched = null,
    Object? watchProgress = null,
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
            videoUrl: null == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            views: null == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as int,
            isWatched: null == isWatched
                ? _value.isWatched
                : isWatched // ignore: cast_nullable_to_non_nullable
                      as bool,
            watchProgress: null == watchProgress
                ? _value.watchProgress
                : watchProgress // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$VideoContentImplCopyWith<$Res>
    implements $VideoContentCopyWith<$Res> {
  factory _$$VideoContentImplCopyWith(
    _$VideoContentImpl value,
    $Res Function(_$VideoContentImpl) then,
  ) = __$$VideoContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String thumbnailUrl,
    String videoUrl,
    String category,
    int duration,
    int views,
    bool isWatched,
    int watchProgress,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$VideoContentImplCopyWithImpl<$Res>
    extends _$VideoContentCopyWithImpl<$Res, _$VideoContentImpl>
    implements _$$VideoContentImplCopyWith<$Res> {
  __$$VideoContentImplCopyWithImpl(
    _$VideoContentImpl _value,
    $Res Function(_$VideoContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? videoUrl = null,
    Object? category = null,
    Object? duration = null,
    Object? views = null,
    Object? isWatched = null,
    Object? watchProgress = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$VideoContentImpl(
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
        videoUrl: null == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        views: null == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as int,
        isWatched: null == isWatched
            ? _value.isWatched
            : isWatched // ignore: cast_nullable_to_non_nullable
                  as bool,
        watchProgress: null == watchProgress
            ? _value.watchProgress
            : watchProgress // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$VideoContentImpl implements _VideoContent {
  const _$VideoContentImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.category,
    required this.duration,
    required this.views,
    this.isWatched = false,
    this.watchProgress = 0,
    required this.createdAt,
  });

  factory _$VideoContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoContentImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String thumbnailUrl;
  @override
  final String videoUrl;
  @override
  final String category;
  // motivation, discipline, business, study, programming, cybersecurity, ai, productivity
  @override
  final int duration;
  // in seconds
  @override
  final int views;
  @override
  @JsonKey()
  final bool isWatched;
  @override
  @JsonKey()
  final int watchProgress;
  // percentage 0-100
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'VideoContent(id: $id, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, videoUrl: $videoUrl, category: $category, duration: $duration, views: $views, isWatched: $isWatched, watchProgress: $watchProgress, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.isWatched, isWatched) ||
                other.isWatched == isWatched) &&
            (identical(other.watchProgress, watchProgress) ||
                other.watchProgress == watchProgress) &&
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
    videoUrl,
    category,
    duration,
    views,
    isWatched,
    watchProgress,
    createdAt,
  );

  /// Create a copy of VideoContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoContentImplCopyWith<_$VideoContentImpl> get copyWith =>
      __$$VideoContentImplCopyWithImpl<_$VideoContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoContentImplToJson(this);
  }
}

abstract class _VideoContent implements VideoContent {
  const factory _VideoContent({
    required final String id,
    required final String title,
    required final String description,
    required final String thumbnailUrl,
    required final String videoUrl,
    required final String category,
    required final int duration,
    required final int views,
    final bool isWatched,
    final int watchProgress,
    required final DateTime createdAt,
  }) = _$VideoContentImpl;

  factory _VideoContent.fromJson(Map<String, dynamic> json) =
      _$VideoContentImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get thumbnailUrl;
  @override
  String get videoUrl;
  @override
  String get category; // motivation, discipline, business, study, programming, cybersecurity, ai, productivity
  @override
  int get duration; // in seconds
  @override
  int get views;
  @override
  bool get isWatched;
  @override
  int get watchProgress; // percentage 0-100
  @override
  DateTime get createdAt;

  /// Create a copy of VideoContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoContentImplCopyWith<_$VideoContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
