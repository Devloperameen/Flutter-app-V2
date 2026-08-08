import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String authorId,
    required String authorName,
    required String authorRole, // e.g. "Mentor", "Achiever"
    required String content,
    String? imageUrl,
    String? videoUrl,
    required int likeCount,
    required int commentCount,
    required DateTime createdAt,
    required bool isLikedByMe,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
