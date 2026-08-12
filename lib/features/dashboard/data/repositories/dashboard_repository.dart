import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/errors/failures.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:safe/features/dashboard/domain/models/dashboard_data.dart';

part 'dashboard_repository.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = DashboardRemoteDataSource(apiClient: apiClient);
  final authRepository = ref.watch(authRepositoryProvider);
  return DashboardRepository(
    remoteDataSource: remoteDataSource,
    authRepository: authRepository,
  );
}

class DashboardRepository {
  DashboardRepository({
    required this.remoteDataSource,
    required this.authRepository,
  });

  final DashboardRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  /// Get user ID from AuthRepository
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
  /// Uses Express.js backend with MongoDB
  Future<DashboardData> getDashboardData() async {
    try {
      final userId = _getUserId();
      log.d('📍 Retrieved userId: ${userId ?? "null"}');
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      log.d('📊 Loading dashboard from backend...');
      return await remoteDataSource.getDashboardData(userId);
    } catch (e, stackTrace) {
      log.e('❌ Dashboard error: $e', error: e, stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to load dashboard data: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get today's mission
  Future<Map<String, dynamic>?> getTodayMission() async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      return await remoteDataSource.getTodayMission(userId);
    } catch (e, stackTrace) {
      log.e('❌ Failed to load mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to load mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Complete today's mission
  Future<void> completeMission(String missionId, int xpReward) async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await remoteDataSource.completeMission(userId, missionId, xpReward);
    } catch (e, stackTrace) {
      log.e('❌ Failed to complete mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to complete mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Start a mission
  Future<void> startMission(String missionTitle) async {
    try {
      final userId = _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await remoteDataSource.startMission(userId, missionTitle);
    } catch (e, stackTrace) {
      log.e('❌ Failed to start mission: $e', stackTrace: stackTrace);
      throw ServerFailure(
        message: 'Failed to start mission: $e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get daily quote stream
  Stream<String> getDailyQuoteStream() {
    return remoteDataSource.getDailyQuoteStream();
  }

  /// Get dashboard data stream (real-time)
  Stream<DashboardData> getDashboardDataStream() {
    // Return a stream that loads the data
    return Stream.fromFuture(getDashboardData());
  }
}
