/// Habit-related constants and collections
abstract final class HabitConstants {
  // ─────────────────────────────────────────
  // Habit Categories
  // ─────────────────────────────────────────
  
  static const List<String> categories = [
    'mindfulness',
    'fitness',
    'learning',
    'health',
    'productivity',
    'creativity',
    'social',
    'entertainment',
    'other',
  ];

  static const Map<String, String> categoryEmojis = {
    'mindfulness': '🧘',
    'fitness': '💪',
    'learning': '📚',
    'health': '🏥',
    'productivity': '📊',
    'creativity': '🎨',
    'social': '👥',
    'entertainment': '🎮',
    'other': '⭐',
  };

  static const Map<String, String> categoryLabels = {
    'mindfulness': 'Mindfulness',
    'fitness': 'Fitness',
    'learning': 'Learning',
    'health': 'Health',
    'productivity': 'Productivity',
    'creativity': 'Creativity',
    'social': 'Social',
    'entertainment': 'Entertainment',
    'other': 'Other',
  };

  // ─────────────────────────────────────────
  // Habit Emojis
  // ─────────────────────────────────────────

  static const List<String> popularEmojis = [
    '✨', '💪', '🧘', '📚', '🏃', '🎯', '💧', '🍎',
    '😴', '🎨', '🎸', '📝', '🚴', '🏊', '🧘‍♀️', '🤸',
    '🥗', '☕', '🚶', '🧠', '💃', '📱', '⏰', '🔥',
    '🌟', '💯', '👍', '😊', '🎉', '🏆', '🎁', '💝',
    '📖', '✍️', '🎬', '🎵', '🎤', '🎭', '📸', '🎲',
    '🧩', '🏋️', '🤾', '⛹️', '🏌️', '🎳', '🏄', '🚣',
    '🛴', '🛹', '🛼', '⛷️', '🏂', '🪂', '🏇', '⛸️',
  ];

  // ─────────────────────────────────────────
  // Habit Colors
  // ─────────────────────────────────────────

  static const Map<String, String> colorPresets = {
    'red': '#FF6B6B',
    'orange': '#FFA500',
    'yellow': '#FFD93D',
    'green': '#6BCF7F',
    'blue': '#4D96FF',
    'purple': '#A78BFA',
    'pink': '#FF69B4',
    'teal': '#20C997',
    'indigo': '#6366F1',
    'cyan': '#06B6D4',
  };

  static const Map<String, String> colorLabels = {
    'red': 'Red',
    'orange': 'Orange',
    'yellow': 'Yellow',
    'green': 'Green',
    'blue': 'Blue',
    'purple': 'Purple',
    'pink': 'Pink',
    'teal': 'Teal',
    'indigo': 'Indigo',
    'cyan': 'Cyan',
  };

  // ─────────────────────────────────────────
  // Reminder Times
  // ─────────────────────────────────────────

  static const List<String> reminderTimes = [
    '06:00', '07:00', '08:00', '09:00', '10:00',
    '11:00', '12:00', '13:00', '14:00', '15:00',
    '16:00', '17:00', '18:00', '19:00', '20:00',
    '21:00', '22:00', '23:00',
  ];

  // ─────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────

  static const int minTitleLength = 1;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int minTargetMinutes = 0;
  static const int maxTargetMinutes = 480; // 8 hours
}
