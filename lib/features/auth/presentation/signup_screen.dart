import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please sign in with your credentials.'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Join the\nmarketplace.',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your details to create your personal account.',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                    ),
                    const SizedBox(height: 28),

                    // Full Name
                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      prefixIcon: Icons.badge_outlined,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Username
                    AppTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hint: 'johndoe',
                      prefixIcon: Icons.alternate_email_rounded,
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Username is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'john@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Email is required';
                        if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Minimum 6 characters',
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Password is required';
                        if (val.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit
                    AppButton(
                      text: 'Create Account',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
