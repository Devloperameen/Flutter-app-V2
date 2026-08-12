/// ============================================
/// HTTP Datasources Providers
/// ============================================
/// 
/// Riverpod providers for HTTP datasources
/// Replaces Firebase datasources with Express backend
/// 
/// This file provides instances of all HTTP datasources
/// for use throughout the application
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/network/http_auth_datasource.dart';
import 'package:safe/core/network/http_upload_datasource.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/community/data/datasources/http_community_chat_datasource.dart';
import 'package:safe/features/habits/data/datasources/http_habit_datasource.dart';

part 'http_datasources_providers.g.dart';

// ─── Auth Datasource ────────────────────────────────

/// Provider for HTTP Auth Datasource
/// 
/// Usage:
/// ```dart
/// final authDS = ref.watch(httpAuthDatasourceProvider);
/// final response = await authDS.login(email: '...', password: '...');
/// ```
@riverpod
HttpAuthDatasource httpAuthDatasource(HttpAuthDatasourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HttpAuthDatasource(apiClient: apiClient);
}

// ─── Habit Datasource ───────────────────────────────

/// Provider for HTTP Habit Datasource
/// 
/// Usage:
/// ```dart
/// final habitDS = ref.watch(httpHabitDatasourceProvider);
/// final habits = await habitDS.getHabits(userId);
/// ```
@riverpod
HttpHabitDatasource httpHabitDatasource(HttpHabitDatasourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HttpHabitDatasource(apiClient: apiClient);
}

// ─── Community Chat Datasource ──────────────────────

/// Provider for HTTP Community Chat Datasource
/// 
/// Usage:
/// ```dart
/// final chatDS = ref.watch(httpCommunityChatDatasourceProvider);
/// await chatDS.sendDirectMessage(receiverId: '...', message: '...');
/// ```
@riverpod
HttpCommunityChatDatasource httpCommunityChatDatasource(
  HttpCommunityChatDatasourceRef ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return HttpCommunityChatDatasource(apiClient: apiClient);
}

// ─── Upload Datasource ──────────────────────────


/// Provider for HTTP Upload Datasource
/// 
/// Usage:
/// ```dart
/// final uploadDS = ref.watch(httpUploadDatasourceProvider);
/// final response = await uploadDS.uploadAvatar(filePath: '...');
/// ```
@riverpod
HttpUploadDatasource httpUploadDatasource(HttpUploadDatasourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HttpUploadDatasource(apiClient: apiClient);
}
