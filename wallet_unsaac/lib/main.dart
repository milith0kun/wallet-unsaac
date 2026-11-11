import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_unsaac/app.dart';
import 'package:wallet_unsaac/core/config/firebase_bootstrap.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsInstance = await SharedPreferences.getInstance();
  final preferences = ThemePreferences(preferences: prefsInstance);

  final initialMode = await preferences.loadThemeMode();
  final initialSeed = await preferences.loadSeedColor() ?? AppTheme.seed;

  final firebaseStatus = await FirebaseBootstrap.initialize();

  runApp(
    WalletApp(
      preferences: preferences,
      initialMode: initialMode,
      initialSeed: initialSeed,
      firebaseStatus: firebaseStatus,
    ),
  );
}
