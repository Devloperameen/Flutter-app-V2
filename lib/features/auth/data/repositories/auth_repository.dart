import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/errors/failures.dart';
import 'package:safe/core/storage/secure_storage_service.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/core/network/http_auth_datasource.dart';
import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/core/providers/core_providers.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final httpDataSource = HttpAuthDataSource();
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(
    httpDataSource: httpDataSource,
    secureStorage: secureStorage,
  );
}

class AuthRepository {
  AuthRepository({
    required this.httpDataSource,
    required this.secureStorage,
  });

  final HttpAuthDataSource httpDataSource;
  final SecureStorageService secureStorage;

  /// Login user with HTTP Backend
  Future<User> login(String email, String password) async {
    try {
      final response = await httpDataSource.login(
        email: email,
        password: password,
      );
      await _persistUser(response['user'] as User, response['token'] as String);
      return response['user'] as User;
    } catch (e, stackTrace) {
      log.e('❌ Login error: $e', error: e, stackTrace: stackTrace);
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Register new user with HTTP Backend
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await httpDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      await _persistUser(response['user'] as User, response['token'] as String);
      return response['user'] as User;
    } catch (e, stackTrace) {
      log.e('❌ Register error: $e', error: e, stackTrace: stackTrace);
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await httpDataSource.sendPasswordReset(email);
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await httpDataSource.logout();
    } catch (e) {
      log.w('⚠️ Logout error (ignored): $e');
      // Ignore errors on logout
    } finally {
      await _clearUser();
    }
  }

  /// Get user profile
  Future<User> getProfile() async {
    try {
      return await httpDataSource.getProfile();
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
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
      await httpDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        country: country,
        gender: gender,
        occupation: occupation,
        dateOfBirth: dateOfBirth,
        avatarUrl: avatarUrl,
      );
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return httpDataSource.isAuthenticated();
  }

  /// Get current user (without making network call)
  User? getCurrentUser() {
    return httpDataSource.getCurrentUser();
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return httpDataSource.getCurrentUserId();
  }

  /// Get authentication state stream
  Stream<User?> get authStateChanges {
    return httpDataSource.authStateChanges;
  }

  /// Persist user data locally
  Future<void> _persistUser(User user, String token) async {
    try {
      log.i('💾 Persisting user data: ${user.id} / ${user.email}');
      await secureStorage.write(StorageKeys.userId, user.id);
      await secureStorage.write(StorageKeys.userEmail, user.email);
      await secureStorage.write(StorageKeys.authToken, token);
      log.i('✅ User data persisted successfully');
    } catch (e) {
      log.e('❌ Failed to persist user data: $e', error: e);
    }
  }

  /// Clear user data locally
  Future<void> _clearUser() async {
    await secureStorage.delete(StorageKeys.userId);
    await secureStorage.delete(StorageKeys.userEmail);
  }
}
