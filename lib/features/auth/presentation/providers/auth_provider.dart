import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/storage/storage_keys.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/auth/domain/models/user.dart';

part 'auth_provider.g.dart';

/// Simple flag to trigger auth state refresh
final authRefreshTrigger = StateProvider<int>((ref) => 0);

/// Represents the current authentication state of the application.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<User?> build() {
    // Whenever refresh trigger changes, we rebuild
    ref.watch(authRefreshTrigger);
    
    // Stream controller so we can emit async state
    return Stream.fromFuture(_resolveCurrentUser());
  }

  /// Restore auth state from secure storage (survives provider rebuilds).
  Future<User?> _resolveCurrentUser() async {
    // 1. First check in-memory cache (fastest path)
    final cached = ref.read(authRepositoryProvider).getCurrentUser();
    if (cached != null) {
      log.d('📍 Auth state: User authenticated (memory) - ${cached.email}');
      return cached;
    }

    // 2. Fall back to secure storage (survives provider disposal)
    final storage = ref.read(secureStorageProvider);
    final userId = await storage.read(StorageKeys.userId);
    final userEmail = await storage.read(StorageKeys.userEmail);
    final accessToken = await storage.read(StorageKeys.accessToken);
    final firstName = await storage.read(StorageKeys.userName);
    final avatarUrl = await storage.read(StorageKeys.userAvatarUrl);

    if (userId != null && userId.isNotEmpty && accessToken != null && accessToken.isNotEmpty && accessToken != 'null') {
      final user = User(
        id: userId,
        email: userEmail ?? '',
        firstName: firstName ?? '',
        lastName: '',
        avatarUrl: avatarUrl,
        isEmailVerified: true,
        createdAt: DateTime.now(),
      );
      // Inject the restored user into the repository so it's available synchronously
      ref.read(authRepositoryProvider).setCurrentUser(user);
      log.d('📍 Auth state: User authenticated (storage) - ${user.email}');
      
      // Fire-and-forget background update to get latest profile (incl real avatar)
      Future.microtask(() async {
        try {
          final fresh = await ref.read(authRepositoryProvider).getProfile();
          ref.read(authRepositoryProvider).setCurrentUser(fresh);
          if (fresh.avatarUrl != null) {
            await storage.write(StorageKeys.userAvatarUrl, fresh.avatarUrl!);
          }
        } catch (_) {}
      });
      
      return user;
    }

    log.d('📍 Auth state: No user authenticated');
    return null;
  }

  /// Login user with real Firebase Auth or Mock Data
  Future<void> login(String email, String password) async {
    try {
      await ref.read(authRepositoryProvider).login(email, password);
      // Small delay to ensure persistence is complete
      await Future.delayed(const Duration(milliseconds: 100));
      // Trigger a refresh to pick up the new auth state
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e) {
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
    } catch (e) {
      // Re-throw so UI can handle the error
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
      // Trigger a refresh to clear the auth state
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e) {
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
      
      // Fetch fresh profile to get the updated avatar URL etc.
      final freshProfile = await ref.read(authRepositoryProvider).getProfile();
      ref.read(authRepositoryProvider).setCurrentUser(freshProfile);
      
      // Also update secure storage if we want to cache the avatar
      final storage = ref.read(secureStorageProvider);
      if (freshProfile.avatarUrl != null) {
        await storage.write(StorageKeys.userAvatarUrl, freshProfile.avatarUrl!);
      }
      
      // Trigger a refresh so the UI updates
      ref.read(authRefreshTrigger.notifier).state++;
    } catch (e) {
      rethrow;
    }
  }
}
