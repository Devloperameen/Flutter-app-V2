import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/network/api_response.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/features/dashboard/domain/models/dashboard_data.dart';

part 'dashboard_remote_datasource.g.dart';

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(DashboardRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRemoteDataSource(apiClient: apiClient);
}

class DashboardRemoteDataSource {
  DashboardRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<DashboardData> getDashboardData(String userId) async {
    final response = await apiClient.dio.get(
      ApiEndpoints.dashboardStats,
      queryParameters: {'userId': userId}, // ✅ FIXED: Pass userId parameter
    );
    final apiResponse = ApiResponse<DashboardData>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => DashboardData.fromJson(data as Map<String, dynamic>),
    );
    
    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse.error?.message ?? 'Failed to fetch dashboard data',
    );
  }

  // ✅ FIXED: Add methods for getting mission, completing mission, starting mission
  
  Future<Map<String, dynamic>?> getTodayMission(String userId) async {
    try {
      final response = await apiClient.dio.get(
        '/dashboard/mission',
        queryParameters: {'userId': userId},
      );
      
      if (response.data != null && response.data is Map<String, dynamic>) {
        return response.data['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> completeMission(String userId, String missionId, int xpReward) async {
    final response = await apiClient.dio.post(
      '/dashboard/mission/complete',
      data: {
        'userId': userId,
        'missionId': missionId,
        'xpReward': xpReward,
      },
    );
    
    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to complete mission',
      );
    }
  }

  Future<void> startMission(String userId, String missionTitle) async {
    final response = await apiClient.dio.post(
      '/dashboard/mission/start',
      data: {
        'userId': userId,
        'missionTitle': missionTitle,
      },
    );
    
    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Failed to start mission',
      );
    }
  }

  // ✅ FIXED: Wire quote to real endpoint
  Stream<String> getDailyQuoteStream() {
    return Stream.periodic(const Duration(hours: 24), (_) {})
        .startWith(0)
        .asyncMap((_) async {
      try {
        final response = await apiClient.dio.get(ApiEndpoints.contentQuoteToday);
        
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final quoteText = (data['data']?['text'] ?? data['text']) as String? ?? 'Stay focused!';
          return quoteText;
        }
        return 'Stay focused and keep grinding!';
      } catch (e) {
        return 'Stay focused and keep grinding!';
      }
    });
  }
}
