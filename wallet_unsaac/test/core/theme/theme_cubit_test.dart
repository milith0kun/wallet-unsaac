import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';

void main() {
  group('ThemeCubit', () {
    test('estado inicial respeta parámetros provistos', () {
      final cubit = ThemeCubit(
        initialMode: ThemeMode.dark,
        initialSeed: const Color(0xFF1E88E5),
      );
      expect(cubit.state.mode, equals(ThemeMode.dark));
      expect(cubit.state.seedColor, equals(const Color(0xFF1E88E5)));
    });

    blocTest<ThemeCubit, ThemeState>(
      'toggle cicla de system a light, dark y vuelve a system',
      build: () => ThemeCubit(initialMode: ThemeMode.system),
      act: (cubit) async {
        await cubit.toggle(); // system -> light
        await cubit.toggle(); // light -> dark
        await cubit.toggle(); // dark -> system
      },
      expect: () => [
        const ThemeState(mode: ThemeMode.light, seedColor: AppTheme.seed),
        const ThemeState(mode: ThemeMode.dark, seedColor: AppTheme.seed),
        const ThemeState(mode: ThemeMode.system, seedColor: AppTheme.seed),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'setSeedColor actualiza el color semilla en el estado',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setSeedColor(const Color(0xFF43A047)),
      expect: () => [
        const ThemeState(mode: ThemeMode.system, seedColor: Color(0xFF43A047)),
      ],
    );
  });
}

