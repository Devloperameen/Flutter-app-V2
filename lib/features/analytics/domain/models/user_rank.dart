import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_rank.freezed.dart';
part 'user_rank.g.dart';

@freezed
class UserRank with _$UserRank {
  const factory UserRank({
    required int rank,
    required int totalUsers,
    required double percentile,
    required int level,
    required int totalXp,
    required String userName,
    required int focusHours,
    required int streakDays,
  }) = _UserRank;

  factory UserRank.fromJson(Map<String, dynamic> json) => _$UserRankFromJson(json);
}
