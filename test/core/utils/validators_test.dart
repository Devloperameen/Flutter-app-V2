import 'package:flutter_test/flutter_test.dart';
import 'package:safe/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('returns error for empty email', () {
        expect(Validators.email(''), 'Email is required');
        expect(Validators.email(null), 'Email is required');
      });

      test('returns error for invalid email formats', () {
        expect(Validators.email('invalidemail'), 'Please enter a valid email address');
        expect(Validators.email('test@.com'), 'Please enter a valid email address');
        expect(Validators.email('@domain.com'), 'Please enter a valid email address');
      });

      test('returns null for valid email', () {
        expect(Validators.email('test@example.com'), null);
        expect(Validators.email('user.name@domain.co.uk'), null);
      });
    });

    group('password', () {
      test('returns error for empty password', () {
        expect(Validators.password(''), 'Password is required');
        expect(Validators.password(null), 'Password is required');
      });

      test('returns error for weak passwords', () {
        expect(Validators.password('weak'), 'Password must be at least 8 characters');
        expect(Validators.password('nouppercase1!'), 'Password must contain at least one uppercase letter');
        expect(Validators.password('NOLOWERCASE1!'), 'Password must contain at least one lowercase letter');
        expect(Validators.password('NoNumbers!!'), 'Password must contain at least one number');
        expect(Validators.password('NoSpecial123'), 'Password must contain at least one special character');
      });

      test('returns null for valid strong password', () {
        expect(Validators.password('StrongPass123!@#'), null);
      });
    });

    group('name', () {
      test('returns error for empty name', () {
        expect(Validators.name(''), 'Name is required');
        expect(Validators.name(null), 'Name is required');
      });

      test('returns error for too short name', () {
        expect(Validators.name('A'), 'Name must be at least 2 characters');
      });

      test('returns null for valid name', () {
        expect(Validators.name('John Doe'), null);
      });
    });
  });
}
