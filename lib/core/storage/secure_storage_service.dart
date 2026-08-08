import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SAFE — Secure Storage Service
///
/// Uses Flutter Secure Storage for sensitive data encryption.
/// Falls back to SharedPreferences for non-sensitive data.
/// 
/// **SECURITY:** All tokens, passwords, and PII are encrypted at rest.
class SecureStorageService {
  // Secure storage for sensitive data (encrypted)
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initialize the service (no-op for secure storage)
  Future<void> init() async {
    // FlutterSecureStorage doesn't need initialization
  }

  /// Write a sensitive value (encrypted storage)
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Write a value (for backward compatibility)
  Future<void> write(String key, String value) async {
    await writeSecure(key, value);
  }

  /// Read a sensitive value (encrypted storage)
  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Read a value (for backward compatibility)
  Future<String?> read(String key) async {
    return await readSecure(key);
  }

  /// Delete a single key from secure storage
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Wipe all secure storage (used on logout)
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  /// Get all secure storage keys (for debugging - use carefully)
  Future<Map<String, String>> readAll() async {
    return await _secureStorage.readAll();
  }
}
