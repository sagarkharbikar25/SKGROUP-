import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRefresh extends StatelessWidget {
  const AppRefresh({super.key, required this.onRefresh, required this.child});
  final Future<void> Function() onRefresh;
  final Widget child; // Must be a scrollable using AlwaysScrollableScrollPhysics

  Future<void> _run() async {
    HapticFeedback.lightImpact();
    // Floor of 450 ms so a fast cache hit doesn't cause a jarring flicker
    await Future.wait([
      onRefresh(),
      Future<void>.delayed(const Duration(milliseconds: 450)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _run,
      color: cs.primary,
      backgroundColor: cs.surface,
      strokeWidth: 2.5,
      displacement: 56,
      notificationPredicate: (n) => n.depth == 0, // ignore inner horizontal lists
      child: child,
    );
  }
}

