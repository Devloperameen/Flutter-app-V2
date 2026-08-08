import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_challenge.freezed.dart';
part 'daily_challenge.g.dart';

/// Daily challenges that users can complete to earn XP
@freezed
class DailyChallenge with _$DailyChallenge {
  const factory DailyChallenge({
    required String id,
    required String title,
    required String description,
    required String icon,
    required int xpReward,
    required String category, // focus, habit, learning, productivity
    @Default(false) bool isCompleted,
    @Default(0) int progress, // 0-100 percentage
    required int targetValue,
    required int currentValue,
    required DateTime expiresAt,
  }) = _DailyChallenge;

  factory DailyChallenge.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeFromJson(json);

  factory DailyChallenge.fromFirestore(Map<String, dynamic> data, String id) {
    return DailyChallenge(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      icon: data['icon'] as String? ?? '🎯',
      xpReward: data['xpReward'] as int? ?? 0,
      category: data['category'] as String? ?? 'focus',
      isCompleted: data['isCompleted'] as bool? ?? false,
      progress: data['progress'] as int? ?? 0,
      targetValue: data['targetValue'] as int? ?? 1,
      currentValue: data['currentValue'] as int? ?? 0,
      expiresAt: data['expiresAt'] != null
          ? DateTime.parse(data['expiresAt'] as String)
          : DateTime.now().add(const Duration(days: 1)),
    );
  }
}
