import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/errors/failures.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/dashboard/data/datasources/dashboard_firestore_datasource.dart';
import 'package:safe/features/dashboard/domain/models/dashboard_data.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';

part 'dashboard_repository.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  final firestoreDataSource = DashboardFirestoreDataSource();
  final authRepository = ref.watch(authRepositoryProvider);
  return DashboardRepository(
    firestoreDataSource: firestoreDataSource,
    authRepository: authRepository,
  );
}

class DashboardRepository {
  DashboardRepository({
    required this.firestoreDataSource,
    required this.authRepository,
  });

  final DashboardFirestoreDataSource firestoreDataSource;
  final AuthRepository authRepository;

  /// Get user ID from AuthRepository (same as habits)
  String? _getUserId() {
    final userId = authRepository.getCurrentUserId();
    if (userId != null && userId.isNotEmpty) {
      log.d('📍 Got userId from AuthRepository: $userId');
      return userId;
    }
    
    log.w('⚠️ No userId found - user not authenticated');
    return null;
  }

  /// Get dashboard data for current user
  /// Uses real Firestore data only (no mock fallback)
  Future<DashboardData> getDashboardData() async {
    try {
      final userId = _getUserId();
      log.d('📍 Retrieved userId: ${userId ?? "null"}');
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      log.d('📊 Loading dashboard from Firestore...');
      return await firestoreDataSource.getDashboardData(userId);
    } catch (e, stackTrace) {
      log.e('❌ Dashboard error: $e', error: e, stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to load dashboard data: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get today's mission (real Firestore only)
  Future<Map<String, dynamic>?> getTodayMission() async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      return await firestoreDataSource.getTodayMission(userId);
    } catch (e, stackTrace) {
      log.e('❌ Failed to load mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to load mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Complete today's mission (real Firestore only)
  Future<void> completeMission(String missionId, int xpReward) async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await firestoreDataSource.completeMission(userId, missionId, xpReward);
    } catch (e, stackTrace) {
      log.e('❌ Failed to complete mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to complete mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Start a mission (real Firestore only)
  Future<void> startMission(String missionTitle) async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await firestoreDataSource.startMission(userId, missionTitle);
    } catch (e, stackTrace) {
      log.e('❌ Failed to start mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to start mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get daily quote stream (real Firestore only)
  Stream<String> getDailyQuoteStream() {
    return firestoreDataSource.getDailyQuoteStream();
  }

  /// Get dashboard data stream (real-time)
  /// Falls back to mock data if Firestore fails
  Stream<DashboardData> getDashboardDataStream() {
    // Note: This is async, we'll need to handle it differently
    // For now, return a stream that loads the data
    return Stream.fromFuture(getDashboardData());
  }
}
