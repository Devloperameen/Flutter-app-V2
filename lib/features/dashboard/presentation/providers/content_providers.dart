import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/features/dashboard/data/repositories/content_repository.dart';

part 'content_providers.g.dart';

// ─── Repository Provider ───

@riverpod
ContentRepository contentRepository(ContentRepositoryRef ref) {
  return ContentRepository();
}

// ─── Quotes Provider (Real Firestore) ───

@riverpod
Stream<String> quotesStream(QuotesStreamRef ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getQuotesStream();
}

