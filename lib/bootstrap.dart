import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safe/core/services/firebase_service.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Bootstrap the application.
///
/// This function runs before the app starts and initializes:
/// - Flutter bindings
/// - SharedPreferences
/// - Firebase
/// - System UI configuration
Future<SharedPreferences> bootstrap() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first (required for auth and other services)
  try {
    await FirebaseService.initialize();
    log.i('✅ Firebase initialized');
  } catch (e) {
    log.e('❌ Firebase initialization failed: $e', error: e);
    // Continue anyway - app can work with mock data if Firebase unavailable
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Configure system UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  log.i('✅ SAFE bootstrap complete');

  return prefs;
}
