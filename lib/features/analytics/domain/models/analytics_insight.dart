import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_insight.freezed.dart';
part 'analytics_insight.g.dart';

/// Motivational coaching insight
@freezed
class AnalyticsInsight with _$AnalyticsInsight {
  const factory AnalyticsInsight({
    required String id,
    required String title,
    required String message,
    required InsightType type,
    required InsightPriority priority,
    required DateTime generatedAt,
    String? emoji,
    Map<String, dynamic>? metadata,
  }) = _AnalyticsInsight;

  factory AnalyticsInsight.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsInsightFromJson(json);
}

/// Types of insights
enum InsightType {
  @JsonValue('improvement')
  improvement,
  @JsonValue('encouragement')
  encouragement,
  @JsonValue('achievement')
  achievement,
  @JsonValue('milestone')
  milestone,
  @JsonValue('comparison')
  comparison,
  @JsonValue('prediction')
  prediction,
  @JsonValue('streak')
  streak,
}

/// Priority levels for insights
enum InsightPriority {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
}
