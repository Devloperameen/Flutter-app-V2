import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentor_message.freezed.dart';
part 'mentor_message.g.dart';

/// AI Mentor personalized messages
@freezed
class MentorMessage with _$MentorMessage {
  const factory MentorMessage({
    required String id,
    required String message,
    required String tone, // encouraging, motivational, disciplined, warm, supportive
    required String context, // morning, afternoon, evening, after_success, after_failure
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _MentorMessage;

  factory MentorMessage.fromJson(Map<String, dynamic> json) =>
      _$MentorMessageFromJson(json);

  factory MentorMessage.fromFirestore(Map<String, dynamic> data, String id) {
    return MentorMessage(
      id: id,
      message: data['message'] as String? ?? '',
      tone: data['tone'] as String? ?? 'encouraging',
      context: data['context'] as String? ?? 'morning',
      isRead: data['isRead'] as bool? ?? false,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Generate a contextual mentor message based on time of day and user progress
  static String generateMessage({
    required String userName,
    required int streakDays,
    required String energyLevel,
    int completedHabits = 0,
    int totalHabits = 0,
  }) {
    final hour = DateTime.now().hour;
    
    // Morning messages (5 AM - 11 AM)
    if (hour >= 5 && hour < 12) {
      if (streakDays > 7) {
        return '$userName, you\'re building something incredible. $streakDays days of consistency! Today, let\'s push even further.';
      } else if (streakDays > 0) {
        return 'Good morning, $userName! Day $streakDays of your journey. Every morning is a fresh chance to become better.';
      } else {
        return 'Welcome back, $userName! Today is the perfect day to start fresh. Your future self will thank you for starting now.';
      }
    }
    
    // Afternoon messages (12 PM - 5 PM)
    if (hour >= 12 && hour < 17) {
      if (completedHabits > 0 && totalHabits > 0) {
        final percentage = (completedHabits / totalHabits * 100).round();
        if (percentage >= 80) {
          return 'Outstanding, $userName! You\'ve completed $completedHabits/$totalHabits habits today. This is the discipline that builds legends.';
        } else {
          return 'You\'re making progress, $userName. $completedHabits/$totalHabits done. Keep the momentum going!';
        }
      } else {
        return 'The afternoon is perfect for deep focus work, $userName. Let\'s make this time count.';
      }
    }
    
    // Evening messages (5 PM - 9 PM)
    if (hour >= 17 && hour < 21) {
      return 'Evening, $userName. Reflect on today\'s progress and prepare for tomorrow\'s victories. Consistency is everything.';
    }
    
    // Night messages (9 PM - 4 AM)
    return '$userName, rest well tonight. Champions recover properly. Tomorrow is another opportunity to grow.';
  }
}
