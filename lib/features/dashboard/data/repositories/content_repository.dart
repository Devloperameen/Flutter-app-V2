import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Repository for fetching dashboard content from Firestore (REAL DATA ONLY)
class ContentRepository {
  final FirebaseFirestore _firestore;

  ContentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get quotes stream (real-time)
  Stream<String> getQuotesStream() {
    try {
      return _firestore
          .collection('quotes')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return 'Every step forward is progress. Keep going!';
        }
        final doc = snapshot.docs.first.data();
        return doc['text'] as String? ?? 'Keep pushing forward!';
      }).handleError((error) {
        log.e('❌ Quotes stream error: $error');
        // Return default quote on error
        return Stream.value('Focus on what you can control today.');
      });
    } catch (e) {
      log.e('❌ Failed to create quotes stream: $e');
      return Stream.value('You are stronger than you think!');
    }
  }
}

