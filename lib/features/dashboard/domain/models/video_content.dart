import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_content.freezed.dart';
part 'video_content.g.dart';

/// Video content for inspiration and learning
@freezed
class VideoContent with _$VideoContent {
  const factory VideoContent({
    required String id,
    required String title,
    required String description,
    required String thumbnailUrl,
    required String videoUrl,
    required String category, // motivation, discipline, business, study, programming, cybersecurity, ai, productivity
    required int duration, // in seconds
    required int views,
    @Default(false) bool isWatched,
    @Default(0) int watchProgress, // percentage 0-100
    required DateTime createdAt,
  }) = _VideoContent;

  factory VideoContent.fromJson(Map<String, dynamic> json) =>
      _$VideoContentFromJson(json);

  factory VideoContent.fromFirestore(Map<String, dynamic> data, String id) {
    return VideoContent(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      videoUrl: data['videoUrl'] as String? ?? '',
      category: data['category'] as String? ?? 'motivation',
      duration: data['duration'] as int? ?? 0,
      views: data['views'] as int? ?? 0,
      isWatched: data['isWatched'] as bool? ?? false,
      watchProgress: data['watchProgress'] as int? ?? 0,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }

  static const List<String> categories = [
    'motivation',
    'discipline',
    'business',
    'study',
    'programming',
    'cybersecurity',
    'ai',
    'productivity',
  ];
}
