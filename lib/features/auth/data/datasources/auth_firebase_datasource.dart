import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/core/utils/app_logger.dart';

/// Firebase-based authentication data source
///
/// Replaces mock authentication with real Firebase Auth
/// Handles user registration, login, logout, and profile management
class AuthFirebaseDataSource {
  AuthFirebaseDataSource({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Initialize demo user on app startup
  static Future<void> initializeDemoUser() async {
    try {
      final auth = fb.FirebaseAuth.instance;
      const demoEmail = 'demo@safe.com';
      
      // Generate secure demo password
      final demoPassword = _generateSecureDemoPassword();

      // Check if demo user exists
      try {
        await auth.signInWithEmailAndPassword(
          email: demoEmail,
          password: demoPassword,
        );
        log.i('✅ Demo user already exists');
        await auth.signOut();
      } catch (e) {
        // Demo user doesn't exist, create it
        if (e.toString().contains('user-not-found')) {
          final userCredential = await auth.createUserWithEmailAndPassword(
            email: demoEmail,
            password: demoPassword,
          );
          
          await userCredential.user?.updateDisplayName('Demo User');
          
          // Create demo user profile in Firestore
          await FirebaseFirestore.instance
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
          await auth.signOut();
        }
      }
    } catch (e) {
      log.e('⚠️ Error initializing demo user: $e');
    }
  }

  /// Generate secure demo password (for development only)
  static String _generateSecureDemoPassword() {
    // In production, this should be loaded from secure environment variables
    // For demo purposes, use a more complex password
    return 'Demo\$ecure2024!@#';
  }

  /// Get current user from Firebase
  User? getCurrentUser() {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      firstName: fbUser.displayName?.split(' ').first ?? '',
      lastName: fbUser.displayName?.split(' ').skip(1).join(' ') ?? '',
      avatarUrl: fbUser.photoURL,
      isEmailVerified: fbUser.emailVerified,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Register new user with Firebase Auth
  ///
  /// Steps:
  /// 1. Create user account with Firebase Auth
  /// 2. Update display name
  /// 3. Create user profile in Firestore
  /// 4. Return created user
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      log.i('📝 Registering new user: $email');

      // Create Firebase Auth user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw Exception('Failed to create user account');
      }

      log.i('✅ Firebase Auth user created: ${fbUser.uid}');

      // Update display name
      await fbUser.updateDisplayName('$firstName $lastName');
      await fbUser.reload();

      // Create user profile in Firestore
      final userProfile = {
        'id': fbUser.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': '$firstName $lastName',
        'avatarUrl': null,
        'bio': '',
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
        'emailVerified': false,
      };

      await _firestore.collection('users').doc(fbUser.uid).set(userProfile);

      log.i('✅ User profile created in Firestore: ${fbUser.uid}');

      // Send verification email
      await fbUser.sendEmailVerification();
      log.i('📧 Verification email sent to: $email');

      // Return user object
      return User(
        id: fbUser.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: null,
        isEmailVerified: false,
        createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      );
    } on fb.FirebaseAuthException catch (e) {
      log.e('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e, st) {
      log.e('❌ Registration error: $e', stackTrace: st);
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user with Firebase Auth
  ///
  /// Steps:
  /// 1. Sign in with email and password
  /// 2. Update last active date in Firestore
  /// 3. Return user
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      log.i('🔐 Logging in user: $email');

      // Sign in with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw Exception('Failed to sign in');
      }

      log.i('✅ User signed in: ${fbUser.uid}');

      // Update last active date
      await _firestore.collection('users').doc(fbUser.uid).update({
        'lastActiveDate': DateTime.now().toIso8601String(),
      });

      // Return user object
      return User(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        firstName: fbUser.displayName?.split(' ').first ?? '',
        lastName: fbUser.displayName?.split(' ').skip(1).join(' ') ?? '',
        avatarUrl: fbUser.photoURL,
        isEmailVerified: fbUser.emailVerified,
        createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      );
    } on fb.FirebaseAuthException catch (e) {
      log.e('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e, st) {
      log.e('❌ Login error: $e', stackTrace: st);
      throw Exception('Login failed: $e');
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    try {
      log.i('🚪 Logging out user...');
      await _firebaseAuth.signOut();
      log.i('✅ User signed out');
    } catch (e, st) {
      log.e('❌ Logout error: $e', stackTrace: st);
      throw Exception('Logout failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      log.i('📧 Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      log.i('✅ Password reset email sent');
    } on fb.FirebaseAuthException catch (e) {
      log.e('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e, st) {
      log.e('❌ Password reset error: $e', stackTrace: st);
      throw Exception('Password reset failed: $e');
    }
  }

  /// Verify email address
  Future<void> verifyEmail() async {
    try {
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser == null) {
        throw Exception('No user signed in');
      }

      log.i('📧 Sending verification email to: ${fbUser.email}');
      await fbUser.sendEmailVerification();
      log.i('✅ Verification email sent');
    } on fb.FirebaseAuthException catch (e) {
      log.e('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e, st) {
      log.e('❌ Email verification error: $e', stackTrace: st);
      throw Exception('Email verification failed: $e');
    }
  }

  /// Get user profile from Firestore
  Future<User> getProfile(String userId) async {
    try {
      log.i('👤 Fetching user profile: $userId');

      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        throw Exception('User profile not found');
      }

      final data = doc.data() as Map<String, dynamic>;

      return User(
        id: data['id'] as String,
        email: data['email'] as String,
        firstName: data['firstName'] as String? ?? '',
        lastName: data['lastName'] as String? ?? '',
        avatarUrl: data['avatarUrl'] as String?,
        isEmailVerified: data['emailVerified'] as bool? ?? false,
        createdAt: DateTime.parse(data['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      );
    } catch (e, st) {
      log.e('❌ Get profile error: $e', stackTrace: st);
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
      log.i('✏️ Updating user profile: $userId');

      final updates = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (firstName != null || lastName != null) {
        final newFirstName = firstName ?? 'User';
        final newLastName = lastName ?? '';
        updates['firstName'] = newFirstName;
        updates['lastName'] = newLastName;
        updates['displayName'] = '$newFirstName $newLastName';

        // Update Firebase Auth display name
        await _firebaseAuth.currentUser?.updateDisplayName('$newFirstName $newLastName');
      }

      if (bio != null) updates['bio'] = bio;
      if (country != null) updates['country'] = country;
      if (gender != null) updates['gender'] = gender;
      if (occupation != null) updates['occupation'] = occupation;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth.toIso8601String();
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;

      await _firestore.collection('users').doc(userId).update(updates);

      log.i('✅ User profile updated');
    } catch (e, st) {
      log.e('❌ Update profile error: $e', stackTrace: st);
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found. Please check your email address.';
      case 'wrong-password':
        return 'Invalid password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'email-already-in-use':
        return 'Email already registered. Please use a different email.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _firebaseAuth.currentUser != null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  /// Get authentication state stream
  Stream<fb.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }
}
