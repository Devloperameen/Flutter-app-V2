import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/storage/local_storage_service.dart';
import 'package:safe/core/storage/secure_storage_service.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';

part 'core_providers.g.dart';

/// Provides the initialized [SharedPreferences] instance.
/// This MUST be overridden in the ProviderScope in main.dart.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
}

/// Provides the [LocalStorageService].
@Riverpod(keepAlive: true)
LocalStorageService localStorage(LocalStorageRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
}

/// Provides the [SecureStorageService].
@Riverpod(keepAlive: true)
SecureStorageService secureStorage(SecureStorageRef ref) {
  // SecureStorageService now uses flutter_secure_storage internally
  // No need to pass SharedPreferences
  return SecureStorageService();
}

/// Provides the [ApiClient] configured with interceptors.
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
}

/// Provides the [AuthRepository].
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  // This is provided by authRepositoryProvider from auth feature
  // We create it here for use in other parts of the app
  return ref.watch(authRepositoryProvider);
}
