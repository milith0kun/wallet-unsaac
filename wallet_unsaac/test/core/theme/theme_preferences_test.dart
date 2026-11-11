import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';

void main() {
  group('ThemePreferences', () {
    test('retorna ThemeMode.system si no hay valor previo guardado', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final themePrefs = ThemePreferences(preferences: prefs);

      final mode = await themePrefs.loadThemeMode();
      expect(mode, equals(ThemeMode.system));
    });

    test('persiste y recupera ThemeMode correctamente', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final themePrefs = ThemePreferences(preferences: prefs);

      await themePrefs.saveThemeMode(ThemeMode.dark);
      final mode = await themePrefs.loadThemeMode();
      expect(mode, equals(ThemeMode.dark));
    });

    test('retorna ThemeMode.system ante un valor corrupto en storage', () async {
      SharedPreferences.setMockInitialValues({
        ThemePreferences.themeKey: 'invalid_mode_value',
      });
      final prefs = await SharedPreferences.getInstance();
      final themePrefs = ThemePreferences(preferences: prefs);

      final mode = await themePrefs.loadThemeMode();
      expect(mode, equals(ThemeMode.system));
    });

    test('persiste y recupera seedColor correctamente', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final themePrefs = ThemePreferences(preferences: prefs);

      const color = Color(0xFF1E88E5);
      await themePrefs.saveSeedColor(color);

      final loaded = await themePrefs.loadSeedColor();
      expect(loaded, isNotNull);
      expect(loaded!.toARGB32(), equals(color.toARGB32()));
    });
  });
}

