import 'package:flutter_test/flutter_test.dart';
import 'package:safe/core/security/input_sanitizer.dart';

void main() {
  group('InputSanitizer', () {
    test('sanitizeText removes dangerous HTML tags and scripts', () {
      final input = '<script>alert("xss")</script>Hello <b>World</b>';
      final sanitized = InputSanitizer.sanitizeText(input);
      expect(sanitized, 'alert(&quot;xss&quot;)Hello World');
    });

    test('sanitizeEmail cleans email address', () {
      final input = '  test@example.com  <script>  ';
      final sanitized = InputSanitizer.sanitizeEmail(input);
      expect(sanitized, 'test@example.com  script');
    });
  });
}
