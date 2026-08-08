import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_story.freezed.dart';
part 'success_story.g.dart';

/// Success stories from students, developers, entrepreneurs, etc.
@freezed
class SuccessStory with _$SuccessStory {
  const factory SuccessStory({
    required String id,
    required String name,
    required String title, // e.g., "From Student to Software Engineer"
    required String story,
    required String imageUrl,
    required String category, // student, developer, entrepreneur, business_owner, graduate
    required String achievement,
    @Default([]) List<String> tags,
    required DateTime createdAt,
  }) = _SuccessStory;

  factory SuccessStory.fromJson(Map<String, dynamic> json) =>
      _$SuccessStoryFromJson(json);

  factory SuccessStory.fromFirestore(Map<String, dynamic> data, String id) {
    return SuccessStory(
      id: id,
      name: data['name'] as String? ?? '',
      title: data['title'] as String? ?? '',
      story: data['story'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      category: data['category'] as String? ?? 'student',
      achievement: data['achievement'] as String? ?? '',
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
