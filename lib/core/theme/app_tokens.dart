import 'package:flutter/material.dart';

abstract final class AppColors {
  // Light Palette: Warm Editorial Marketplace
  static const paper = Color(0xFFF5F0E8);
  static const surface = Color(0xFFFFFCF7);
  static const ink = Color(0xFF16130F);
  static const inkMuted = Color(0xFF6B645A);
  static const line = Color(0xFFE3DACB);
  static const accent = Color(0xFFC2410C);       // fills with white text (~5:1 contrast)
  static const accentBright = Color(0xFFFF6A3D); // highlights, dark mode primary
  static const moss = Color(0xFF1F4B43);
  static const danger = Color(0xFFB3261E);

  // Dark Palette
  static const nightPaper = Color(0xFF12100D);
  static const nightSurface = Color(0xFF1C1915);
  static const nightInk = Color(0xFFF3EDE2);
  static const nightMuted = Color(0xFFA39A8C);
  static const nightLine = Color(0xFF2E2A23);
}

abstract final class AppRadius {
  static const s = 10.0;
  static const m = 16.0;
  static const l = 24.0;
  static const pill = 999.0;
}

abstract final class AppSpace {
  static const x1 = 4.0;
  static const x2 = 8.0;
  static const x3 = 12.0;
  static const x4 = 16.0;
  static const x5 = 24.0;
  static const x6 = 32.0;
  static const x7 = 48.0;
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 160);
  static const base = Duration(milliseconds: 240);
  static const curve = Curves.easeOutCubic;
}

