import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required String actionUrl,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
}

@freezed
class Quote with _$Quote {
  const factory Quote({
    required String text,
    required String author,
  }) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required String userName,
    required Mission todayMission,
    required String energyLevel, // e.g. "High", "Low"
    required int streakDays,
    required Quote dailyQuote,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) => 
      _$DashboardDataFromJson(json);
}
