import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Mock authentication datasource for offline/demo mode
/// 
/// This is used when Firebase is not available or for testing purposes.
/// It simulates user authentication without network connectivity.
class AuthMockDataSource {
  static final AuthMockDataSource _instance = AuthMockDataSource._internal();

  factory AuthMockDataSource() {
    return _instance;
  }

  AuthMockDataSource._internal();

  User? _currentUser;
  final List<User> _users = [
    User(
      id: 'demo-user-001',
      email: 'demo@safe.com',
      firstName: 'Demo',
      lastName: 'User',
      avatarUrl: null,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    ),
  ];

  /// Login user with mock data
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      log.i('🔐 [MOCK] Logging in user: $email');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Find user by email
      final user = _users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('User not found'),
      );

      // Set current user
      _currentUser = user;
      log.i('✅ [MOCK] User logged in: ${user.email}');

      return user;
    } catch (e, st) {
      log.e('❌ [MOCK] Login error: $e', stackTrace: st);
      throw Exception('Login failed: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      log.i('🚪 [MOCK] Logging out user...');
      await Future.delayed(const Duration(milliseconds: 300));
      _currentUser = null;
      log.i('✅ [MOCK] User logged out');
    } catch (e, st) {
      log.e('❌ [MOCK] Logout error: $e', stackTrace: st);
      throw Exception('Logout failed: $e');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }

  /// Get authentication state stream
  Stream<User?> get authStateChanges {
    return Stream.value(_currentUser);
  }

  /// Register new user
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      log.i('📝 [MOCK] Registering new user: $email');

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Create new user
      final newUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: null,
        isEmailVerified: false,
        createdAt: DateTime.now(),
      );

      _users.add(newUser);
      _currentUser = newUser;

      log.i('✅ [MOCK] User registered: $email');
      return newUser;
    } catch (e, st) {
      log.e('❌ [MOCK] Registration error: $e', stackTrace: st);
      throw Exception('Registration failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      log.i('📧 [MOCK] Sending password reset email to: $email');
      await Future.delayed(const Duration(milliseconds: 500));
      log.i('✅ [MOCK] Password reset email sent');
    } catch (e, st) {
      log.e('❌ [MOCK] Password reset error: $e', stackTrace: st);
      throw Exception('Password reset failed: $e');
    }
  }

  /// Verify email address
  Future<void> verifyEmail() async {
    try {
      log.i('📧 [MOCK] Verifying email...');
      await Future.delayed(const Duration(milliseconds: 500));
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(isEmailVerified: true);
      }
      log.i('✅ [MOCK] Email verified');
    } catch (e, st) {
      log.e('❌ [MOCK] Email verification error: $e', stackTrace: st);
      throw Exception('Email verification failed: $e');
    }
  }

  /// Get user profile
  Future<User> getProfile(String userId) async {
    try {
      log.i('👤 [MOCK] Fetching user profile: $userId');
      await Future.delayed(const Duration(milliseconds: 300));

      final user = _users.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User profile not found'),
      );

      return user;
    } catch (e, st) {
      log.e('❌ [MOCK] Get profile error: $e', stackTrace: st);
      throw Exception('Failed to get profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String userId,
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
      log.i('✏️ [MOCK] Updating user profile: $userId');
      await Future.delayed(const Duration(milliseconds: 500));
      log.i('✅ [MOCK] User profile updated');
    } catch (e, st) {
      log.e('❌ [MOCK] Update profile error: $e', stackTrace: st);
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _currentUser?.id;
  }
}
