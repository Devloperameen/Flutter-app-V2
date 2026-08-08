/// Timer configuration for different types of focus sessions
class TimerConfig {
  final String id;
  final String name;
  final String description;
  final int durationSeconds; // Total duration in seconds
  final String color;
  final String icon;
  final int xpReward;

  const TimerConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.durationSeconds,
    required this.color,
    required this.icon,
    required this.xpReward,
  });

  /// Predefined timer configurations
  static const List<TimerConfig> presets = [
    // Deep Work Focus - Classic 25 min Pomodoro
    TimerConfig(
      id: 'deep_work',
      name: 'Deep Work Focus',
      description: 'Classic 25-minute Pomodoro session',
      durationSeconds: 1500, // 25 minutes
      color: '#FF6B6B',
      icon: '🎯',
      xpReward: 50,
    ),

    // Start Mission - 50 min project work
    TimerConfig(
      id: 'start_mission',
      name: 'Start Mission',
      description: 'Extended 50-minute project work session',
      durationSeconds: 3000, // 50 minutes
      color: '#4ECDC4',
      icon: '🚀',
      xpReward: 100,
    ),

    // Quick Focus - 10 min quick task
    TimerConfig(
      id: 'quick_focus',
      name: 'Quick Focus',
      description: 'Quick 10-minute focused work',
      durationSeconds: 600, // 10 minutes
      color: '#FFE66D',
      icon: '⚡',
      xpReward: 25,
    ),

    // Marathon Session - 90 min deep work
    TimerConfig(
      id: 'marathon',
      name: 'Marathon Session',
      description: '90-minute extended focus session',
      durationSeconds: 5400, // 90 minutes
      color: '#95E1D3',
      icon: '🔥',
      xpReward: 150,
    ),
  ];

  /// Get preset by ID
  static TimerConfig? getPreset(String id) {
    try {
      return presets.firstWhere((config) => config.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Format duration to MM:SS
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
