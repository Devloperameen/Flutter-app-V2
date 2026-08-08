import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreedToTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validation
    if (_firstNameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'First name is required');
      return;
    }
    if (_firstNameController.text.trim().length < 2) {
      setState(() => _errorMessage = 'First name must be at least 2 characters');
      return;
    }
    if (_lastNameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Last name is required');
      return;
    }
    if (_lastNameController.text.trim().length < 2) {
      setState(() => _errorMessage = 'Last name must be at least 2 characters');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Email is required');
      return;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Password is required');
      return;
    }
    if (_passwordController.text.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters');
      return;
    }
    if (!_isStrongPassword(_passwordController.text)) {
      setState(() => _errorMessage = 'Password must include uppercase, lowercase, and number');
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please confirm your password');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'Please agree to Terms & Conditions');
      return;
    }

    setState(() => _isLoading = true);

    try {
      log.i('📝 Registering user: ${_emailController.text.trim()}');
      
      await ref.read(authNotifierProvider.notifier).register(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      log.i('✅ Registration successful');
      
      // Success! Auth state stream will automatically navigate
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! Verification email sent.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e, st) {
      log.e('❌ Registration error: $e', stackTrace: st);
      
      setState(() {
        _isLoading = false;
        _errorMessage = _formatErrorMessage(e.toString());
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasDigits;
  }

  String _formatErrorMessage(String error) {
    String message = error;
    
    if (message.contains('email-already-in-use')) {
      return 'Email already registered. Please login or use a different email.';
    } else if (message.contains('weak-password')) {
      return 'Password is too weak. Use uppercase, lowercase, and numbers.';
    } else if (message.contains('invalid-email')) {
      return 'Invalid email address.';
    } else if (message.contains('operation-not-allowed')) {
      return 'Registration is currently disabled. Please try again later.';
    } else if (message.contains('Exception:') || message.contains('Failure:')) {
      message = message.replaceAll(RegExp(r'Exception:|Failure:'), '').trim();
    }
    
    return message.isEmpty ? 'Registration failed. Please try again.' : message;
  }

  Future<void> _goBackToLogin() async {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  'Join SAFE',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Start your personal transformation today',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                
                SizedBox(height: AppSpacing.xl),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],

                // First name field
                TextField(
                  controller: _firstNameController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Last name field
                TextField(
                  controller: _lastNameController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Email field
                TextField(
                  controller: _emailController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'user@example.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Password field
                TextField(
                  controller: _passwordController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 8 characters',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Confirm password field
                TextField(
                  controller: _confirmPasswordController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: !_showConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _isLoading ? null : _register(),
                ),
                SizedBox(height: AppSpacing.lg),

                // Terms checkbox
                CheckboxListTile(
                  value: _agreedToTerms,
                  enabled: !_isLoading,
                  onChanged: (value) {
                    setState(() => _agreedToTerms = value ?? false);
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'I agree to Terms & Conditions',
                    style: theme.textTheme.bodySmall,
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySeed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primarySeed,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _isLoading ? null : _goBackToLogin,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
