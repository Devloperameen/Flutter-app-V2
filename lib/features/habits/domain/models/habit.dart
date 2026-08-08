import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

/// Represents a habit with complete tracking information.
/// Firestore is the ONLY source of truth.
@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    required String emoji,
    required String color, // Hex color code
    required String category,
    String? description,
    @Default(false) bool reminderEnabled,
    String? reminderTime, // HH:mm format
    @Default(0) int targetMinutes, // 0 if not time-based
    @Default(false) bool completedToday,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalCompletions,
    DateTime? lastCompletedDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool archived,
    @Default(0) int order, // For reordering
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
}
