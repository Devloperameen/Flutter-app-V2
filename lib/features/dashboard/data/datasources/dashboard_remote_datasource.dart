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

  Future<DashboardData> getDashboardData() async {
    final response = await apiClient.dio.get(ApiEndpoints.dashboardStats);
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
}
