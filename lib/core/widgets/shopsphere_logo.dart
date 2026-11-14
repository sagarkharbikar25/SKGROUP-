import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// Bespoke, high-end vector emblem for ShopSphere.
/// Renders an architectural celestial sphere ring interlocking with an editorial monogram.
class ShopSphereEmblem extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const ShopSphereEmblem({
    super.key,
    this.size = 96,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = primaryColor ?? cs.primary;
    final accent = accentColor ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.accentBright : AppColors.accent);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ShopSphereEmblemPainter(
          primaryColor: primary,
          accentColor: accent,
          isDark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
    );
  }
}

class _ShopSphereEmblemPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool isDark;

  _ShopSphereEmblemPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Subtle Outer Ambient Glow Ring
    final glowPaint = Paint()
      ..color = accentColor.withOpacity(isDark ? 0.12 : 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.98, glowPaint);

    // 2. Base Dark/Light Rounded Squircle Tile
    final squircleRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.90, height: size.height * 0.90),
      Radius.circular(radius * 0.38),
    );

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E1A16) : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(squircleRRect, bgPaint);

    // Subtle hairline boundary
    final borderPaint = Paint()
      ..color = isDark ? const Color(0xFF38322A) : const Color(0xFFE6DDD2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(squircleRRect, borderPaint);

    // 3. Celestial Orbital "Sphere" Ring (representing Sphere)
    final ringPaint = Paint()
      ..color = accentColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.024;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 5.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size.width * 0.62, height: size.width * 0.28),
      ringPaint,
    );
    canvas.restore();

    // 4. Center Luxury Monogram "S" (Serif Typography with Dual-Tone Geometry)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: TextStyle(
          fontFamily: 'serif',
          fontSize: size.width * 0.52,
          fontWeight: FontWeight.w700,
          color: accentColor,
          height: 1.0,
          letterSpacing: -1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2) - (size.height * 0.02),
    );
    textPainter.paint(canvas, textOffset);

    // 5. Orbital Accent Dot on the sphere orbit
    final dotPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    final dotOffset = Offset(
      center.dx + (size.width * 0.24),
      center.dy - (size.height * 0.16),
    );
    canvas.drawCircle(dotOffset, size.width * 0.038, dotPaint);

    // Soft specular highlight on dot
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotOffset, size.width * 0.015, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _ShopSphereEmblemPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark;
  }
}
