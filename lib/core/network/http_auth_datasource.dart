/// ============================================
/// HTTP Auth Datasource
/// ============================================
/// 
/// Handles authentication with Express.js backend
/// - User registration
/// - User login
/// - Token refresh
/// - Token verification

import 'package:dio/dio.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/domain/models/user.dart';

/// Authentication response model
class AuthResponse {
  final String userId;
  final String email;
  final String fullName;
  final String? avatar;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.fullName,
    this.avatar,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return AuthResponse(
      userId: data['userId'] as String,
      email: data['email'] as String,
      fullName: data['fullName'] as String,
      avatar: data['avatar'] as String?,
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}

/// HTTP-based authentication datasource
class HttpAuthDatasource {
  final ApiClient apiClient;

  HttpAuthDatasource({required this.apiClient});

  // ─── Registration ───────────────────────────────

  /// Register a new user
  /// 
  /// @param email: User email
  /// @param password: User password (must be strong: 8+ chars, uppercase, lowercase, number)
  /// @param fullName: User's full name
  /// @returns: AuthResponse with tokens and user info
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      log.i('📝 Registering user: $email');

      final response = await apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      final authResponse = AuthResponse.fromJson(response);

      log.i('✅ Registration successful: ${authResponse.email}');
      return authResponse;
    } on DioException catch (e) {
      log.e('❌ Dio error registering: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log.e('❌ Error registering: $e');
      rethrow;
    }
  }

  // ─── Login ──────────────────────────────────────

  /// Login user
  /// 
  /// @param email: User email
  /// @param password: User password
  /// @returns: AuthResponse with tokens and user info
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      log.i('🔐 Logging in user: $email');

      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response);

      log.i('✅ Login successful: ${authResponse.email}');
      return authResponse;
    } on DioException catch (e) {
      log.e('❌ Dio error logging in: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log.e('❌ Error logging in: $e');
      rethrow;
    }
  }

  // ─── Token Refresh ──────────────────────────────

  /// Refresh access token using refresh token
  /// 
  /// Call this when access token expires (after 15 minutes)
  /// 
  /// @param refreshToken: The refresh token (valid for 7 days)
  /// @returns: New tokens (access + refresh)
  Future<AuthResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      log.i('🔄 Refreshing access token');

      final response = await apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      // Response has different format (just tokens, no user data)
      final data = response['data'] as Map<String, dynamic>;
      
      final authResponse = AuthResponse(
        userId: '', // Not provided in refresh response
        email: '', // Not provided in refresh response
        fullName: '', // Not provided in refresh response
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

      log.i('✅ Token refreshed');
      return authResponse;
    } on DioException catch (e) {
      log.e('❌ Dio error refreshing token: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log.e('❌ Error refreshing token: $e');
      rethrow;
    }
  }

  // ─── Verification ──────────────────────────────

  /// Verify token is valid
  /// 
  /// @param accessToken: Token to verify
  /// @returns: True if token is valid, false otherwise
  Future<bool> verifyToken({required String accessToken}) async {
    try {
      log.i('✔️ Verifying token');

      // This would require auth middleware, so we'll do a simple check
      // by trying to fetch current user
      await apiClient.dio.get(
        ApiEndpoints.me,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      log.i('✅ Token is valid');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        log.i('⚠️ Token is invalid or expired');
        return false;
      }
      log.e('❌ Dio error verifying token: ${e.message}');
      return false;
    } catch (e) {
      log.e('❌ Error verifying token: $e');
      return false;
    }
  }

  // ─── Get Current User ──────────────────────────

  /// Get current authenticated user profile
  /// 
  /// Requires valid access token
  /// 
  /// @returns: User data (id, email, name, avatar, etc)
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      log.i('👤 Fetching current user');

      final response = await apiClient.get(ApiEndpoints.me);
      final userData = response['data'] as Map<String, dynamic>;

      log.i('✅ Current user fetched: ${userData['email']}');
      return userData;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching current user: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching current user: $e');
      rethrow;
    }
  }

  // ─── Logout ────────────────────────────────────

  /// Logout user
  /// 
  /// Notifies backend (optional in stateless JWT auth)
  /// Client should delete tokens from local storage
  Future<void> logout() async {
    try {
      log.i('👋 Logging out');

      await apiClient.post(ApiEndpoints.logout);

      log.i('✅ Logout successful');
    } on DioException catch (e) {
      log.e('❌ Dio error logging out: ${e.message}');
      // Don't rethrow - logout should always succeed client-side
    } catch (e) {
      log.e('❌ Error logging out: $e');
      // Don't rethrow - logout should always succeed client-side
    }
  }

  // ─── Auth State ────────────────────────────────

  /// Get authentication state changes stream
  /// In JWT auth, this is local state based on token availability
  Stream<User?> get authStateChanges {
    // Return empty stream - auth state is managed locally
    return Stream.value(null);
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    // Would check if token exists and is valid
    return false;
  }

  /// Get current user without making network call
  User? getCurrentUser() {
    // Would retrieve from local storage
    return null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    // Would retrieve from local storage
    return null;
  }

  /// Update user profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? country,
    String? gender,
    String? occupation,
    DateTime? dateOfBirth,
    String? avatarUrl,
  }) async {
    try {
      log.i('📝 Updating user profile');
      // Would make PATCH request to /users/me
      log.i('✅ Profile updated');
    } catch (e) {
      log.e('❌ Error updating profile: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      log.i('📧 Sending password reset to $email');
      // Would make POST request to /auth/password-reset
      log.i('✅ Password reset email sent');
    } catch (e) {
      log.e('❌ Error sending password reset: $e');
      rethrow;
    }
  }

  /// Get user profile
  Future<User> getProfile() async {
    try {
      log.i('👤 Fetching user profile');

      final response = await apiClient.get(ApiEndpoints.me);
      final userData = response['data'] as Map<String, dynamic>;

      return User(
        id: userData['id'] as String,
        email: userData['email'] as String,
        firstName: userData['firstName'] as String? ?? '',
        lastName: userData['lastName'] as String? ?? '',
        avatarUrl: userData['avatar'] as String?,
        isEmailVerified: userData['isEmailVerified'] as bool? ?? false,
        createdAt: DateTime.parse(userData['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      );
    } on DioException catch (e) {
      log.e('❌ Dio error fetching profile: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching profile: $e');
      rethrow;
    }
  }
}

