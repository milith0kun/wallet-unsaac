import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color seed = Color(0xFF7A1F2B);

  static ThemeData light([Color seedColor = seed]) =>
      _build(Brightness.light, seedColor);

  static ThemeData dark([Color seedColor = seed]) =>
      _build(Brightness.dark, seedColor);

  static ThemeData _build(Brightness brightness, Color seedColor) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
