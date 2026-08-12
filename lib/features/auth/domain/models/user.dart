import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    @Default('user') String role, // ✅ FIXED: Added role field ('user', 'admin', 'super_admin')
    @Default(false) bool isEmailVerified,
    @Default(1) int level, // ✅ FIXED: Added level field (user level/rank)
    @Default(0) int xp, // ✅ FIXED: Added xp field (experience points)
    @Default(0) int rank, // ✅ FIXED: Added rank field (leaderboard rank)
    @Default(0) int totalFocusHours, // ✅ FIXED: Added totalFocusHours field
    @Default(0) int streakDays, // ✅ FIXED: Added streakDays field (activity streak)
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
