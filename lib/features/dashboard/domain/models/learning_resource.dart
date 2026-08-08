import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_resource.freezed.dart';
part 'learning_resource.g.dart';

/// Learning resources (books, courses, videos, articles)
@freezed
class LearningResource with _$LearningResource {
  const factory LearningResource({
    required String id,
    required String title,
    required String description,
    required String thumbnailUrl,
    required String resourceUrl,
    required String type, // book, course, video, article
    required String category,
    required String author,
    @Default(0) int duration, // in minutes
    @Default(false) bool isRecommended,
    @Default(false) bool isCompleted,
    @Default([]) List<String> tags,
    required DateTime createdAt,
  }) = _LearningResource;

  factory LearningResource.fromJson(Map<String, dynamic> json) =>
      _$LearningResourceFromJson(json);

  factory LearningResource.fromFirestore(Map<String, dynamic> data, String id) {
    return LearningResource(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      resourceUrl: data['resourceUrl'] as String? ?? '',
      type: data['type'] as String? ?? 'article',
      category: data['category'] as String? ?? 'general',
      author: data['author'] as String? ?? '',
      duration: data['duration'] as int? ?? 0,
      isRecommended: data['isRecommended'] as bool? ?? false,
      isCompleted: data['isCompleted'] as bool? ?? false,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
