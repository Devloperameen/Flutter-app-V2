import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'firebase_options.dart';

/// Firebase service initialization and configuration
class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await _firestore.enableNetwork();
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _configureAuth();
      
      // Initialize demo user for testing
      await _initializeDemoUser();

      log.i('✅ Firebase initialized successfully');
    } catch (e, st) {
      log.e('❌ Firebase initialization failed: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  static Future<void> _initializeDemoUser() async {
    try {
      const demoEmail = 'demo@safe.com';
      
      // Generate secure demo password
      final demoPassword = _generateSecureDemoPassword();

      // Check if demo user exists
      try {
        await _auth.signInWithEmailAndPassword(
          email: demoEmail,
          password: demoPassword,
        );
        log.i('✅ Demo user already exists');
        await _auth.signOut();
      } catch (e) {
        // Demo user doesn't exist, create it
        if (e.toString().contains('user-not-found')) {
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: demoEmail,
            password: demoPassword,
          );
          
          await userCredential.user?.updateDisplayName('Demo User');
          
          // Create demo user profile in Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'id': userCredential.user!.uid,
            'email': demoEmail,
            'firstName': 'Demo',
            'lastName': 'User',
            'displayName': 'Demo User',
            'avatarUrl': null,
            'bio': 'This is a demo account for testing the SAFE app',
            'country': '',
            'gender': '',
            'occupation': '',
            'dateOfBirth': null,
            'totalXp': 0,
            'currentLevel': 1,
            'currentStreak': 0,
            'longestStreak': 0,
            'lastActiveDate': DateTime.now().toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'emailVerified': true,
          });
          
          log.i('✅ Demo user created successfully');
          await _auth.signOut();
        }
      }
    } catch (e) {
      log.w('⚠️ Error initializing demo user: $e');
    }
  }

  /// Generate secure demo password (for development only)
  static String _generateSecureDemoPassword() {
    // In production, this should be loaded from secure environment variables
    // For demo purposes, use a more complex password
    return 'Demo\$ecure2024!@#';
  }

  static void _configureAuth() {
    if (kIsWeb) {
      _auth.setPersistence(Persistence.LOCAL);
    }

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        log.i('🔓 User logged out');
      } else {
        log.i('🔒 User logged in: ${user.email}');
      }
    });
  }

  static User? getCurrentUser() => _auth.currentUser;
  static bool isAuthenticated() => _auth.currentUser != null;
  static String? getUserId() => _auth.currentUser?.uid;
  static String? getUserEmail() => _auth.currentUser?.email;

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      log.i('✅ User signed out');
    } catch (e) {
      log.e('❌ Sign out failed: $e', error: e);
      rethrow;
    }
  }
}
