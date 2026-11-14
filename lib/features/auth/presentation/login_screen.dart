import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/shopsphere_logo.dart';
import '../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _usernameController.text = 'emilys';
      _passwordController.text = 'emilyspass';
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final success = await ref.read(authControllerProvider.notifier).login(
            _usernameController.text.trim(),
            _passwordController.text.trim(),
          );
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          context.go('/home');
        } else {
          final err = ref.read(authControllerProvider).errorMessage ?? 'Login failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Brand Panel (~38% of screen)
            Container(
              width: double.infinity,
              height: size.height * 0.38,
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const ShopSphereEmblem(size: 38),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: const Text(
                                  'SHOPSPHERE EDITORIAL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Find what\nfits you.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: cs.onPrimary,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form container on warm paper surface
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Demo credentials banner
                      Material(
                        color: cs.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.m),
                          side: BorderSide(color: cs.outline),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: _fillDemoCredentials,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Icon(Icons.key_rounded, size: 20, color: cs.primary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Demo Account (Tap to Fill)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: cs.onSurface,
                                        ),
                                      ),
                                      Text(
                                        'emilys / emilyspass',
                                        style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: cs.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    'Auto-fill',
                                    style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      AppTextField(
                        controller: _usernameController,
                        label: 'Username',
                        hint: 'Enter your username',
                        prefixIcon: Icons.alternate_email_rounded,
                        showClearButton: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Submit CTA
                      AppButton(
                        text: 'Sign In to ShopSphere',
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),

                      // Signup link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New to ShopSphere?",
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () => context.push('/signup'),
                            child: Text(
                              'Create account',
                              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
