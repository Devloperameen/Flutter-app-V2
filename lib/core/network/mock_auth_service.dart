import 'package:safe/features/auth/domain/models/user.dart';

/// Complete mock authentication service
/// Works offline without any backend server
class LocalAuthService {
  // Hardcoded test users - add more as needed
  static const Map<String, String> _testUsers = {
    'test@test.com': 'password',
    'demo@test.com': 'demo123',
    'user@test.com': 'user123',
  };

  /// Mock login - NO network call needed
  static Future<({String accessToken, String refreshToken, User user})> login(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Validate credentials
    if (!_testUsers.containsKey(email)) {
      throw Exception('User not found');
    }

    if (_testUsers[email] != password) {
      throw Exception('Invalid password');
    }

    // Extract name from email
    final nameParts = email.split('@')[0].split('.');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : 'User';
    final lastName = nameParts.length > 1 ? nameParts[1] : '';

    // Return mock user
    final user = User(
      id: 'user_${email.hashCode}',
      email: email,
      firstName: firstName.toUpperCase(),
      lastName: lastName.toUpperCase(),
      avatarUrl: null,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );

    return (
      accessToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
    );
  }

  /// Mock register - NO network call needed
  static Future<({String accessToken, String refreshToken, User user})> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // In real app, would store in database
    // For now, accept any registration

    final user = User(
      id: 'user_${email.hashCode}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: null,
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );

    return (
      accessToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
    );
  }

  /// Get available test credentials
  static List<String> getTestCredentials() {
    return _testUsers.keys.toList();
  }
}
