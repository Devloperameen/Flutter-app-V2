/// ============================================
/// HTTP Auth Datasource
/// ============================================
/// 
/// Handles authentication with Express.js backend
/// - User registration
/// - User login
/// - Token management
/// - User state caching
library;

import 'package:dio/dio.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/network/api_endpoints.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/domain/models/user.dart';

/// Authentication response model
class AuthResponse {

  AuthResponse({
    required this.userId,
    required this.email,
    required this.fullName,
    this.avatar,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Backend response structure might vary (nested 'data' or flat)
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    
    if (data.isEmpty) {
      throw Exception('Invalid auth response: missing data field');
    }
    
    return AuthResponse(
      userId: (data['userId'] ?? data['id'] ?? data['_id'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      fullName: (data['fullName'] ?? data['name'] ?? '') as String,
      avatar: data['avatar'] as String?,
      accessToken: (data['accessToken'] ?? data['token'] ?? '') as String,
      refreshToken: (data['refreshToken'] ?? '') as String,
    );
  }
  final String userId;
  final String email;
  final String fullName;
  final String? avatar;
  final String accessToken;
  final String refreshToken;
}

/// HTTP-based authentication datasource
class HttpAuthDatasource {

  HttpAuthDatasource({required this.apiClient});
  final ApiClient apiClient;

  /// Cache for current logged-in user
  User? _currentUser;

  /// Set the current user directly (e.g., when restoring from local storage)
  void setCurrentUser(User user) {
    _currentUser = user;
  }

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

      // Check if response indicates success
      final isSuccess = response['success'] as bool? ?? false;
      if (!isSuccess) {
        // Extract error message from error response
        final errorMsg = response['message'] as String? ?? 'Registration failed';
        log.e('❌ Registration failed: $errorMsg');
        throw Exception(errorMsg);
      }

      final authResponse = AuthResponse.fromJson(response);

      // Cache the user
      _currentUser = User(
        id: authResponse.userId,
        email: authResponse.email,
        firstName: authResponse.fullName.split(' ').first,
        lastName: authResponse.fullName.split(' ').length > 1 
          ? authResponse.fullName.split(' ').skip(1).join(' ')
          : '',
        avatarUrl: authResponse.avatar,
        createdAt: DateTime.now(),
      );

      log.i('✅ Registration successful: ${authResponse.email}');
      return authResponse;
    } on DioException catch (e) {
      // Extract meaningful error message from backend response
      var errorMsg = 'Registration failed';
      
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          if (data['message'] != null) {
            errorMsg = data['message'].toString();
          } else if (data['errors'] != null && data['errors'] is List && (data['errors'] as List).isNotEmpty) {
            errorMsg = (data['errors'] as List).first.toString();
          }
        }
      }
      
      log.e('❌ Dio error registering: $errorMsg');
      throw errorMsg;
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

      // Check if response indicates success
      final isSuccess = response['success'] as bool? ?? false;
      if (!isSuccess) {
        // Extract error message from error response
        final errorMsg = response['message'] as String? ?? 'Login failed';
        log.e('❌ Login failed: $errorMsg');
        throw Exception(errorMsg);
      }

      final authResponse = AuthResponse.fromJson(response);

      // Cache the user
      _currentUser = User(
        id: authResponse.userId,
        email: authResponse.email,
        firstName: authResponse.fullName.split(' ').first,
        lastName: authResponse.fullName.split(' ').length > 1 
          ? authResponse.fullName.split(' ').skip(1).join(' ')
          : '',
        avatarUrl: authResponse.avatar,
        createdAt: DateTime.now(),
      );

      log.i('✅ Login successful: ${authResponse.email}');
      return authResponse;
    } on DioException catch (e) {
      // Extract meaningful error message from backend response
      var errorMsg = 'Login failed';
      
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          if (data['message'] != null) {
            errorMsg = data['message'].toString();
          } else if (data['errors'] != null && data['errors'] is List && (data['errors'] as List).isNotEmpty) {
            errorMsg = (data['errors'] as List).first.toString();
          }
        }
      }
      
      log.e('❌ Dio error logging in: $errorMsg');
      throw errorMsg;
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
        userId: _currentUser?.id ?? '', // Keep existing user ID
        email: _currentUser?.email ?? '', // Keep existing email
        fullName: _currentUser != null ? '${_currentUser!.firstName} ${_currentUser!.lastName}' : '', // Combine first and last
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

  // ─── Logout ────────────────────────────────────

  /// Logout user
  /// 
  /// Notifies backend (optional in stateless JWT auth)
  /// Client should delete tokens from local storage
  Future<void> logout() async {
    try {
      log.i('👋 Logging out');

      await apiClient.post(ApiEndpoints.logout);
      
      // Clear cached user
      _currentUser = null;

      log.i('✅ Logout successful');
    } on DioException catch (e) {
      log.e('❌ Dio error logging out: ${e.message}');
      // Don't rethrow - logout should always succeed client-side
    } catch (e) {
      log.e('❌ Error logging out: $e');
      // Don't rethrow - logout should always succeed client-side
    }
  }

  // ─── Auth State ────────────────────────────

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }

  /// Get current user without making network call
  User? getCurrentUser() {
    return _currentUser;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _currentUser?.id;
  }

  /// Auth state changes stream
  Stream<User?> get authStateChanges {
    return Stream.value(_currentUser);
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

      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (bio != null) data['bio'] = bio;
      if (country != null) data['country'] = country;
      if (gender != null) data['gender'] = gender;
      if (occupation != null) data['occupation'] = occupation;
      if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth.toIso8601String();
      if (avatarUrl != null) data['avatar'] = avatarUrl;

      await apiClient.put('/users/me', data: data);

      log.i('✅ Profile updated');
    } on DioException catch (e) {
      log.e('❌ Dio error updating profile: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error updating profile: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      log.i('📧 Sending password reset to $email');

      await apiClient.post(
        '/auth/password-reset',
        data: {'email': email},
      );

      log.i('✅ Password reset email sent');
    } on DioException catch (e) {
      log.e('❌ Dio error sending reset: ${e.message}');
      rethrow;
    } catch (e) {
      log.e('❌ Error sending reset: $e');
      rethrow;
    }
  }

  /// Get user profile
  Future<User> getProfile() async {
    try {
      log.i('👤 Fetching user profile');

      final response = await apiClient.get(ApiEndpoints.me);
      final userData = response['data'] as Map<String, dynamic>?;
      
      if (userData == null) {
        throw Exception('No user data in response');
      }

      // Safe casting with fallbacks
      final user = User(
        id: (userData['id'] ?? userData['_id'] ?? '') as String,
        email: (userData['email'] ?? '') as String,
        firstName: (userData['firstName'] ?? userData['first_name'] ?? '') as String,
        lastName: (userData['lastName'] ?? userData['last_name'] ?? '') as String,
        avatarUrl: (userData['avatar'] ?? userData['avatarUrl']) as String?,
        isEmailVerified: (userData['isEmailVerified'] ?? userData['email_verified'] ?? false) as bool,
        createdAt: DateTime.tryParse((userData['createdAt'] ?? userData['created_at'] ?? '') as String) ?? DateTime.now(),
      );

      // Update cached user
      _currentUser = user;

      log.i('✅ Profile fetched: ${user.email}');
      return user;
    } on DioException catch (e) {
      log.e('❌ Dio error fetching profile: ${e.message}');
      log.e('Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log.e('❌ Error fetching profile: $e');
      rethrow;
    }
  }
}
