import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:safe/core/providers/core_providers.dart';
import 'package:safe/core/storage/storage_keys.dart';

part 'theme_provider.g.dart';

/// State of the app's theme.
class ThemeState {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.useBlueTheme = true, // true = light blue, false = brown
  });

  final ThemeMode themeMode;
  final bool useBlueTheme;

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? useBlueTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      useBlueTheme: useBlueTheme ?? this.useBlueTheme,
    );
  }
}

/// Provider that manages the app's theme and persists it to local storage.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    return _loadThemeState();
  }

  /// Load saved theme configuration from local storage.
  ThemeState _loadThemeState() {
    final storage = ref.read(localStorageProvider);
    
    // Load theme mode (0 = system, 1 = light, 2 = dark)
    final savedMode = storage.getInt(StorageKeys.themeMode);
    var mode = ThemeMode.system;
    if (savedMode == 1) mode = ThemeMode.light;
    if (savedMode == 2) mode = ThemeMode.dark;

    // Load blue theme toggle (default true)
    final isBlue = storage.getBool('safe_use_blue_theme') ?? true;

    return ThemeState(themeMode: mode, useBlueTheme: isBlue);
  }

  /// Update and persist the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    
    var modeInt = 0;
    if (mode == ThemeMode.light) modeInt = 1;
    if (mode == ThemeMode.dark) modeInt = 2;
    
    final storage = ref.read(localStorageProvider);
    await storage.setInt(StorageKeys.themeMode, modeInt);
  }

  /// Toggle dark mode on/off explicitly (used by switches).
  Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Update and persist the color theme.
  Future<void> setUseBlueTheme(bool useBlue) async {
    state = state.copyWith(useBlueTheme: useBlue);
    
    final storage = ref.read(localStorageProvider);
    await storage.setBool('safe_use_blue_theme', value: useBlue);
  }
}
