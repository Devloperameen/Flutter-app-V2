import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/auth/domain/models/user.dart';

part 'auth_provider.g.dart';

/// Simple flag to trigger auth state refresh
final authRefreshTrigger = StateProvider<int>((ref) => 0);

/// Represents the current authentication state of the application.
/// 
/// Watches both Firebase auth and the refresh trigger to ensure
/// we properly track authentication from any source (Firebase or Mock).
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<User?> build() {
    // Whenever refresh trigger changes, we rebuild
    ref.watch(authRefreshTrigger);
    
    // Get the current authenticated user from the repository
    // This checks both Firebase and stored state
    final currentUser = ref.read(authRepositoryProvider).getCurrentUser();
    
    if (currentUser != null) {
      log.d('📍 Auth state: User authenticated - ${currentUser.email}');
      // Emit the current user immediately
      return Stream.value(currentUser);
    } else {
      log.d('📍 Auth state: No user authenticated');
      // Also listen to Firebase auth changes for real-time updates
      return ref.read(authRepositoryProvider).authStateChanges;
    }
  }

  /// Login user with real Firebase Auth or Mock Data
  Future<void> login(String email, String password) async {
    try {
      await ref.read(authRepositoryProvider).login(email, password);
      // Small delay to ensure persistence is complete
      await Future.delayed(const Duration(milliseconds: 100));
      // Trigger a refresh to pick up the new auth state
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e, st) {
      // Re-throw so UI can handle the error
      rethrow;
    }
  }

  /// Register new user with real Firebase Auth or Mock Data
  Future<void> register(String firstName, String lastName, String email, String password) async {
    try {
      await ref.read(authRepositoryProvider).register(firstName, lastName, email, password);
      // Trigger a refresh to pick up the new auth state
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e, st) {
      // Re-throw so UI can handle the error
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
    } catch (e, st) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
      // Trigger a refresh to clear the auth state
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e, st) {
      rethrow;
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
      await ref.read(authRepositoryProvider).updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        country: country,
        gender: gender,
        occupation: occupation,
        dateOfBirth: dateOfBirth,
        avatarUrl: avatarUrl,
      );
    } catch (e, st) {
      rethrow;
    }
  }
}
