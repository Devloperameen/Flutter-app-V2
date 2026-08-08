import 'package:freezed_annotation/freezed_annotation.dart';

part 'productivity_tip.freezed.dart';
part 'productivity_tip.g.dart';

/// Productivity tips and advice
@freezed
class ProductivityTip with _$ProductivityTip {
  const factory ProductivityTip({
    required String id,
    required String title,
    required String content,
    required String icon,
    required String category, // focus, time_management, habits, energy, mindset
    @Default(false) bool isFavorite,
    @Default(0) int likes,
    required DateTime createdAt,
  }) = _ProductivityTip;

  factory ProductivityTip.fromJson(Map<String, dynamic> json) =>
      _$ProductivityTipFromJson(json);

  factory ProductivityTip.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductivityTip(
      id: id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      icon: data['icon'] as String? ?? '💡',
      category: data['category'] as String? ?? 'focus',
      isFavorite: data['isFavorite'] as bool? ?? false,
      likes: data['likes'] as int? ?? 0,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
