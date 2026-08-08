import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/core/router/route_names.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'demo@safe.com');
  final _passwordController = TextEditingController(text: '');  // SECURITY: Don't prefill password
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      log.d('🔐 Starting login with: ${_emailController.text}');
      await ref.read(authNotifierProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      log.i('✅ Login successful, auth state should update soon...');
      // The auth state listener will handle navigation
      // Don't clear loading state yet - wait for navigation or error
    } catch (e) {
      log.e('❌ Login error: $e', error: e);
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        
        // Extract error message properly
        String errorMessage = e.toString();
        
        // Handle various error formats
        if (errorMessage.contains('User not found')) {
          errorMessage = 'User not found. Please check your email.';
        } else if (errorMessage.contains('wrong-password')) {
          errorMessage = 'Incorrect password. Please try again.';
        } else if (errorMessage.contains('invalid-credential')) {
          errorMessage = 'Invalid credentials. Please try again.';
        } else if (errorMessage.contains('invalid-email')) {
          errorMessage = 'Invalid email address.';
        } else if (errorMessage.contains('too-many-requests')) {
          errorMessage = 'Too many login attempts. Please try again later.';
        } else if (errorMessage.contains('user-disabled')) {
          errorMessage = 'This account has been disabled.';
        } else if (errorMessage.contains('ServerFailure') || errorMessage.contains('Exception')) {
          // Generic error - extract message if possible
          if (errorMessage.contains(':')) {
            errorMessage = errorMessage.split(':').last.trim();
          } else {
            errorMessage = 'Login failed. Please try again.';
          }
        } else if (errorMessage.isEmpty) {
          errorMessage = 'Login failed. Please try again.';
        }
        
        _errorMessage = errorMessage;
      });
    }
  }

  Future<void> _goToRegister() async {
    context.pushNamed(RouteNames.register);
  }

  Future<void> _goToForgotPassword() async {
    if (_emailController.text.isEmpty) {
      context.pushNamed(RouteNames.forgotPassword);
    } else {
      context.pushNamed(
        RouteNames.forgotPassword,
        queryParameters: {'email': _emailController.text.trim()},
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Listen to auth state changes and navigate when user is authenticated
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && mounted) {
          log.i('🎯 Auth state changed: User logged in, navigating to dashboard');
          context.go('/dashboard');
        }
      });
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to your account',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                
                SizedBox(height: AppSpacing.xl * 1.5),

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
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _isLoading ? null : _login(),
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : _goToForgotPassword,
                    child: const Text('Forgot Password?'),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
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
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        "Don't have an account?",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: theme.dividerColor)),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _goToRegister,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create New Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
