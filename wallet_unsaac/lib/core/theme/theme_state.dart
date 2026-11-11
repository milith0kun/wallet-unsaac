import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.mode = ThemeMode.system,
    this.seedColor = AppTheme.seed,
  });

  final ThemeMode mode;
  final Color seedColor;

  ThemeState copyWith({ThemeMode? mode, Color? seedColor}) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  List<Object?> get props => [mode, seedColor];
}
