import 'package:html_unescape/html_unescape.dart';

/// SAFE — Input Sanitization Service
///
/// **SECURITY:** Prevents XSS attacks and ensures data integrity
/// by sanitizing all user-generated content before storage or display.
abstract class InputSanitizer {
  static final _htmlUnescape = HtmlUnescape();
  
  /// Sanitize text input to prevent XSS attacks
  static String sanitizeText(String? input) {
    if (input == null || input.isEmpty) return '';
    
    // Remove null bytes
    var sanitized = input.replaceAll('\x00', '');
    
    // Remove potentially dangerous HTML tags
    sanitized = _removeHtmlTags(sanitized);
    
    // Escape HTML entities
    sanitized = _escapeHtml(sanitized);
    
    // Limit length to prevent DoS
    if (sanitized.length > 10000) {
      sanitized = sanitized.substring(0, 10000);
    }
    
    return sanitized.trim();
  }
  
  /// Sanitize email input
  static String sanitizeEmail(String? email) {
    if (email == null || email.isEmpty) return '';
    
    var sanitized = email.toLowerCase().trim();
    
    // Remove dangerous characters
    sanitized = sanitized.replaceAll(RegExp('''[<>"'&]'''), '');
    
    // Limit length
    if (sanitized.length > 254) {
      sanitized = sanitized.substring(0, 254);
    }
    
    return sanitized;
  }
  
  /// Sanitize name input
  static String sanitizeName(String? name) {
    if (name == null || name.isEmpty) return '';
    
    var sanitized = name.trim();
    
    // Remove HTML tags and dangerous characters
    sanitized = _removeHtmlTags(sanitized);
    sanitized = sanitized.replaceAll(RegExp('''[<>"'&]'''), '');
    
    // Only allow letters, spaces, hyphens, and apostrophes
    sanitized = sanitized.replaceAll(RegExp(r'''[^a-zA-Z\s\-']'''), '');
    
    // Limit length
    if (sanitized.length > 100) {
      sanitized = sanitized.substring(0, 100);
    }
    
    return sanitized;
  }
  
  /// Sanitize phone number
  static String sanitizePhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    
    // Only allow numbers, +, -, (, ), and spaces
    var sanitized = phone.replaceAll(RegExp(r'[^0-9+\-\(\)\s]'), '');
    
    // Limit length
    if (sanitized.length > 20) {
      sanitized = sanitized.substring(0, 20);
    }
    
    return sanitized.trim();
  }
  
  /// Sanitize URL input
  static String sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    var sanitized = url.trim();
    
    // Must start with http:// or https://
    if (!sanitized.startsWith('http://') && !sanitized.startsWith('https://')) {
      return '';
    }
    
    // Remove dangerous characters
    sanitized = sanitized.replaceAll(RegExp('''[<>"'&]'''), '');
    
    // Limit length
    if (sanitized.length > 2048) {
      sanitized = sanitized.substring(0, 2048);
    }
    
    return sanitized;
  }
  
  /// Remove HTML tags from string
  static String _removeHtmlTags(String input) {
    return input.replaceAll(RegExp('<[^>]*>'), '');
  }
  
  /// Escape HTML entities
  static String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }
  
  /// Unescape HTML entities for display
  static String unescapeHtml(String input) {
    return _htmlUnescape.convert(input);
  }
  
  /// Validate and sanitize JSON keys to prevent injection
  static Map<String, dynamic> sanitizeJsonKeys(Map<String, dynamic> json) {
    final sanitized = <String, dynamic>{};
    
    for (final entry in json.entries) {
      // Only allow alphanumeric keys with underscores
      final key = entry.key.replaceAll(RegExp('[^a-zA-Z0-9_]'), '');
      if (key.isNotEmpty && key.length <= 50) {
        sanitized[key] = entry.value;
      }
    }
    
    return sanitized;
  }
}
