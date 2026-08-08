/// Inspiration post with image
class Inspiration {
  final String id;
  final String title;
  final String content;
  final String imageUrl; // Image URL or emoji
  final String icon;
  final String category; // motivation, tips, achievement, etc

  const Inspiration({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.icon,
    required this.category,
  });

  /// Predefined inspiration posts with images/emojis
  static const List<Inspiration> dailyInspirations = [
    Inspiration(
      id: 'focus_skill',
      title: 'Focus is a Skill',
      content: 'Deep focus isn\'t talent—it\'s a skill you build one session at a time. Start small, build big.',
      imageUrl: '🧠',
      icon: '💡',
      category: 'motivation',
    ),
    Inspiration(
      id: 'consistency',
      title: 'Consistency Wins',
      content: 'Small daily sessions compound into extraordinary results over time. Your future self will thank you.',
      imageUrl: '📈',
      icon: '⭐',
      category: 'tips',
    ),
    Inspiration(
      id: 'you_got_this',
      title: 'You Got This!',
      content: 'Every Pomodoro completed is a step towards your goals. Every minute focused is a victory. Keep going!',
      imageUrl: '💪',
      icon: '🔥',
      category: 'achievement',
    ),
    Inspiration(
      id: 'flow_state',
      title: 'Enter the Flow',
      content: 'The first 5 minutes are the hardest. After that, flow happens naturally. Push through the initial resistance.',
      imageUrl: '🌊',
      icon: '✨',
      category: 'tips',
    ),
    Inspiration(
      id: 'brain_power',
      title: 'Maximize Brain Power',
      content: 'Your brain is like a muscle. Focus sessions strengthen it. Rest between sessions to recover and grow.',
      imageUrl: '🎯',
      icon: '🧠',
      category: 'motivation',
    ),
    Inspiration(
      id: 'momentum',
      title: 'Build Momentum',
      content: 'Each completed session creates momentum for the next. You\'re building unstoppable focus power.',
      imageUrl: '🚀',
      icon: '⚡',
      category: 'achievement',
    ),
  ];

  /// Get random inspiration
  static Inspiration getRandom() {
    return dailyInspirations[
        DateTime.now().millisecondsSinceEpoch % dailyInspirations.length
    ];
  }

  /// Get multiple random inspirations
  static List<Inspiration> getRandomMultiple(int count) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final result = <Inspiration>[];
    for (int i = 0; i < count; i++) {
      result.add(
        dailyInspirations[
            (random + i) % dailyInspirations.length
        ],
      );
    }
    return result;
  }
}


