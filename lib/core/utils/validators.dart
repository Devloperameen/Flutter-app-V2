import 'package:safe/core/constants/app_constants.dart';
import 'package:safe/core/security/input_sanitizer.dart';

/// Input validators for forms throughout the app.
///
/// **SECURITY:** All inputs are sanitized to prevent XSS and injection attacks.
/// Returns null if valid, or an error message string if invalid.
/// Designed for use with TextFormField's validator parameter.
abstract final class Validators {
  /// Validate email address
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final sanitizedEmail = InputSanitizer.sanitizeEmail(value);
    if (sanitizedEmail.isEmpty) {
      return 'Please enter a valid email';
    }
    
    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(sanitizedEmail)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate password with enhanced security requirements
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    // Check for common weak passwords
    final weakPasswords = [
      'password', '123456', 'qwerty', 'abc123', 'password123',
      'admin', 'letmein', 'welcome', 'monkey', '1234567890'
    ];
    
    if (weakPasswords.contains(value.toLowerCase())) {
      return 'Password is too common. Please choose a stronger password';
    }
    
    return null;
  }

  /// Validate confirm password
  static String? confirmPassword(String? value, String password) {
    final passwordError = Validators.password(value);
    if (passwordError != null) return passwordError;
    if (value != password) return 'Passwords do not match';
    return null;
  }

  /// Validate name
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    final sanitizedName = InputSanitizer.sanitizeName(value);
    if (sanitizedName.isEmpty) {
      return 'Please enter a valid name';
    }
    
    if (sanitizedName.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (sanitizedName.length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }
    
    return null;
  }

  /// Validate required field
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    final sanitized = InputSanitizer.sanitizeText(value);
    if (sanitized.isEmpty) {
      return '$fieldName contains invalid characters';
    }
    
    return null;
  }

  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final sanitizedPhone = InputSanitizer.sanitizePhone(value);
    if (sanitizedPhone.isEmpty) {
      return 'Please enter a valid phone number';
    }
    
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(sanitizedPhone.replaceAll(' ', ''))) {
      return 'Please enter a valid phone number (10-15 digits)';
    }
    
    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URLs are typically optional
    }
    
    final sanitizedUrl = InputSanitizer.sanitizeUrl(value);
    if (sanitizedUrl.isEmpty) {
      return 'Please enter a valid URL starting with http:// or https://';
    }
    
    try {
      final uri = Uri.parse(sanitizedUrl);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return 'URL must start with http:// or https://';
      }
    } catch (e) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  /// Validate bio/description text
  static String? bio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Bio is optional
    }
    
    final sanitized = InputSanitizer.sanitizeText(value);
    if (sanitized.length > AppConstants.maxBioLength) {
      return 'Bio must be less than ${AppConstants.maxBioLength} characters';
    }
    
    return null;
  }
}
