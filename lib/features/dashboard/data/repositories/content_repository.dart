import 'package:safe/core/utils/app_logger.dart';

/// Repository for fetching dashboard content (from HTTP backend with MongoDB)
class ContentRepository {
  /// Get quotes stream (real-time)
  Stream<String> getQuotesStream() {
    try {
      // For now, return default quotes
      // In production, would fetch from Express.js backend
      return Stream.periodic(
        const Duration(hours: 1),
        (count) => _getDefaultQuote(count),
      );
    } catch (e) {
      log.e('❌ Failed to create quotes stream: $e');
      return Stream.value('You are stronger than you think!');
    }
  }

  /// Get default quote by index
  static String _getDefaultQuote(int index) {
    final quotes = [
      'Every step forward is progress. Keep going!',
      'Focus on what you can control today.',
      'You are stronger than you think!',
      'Progress over perfection.',
      'Small consistent efforts lead to big results.',
    ];
    return quotes[index % quotes.length];
  }
}

