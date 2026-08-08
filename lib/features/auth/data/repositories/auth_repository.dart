import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/errors/failures.dart';
import 'package:safe/core/storage/secure_storage_service.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:safe/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/core/providers/core_providers.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final firebaseDataSource = AuthFirebaseDataSource();
  final mockDataSource = AuthMockDataSource();
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(
    firebaseDataSource: firebaseDataSource,
    mockDataSource: mockDataSource,
    secureStorage: secureStorage,
  );
}

class AuthRepository {
  AuthRepository({
    required this.firebaseDataSource,
    required this.mockDataSource,
    required this.secureStorage,
  });

  final AuthFirebaseDataSource firebaseDataSource;
  final AuthMockDataSource mockDataSource;
  final SecureStorageService secureStorage;

  /// Login user with Firebase Auth or Mock Data
  Future<User> login(String email, String password) async {
    try {
      // Try Firebase first, fall back to mock if it fails
      try {
        final user = await firebaseDataSource.login(
          email: email,
          password: password,
        );
        await _persistUser(user);
        return user;
      } catch (firebaseError, firebaseStack) {
        log.w('⚠️ Firebase login failed: $firebaseError');
        // Always fall back to mock datasource on any Firebase error
        try {
          log.d('📱 Attempting mock datasource login for: $email');
          final user = await mockDataSource.login(
            email: email,
            password: password,
          );
          log.i('✅ Mock login successful for: $email');
          await _persistUser(user);
          return user;
        } catch (mockError, mockStack) {
          log.e('❌ Mock login also failed: $mockError', error: mockError, stackTrace: mockStack);
          // Both failed - throw a meaningful error
          throw ServerFailure(
            message: 'Login failed. Firebase: $firebaseError, Mock: $mockError',
            stackTrace: mockStack,
          );
        }
      }
    } catch (e, stackTrace) {
      // If we get here, both methods failed
      if (e is ServerFailure) {
        rethrow;
      }
      log.e('❌ Final login error: $e', error: e, stackTrace: stackTrace);
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Register new user with Firebase Auth or Mock Data
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      // Try Firebase first, fall back to mock if it fails
      try {
        final user = await firebaseDataSource.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );
        await _persistUser(user);
        return user;
      } catch (firebaseError) {
        print('⚠️ Firebase register failed, using mock datasource: $firebaseError');
        // Fall back to mock datasource
        final user = await mockDataSource.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );
        await _persistUser(user);
        return user;
      }
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await firebaseDataSource.sendPasswordResetEmail(email);
    } catch (e, stackTrace) {
      throw ServerFailure(
        message: '$e',
        stackTrace: stackTrace,
      );
    }
  }

  /// Verify email address
  Future<void> verifyEmail() async {
    try {
      await firebaseDataSource.verifyEmail();
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
      // Try Firebase first, then mock
      try {
        await firebaseDataSource.logout();
      } catch (_) {
        await mockDataSource.logout();
      }
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await _clearUser();
    }
  }

  /// Get user profile
  Future<User> getProfile() async {
    try {
      final userId = firebaseDataSource.getCurrentUserId();
      if (userId == null) {
        throw Exception('No user signed in');
      }
      return await firebaseDataSource.getProfile(userId);
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
      final userId = firebaseDataSource.getCurrentUserId();
      if (userId == null) {
        throw Exception('No user signed in');
      }

      await firebaseDataSource.updateProfile(
        userId: userId,
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
    return firebaseDataSource.isAuthenticated() || mockDataSource.isAuthenticated();
  }

  /// Get current user (without making network call)
  /// Checks Firebase first, then mock datasource
  User? getCurrentUser() {
    final fbUser = firebaseDataSource.getCurrentUser();
    if (fbUser != null) {
      return fbUser;
    }
    // Fall back to mock datasource
    return mockDataSource.getCurrentUser();
  }

  /// Get current user ID
  /// Checks Firebase first, then mock datasource
  String? getCurrentUserId() {
    final fbUserId = firebaseDataSource.getCurrentUserId();
    if (fbUserId != null) {
      return fbUserId;
    }
    // Fall back to mock datasource
    final mockUser = mockDataSource.getCurrentUser();
    return mockUser?.id;
  }

  /// Get authentication state stream
  Stream<User?> get authStateChanges {
    return firebaseDataSource.authStateChanges
      .map((fbUser) {
        if (fbUser == null) return null;
        return User(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          firstName: fbUser.displayName?.split(' ').first ?? '',
          lastName: fbUser.displayName?.split(' ').skip(1).join(' ') ?? '',
          avatarUrl: fbUser.photoURL,
          isEmailVerified: fbUser.emailVerified,
          createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
        );
      })
      .handleError((error, stackTrace) {
        print('⚠️ Firebase auth stream error: $error');
        // On error, just yield null (no user)
        return null;
      });
  }

  /// Persist user data locally
  Future<void> _persistUser(User user) async {
    try {
      log.i('💾 Persisting user data: ${user.id} / ${user.email}');
      await secureStorage.write(StorageKeys.userId, user.id);
      await secureStorage.write(StorageKeys.userEmail, user.email);
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
