import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// SAFE — Local Storage Service
///
/// Wraps [SharedPreferences] for non-sensitive user preferences:
/// - Theme mode
/// - Onboarding state
/// - Cached data for offline-first
///
/// For tokens and secrets, use [SecureStorageService] instead.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  // ─── String ─────────────────────────────────────

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  // ─── Bool ───────────────────────────────────────

  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  // ─── Int ────────────────────────────────────────

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  // ─── JSON (for cached objects) ──────────────────

  Future<bool> setJson(String key, Map<String, dynamic> json) =>
      _prefs.setString(key, jsonEncode(json));

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Store a list of JSON objects (e.g. cached habits).
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));

  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  // ─── Remove / Clear ────────────────────────────

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();
}
