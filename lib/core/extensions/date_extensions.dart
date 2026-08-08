/// Extensions on [DateTime] for formatting and comparison.
extension DateTimeExtensions on DateTime {
  /// Format as "Jan 15, 2024"
  String get formatted {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[month - 1]} $day, $year';
  }

  /// Format as "Monday, January 15"
  String get formattedLong {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return '${days[weekday - 1]}, ${months[month - 1]} $day';
  }

  /// Format as "3:30 PM"
  String get formattedTime {
    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final period = this.hour < 12 ? 'AM' : 'PM';
    final minStr = minute.toString().padLeft(2, '0');
    return '$hour:$minStr $period';
  }

  /// Format as "Jan 15, 3:30 PM"
  String get formattedDateTime => '$formatted, $formattedTime';

  /// Is this date today?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Is this date yesterday?
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Is this date tomorrow?
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get relative time string (e.g., "2 hours ago", "just now")
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    }
    return formatted;
  }

  /// Start of the day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Start of the week (Monday)
  DateTime get startOfWeek {
    final daysToSubtract = weekday - DateTime.monday;
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  /// Is the same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

