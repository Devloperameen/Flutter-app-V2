import 'package:riverpod/riverpod.dart';
import 'package:safe/core/network/api_client.dart';
import 'package:safe/core/storage/local_storage_service.dart';
import 'package:safe/core/storage/secure_storage_service.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the initialized [SharedPreferences] instance.
/// This MUST be overridden in the ProviderScope in main.dart.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

/// Provides the [LocalStorageService].
final localStorageProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

/// Provides the [SecureStorageService].
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  // SecureStorageService now uses flutter_secure_storage internally
  // No need to pass SharedPreferences
  return SecureStorageService();
});

/// Provides the [ApiClient] configured with interceptors.
final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

