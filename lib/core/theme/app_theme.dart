import 'package:flutter/material.dart';
import 'app_tokens.dart';

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final bg = dark ? AppColors.nightPaper : AppColors.paper;
  final surface = dark ? AppColors.nightSurface : AppColors.surface;
  final ink = dark ? AppColors.nightInk : AppColors.ink;
  final muted = dark ? AppColors.nightMuted : AppColors.inkMuted;
  final line = dark ? AppColors.nightLine : AppColors.line;
  final primary = dark ? AppColors.accentBright : AppColors.accent;

  final scheme = ColorScheme(
    brightness: b,
    primary: primary,
    onPrimary: dark ? AppColors.nightPaper : Colors.white,
    secondary: dark ? const Color(0xFF7FB5A6) : AppColors.moss,
    onSecondary: dark ? AppColors.nightPaper : Colors.white,
    error: dark ? const Color(0xFFFFB4AB) : AppColors.danger,
    onError: dark ? AppColors.nightPaper : Colors.white,
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: muted,
    outline: line,
  );

  TextStyle display(double s, {FontWeight w = FontWeight.w600}) => TextStyle(
        fontFamily: 'serif',
        fontSize: s,
        fontWeight: w,
        height: 1.12,
        letterSpacing: -0.4,
        color: ink,
      );

  TextStyle body(double s, {FontWeight w = FontWeight.w500, Color? c}) => TextStyle(
        fontFamily: 'sans-serif',
        fontSize: s,
        fontWeight: w,
        height: 1.4,
        color: c ?? ink,
      );

  final text = TextTheme(
    displayLarge: display(40, w: FontWeight.bold),
    headlineMedium: display(28, w: FontWeight.bold),
    titleLarge: display(22, w: FontWeight.w600),
    titleMedium: body(16, w: FontWeight.w700),
    bodyLarge: body(16),
    bodyMedium: body(14, c: muted),
    labelLarge: body(14, w: FontWeight.w700),
  );

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: c, width: w),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    textTheme: text,
    dividerColor: line,
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        side: BorderSide(color: line, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: display(22, w: FontWeight.bold),
      iconTheme: IconThemeData(color: ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border(line),
      focusedBorder: border(primary, 1.6),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, 1.6),
      labelStyle: body(14, c: muted),
      hintStyle: body(14, c: muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: dark ? AppColors.nightPaper : Colors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: body(15, w: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: line, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: body(15, w: FontWeight.w600),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: line),
      backgroundColor: surface,
      selectedColor: primary,
      labelStyle: body(13),
    ),
  );
}

class AppTheme {
  AppTheme._();
  static ThemeData get lightTheme => buildTheme(Brightness.light);
  static ThemeData get darkTheme => buildTheme(Brightness.dark);
}
