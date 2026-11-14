import 'dart:async';
import 'package:flutter/material.dart';

class DelayedLoader extends StatefulWidget {
  const DelayedLoader({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 150),
  });

  final Widget child;
  final Duration delay;

  @override
  State<DelayedLoader> createState() => _DelayedLoaderState();
}

class _DelayedLoaderState extends State<DelayedLoader> {
  bool _show = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 120),
      child: widget.child,
    );
  }
}

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.height = 16,
    this.width,
    this.radius = 12,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: cs.outline.withOpacity(0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

