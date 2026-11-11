import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  ThemePreferences({SharedPreferences? preferences})
      : _preferences = preferences;

  static const String themeKey = 'wallet.theme_mode';
  static const String seedColorKey = 'wallet.seed_color';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<ThemeMode> loadThemeMode() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(themeKey);
      return themeModeFromName(raw);
    } catch (_) {
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _prefs;
    await prefs.setString(themeKey, mode.name);
  }

  Future<Color?> loadSeedColor() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getInt(seedColorKey);
      if (raw != null) return Color(raw);
    } catch (_) {}
    return null;
  }

  Future<void> saveSeedColor(Color color) async {
    final prefs = await _prefs;
    // ignore: deprecated_member_use
    await prefs.setInt(seedColorKey, color.value);
  }

  static ThemeMode themeModeFromName(String? name) {
    if (name == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => ThemeMode.system,
    );
  }
}
