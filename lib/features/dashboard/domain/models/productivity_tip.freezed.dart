// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'productivity_tip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductivityTip _$ProductivityTipFromJson(Map<String, dynamic> json) {
  return _ProductivityTip.fromJson(json);
}

/// @nodoc
mixin _$ProductivityTip {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // focus, time_management, habits, energy, mindset
  bool get isFavorite => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProductivityTip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductivityTip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductivityTipCopyWith<ProductivityTip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductivityTipCopyWith<$Res> {
  factory $ProductivityTipCopyWith(
    ProductivityTip value,
    $Res Function(ProductivityTip) then,
  ) = _$ProductivityTipCopyWithImpl<$Res, ProductivityTip>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String icon,
    String category,
    bool isFavorite,
    int likes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ProductivityTipCopyWithImpl<$Res, $Val extends ProductivityTip>
    implements $ProductivityTipCopyWith<$Res> {
  _$ProductivityTipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductivityTip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? icon = null,
    Object? category = null,
    Object? isFavorite = null,
    Object? likes = null,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProductivityTipImplCopyWith<$Res>
    implements $ProductivityTipCopyWith<$Res> {
  factory _$$ProductivityTipImplCopyWith(
    _$ProductivityTipImpl value,
    $Res Function(_$ProductivityTipImpl) then,
  ) = __$$ProductivityTipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String icon,
    String category,
    bool isFavorite,
    int likes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ProductivityTipImplCopyWithImpl<$Res>
    extends _$ProductivityTipCopyWithImpl<$Res, _$ProductivityTipImpl>
    implements _$$ProductivityTipImplCopyWith<$Res> {
  __$$ProductivityTipImplCopyWithImpl(
    _$ProductivityTipImpl _value,
    $Res Function(_$ProductivityTipImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductivityTip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? icon = null,
    Object? category = null,
    Object? isFavorite = null,
    Object? likes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ProductivityTipImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        likes: null == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
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
class _$ProductivityTipImpl implements _ProductivityTip {
  const _$ProductivityTipImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.category,
    this.isFavorite = false,
    this.likes = 0,
    required this.createdAt,
  });

  factory _$ProductivityTipImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductivityTipImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String icon;
  @override
  final String category;
  // focus, time_management, habits, energy, mindset
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final int likes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ProductivityTip(id: $id, title: $title, content: $content, icon: $icon, category: $category, isFavorite: $isFavorite, likes: $likes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductivityTipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    icon,
    category,
    isFavorite,
    likes,
    createdAt,
  );

  /// Create a copy of ProductivityTip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductivityTipImplCopyWith<_$ProductivityTipImpl> get copyWith =>
      __$$ProductivityTipImplCopyWithImpl<_$ProductivityTipImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductivityTipImplToJson(this);
  }
}

abstract class _ProductivityTip implements ProductivityTip {
  const factory _ProductivityTip({
    required final String id,
    required final String title,
    required final String content,
    required final String icon,
    required final String category,
    final bool isFavorite,
    final int likes,
    required final DateTime createdAt,
  }) = _$ProductivityTipImpl;

  factory _ProductivityTip.fromJson(Map<String, dynamic> json) =
      _$ProductivityTipImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String get icon;
  @override
  String get category; // focus, time_management, habits, energy, mindset
  @override
  bool get isFavorite;
  @override
  int get likes;
  @override
  DateTime get createdAt;

  /// Create a copy of ProductivityTip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductivityTipImplCopyWith<_$ProductivityTipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
