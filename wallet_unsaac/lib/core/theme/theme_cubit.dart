import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    ThemeMode initialMode = ThemeMode.system,
    Color initialSeed = AppTheme.seed,
    ThemePreferences? preferences,
  })  : _preferences = preferences,
        super(ThemeState(mode: initialMode, seedColor: initialSeed));

  final ThemePreferences? _preferences;

  ThemeMode _nextMode(ThemeMode current) => switch (current) {
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
        ThemeMode.system => ThemeMode.light,
      };

  Future<void> toggle() => setMode(_nextMode(state.mode));

  Future<void> setMode(ThemeMode mode) async {
    emit(state.copyWith(mode: mode));
    await _preferences?.saveThemeMode(mode);
  }

  Future<void> setSeedColor(Color color) async {
    emit(state.copyWith(seedColor: color));
    await _preferences?.saveSeedColor(color);
  }
}
