import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/theme_controller.dart';
import '../../auth/application/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to log out of ShopSphere? Your local session will be securely cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (mounted) {
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.shield_outlined, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Security & Key Store'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hardware-Backed Security Active',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '• Tokens stored in encrypted FlutterSecureStorage.\n'
              '• AES-256 encryption via Android Keystore provider.\n'
              '• No plain-text passwords or JWT tokens written to logs or Shared Preferences.\n'
              '• Compliant with enterprise mobile security standards.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('About ShopSphere'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ShopSphere • Warm Editorial Edition',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text('Version: 1.0.0 (Release Build)', style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 12),
            Text(
              'Sankar Group Flutter Developer Internship Assignment.\n\n'
              'Built with:\n'
              '• Flutter 3.27+ & Dart 3.6+\n'
              '• Flutter Riverpod (Pure Dart, Zero Codegen)\n'
              '• GoRouter with Stateful Navigation Shell\n'
              '• Dio HTTP Client with typed AppFailure mapping\n'
              '• Encrypted Secure Storage & Offline Cache Fallback\n'
              '• Material 3 Warm Editorial Design Tokens',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authState = ref.watch(authControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final user = authState.user;

    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    String initials = 'U';
    if (user != null && user.firstName.isNotEmpty) {
      initials = user.firstName[0].toUpperCase();
      if (user.lastName.isNotEmpty) {
        initials += user.lastName[0].toUpperCase();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: Column(
          children: [
            // User Avatar Card with Serif Monogram
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.m),
                border: Border.all(color: cs.outline),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.primary.withOpacity(0.12),
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName.isNotEmpty ?? false
                              ? user!.fullName
                              : 'Emily Johnson',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.email.isNotEmpty ?? false
                              ? user!.email
                              : 'emily.johnson@x.dummyjson.com',
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.secondary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'VERIFIED BUYER',
                            style: TextStyle(
                              color: cs.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings Group
            Material(
              color: cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
                side: BorderSide(color: cs.outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(Icons.dark_mode_outlined, color: cs.onSurface),
                    title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                    subtitle: Text('Warm paper vs Night slate theme', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                    value: isDark,
                    onChanged: (val) {
                      ref
                          .read(themeControllerProvider.notifier)
                          .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                  Divider(height: 1, color: cs.outline),
                  SwitchListTile(
                    secondary: Icon(Icons.notifications_none_rounded, color: cs.onSurface),
                    title: Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                    subtitle: Text('Order and catalogue updates', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notifications ${val ? "enabled" : "disabled"}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: cs.outline),
                  ListTile(
                    leading: Icon(Icons.security_outlined, color: cs.onSurface),
                    title: Text('Security & Key Store', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                    trailing: Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant),
                    onTap: _showSecurityDialog,
                  ),
                  Divider(height: 1, color: cs.outline),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: cs.onSurface),
                    title: Text('About ShopSphere', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                    subtitle: Text('Warm Editorial Edition v1.0.0', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                    trailing: Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant),
                    onTap: _showAboutDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            OutlinedButton.icon(
              onPressed: _showLogoutDialog,
              icon: Icon(Icons.logout_rounded, color: cs.error),
              label: Text('Sign Out', style: TextStyle(color: cs.error, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: cs.error.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
