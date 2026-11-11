import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_unsaac/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallet_unsaac/core/config/firebase_bootstrap.dart';
import 'package:wallet_unsaac/core/config/supabase_config.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/supabase_wallet_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsInstance = await SharedPreferences.getInstance();
  final preferences = ThemePreferences(preferences: prefsInstance);

  final initialMode = await preferences.loadThemeMode();
  final initialSeed = await preferences.loadSeedColor() ?? AppTheme.seed;

  final firebaseStatus = await FirebaseBootstrap.initialize();

  // Con credenciales de Supabase se usa la nube; sin ellas, datos en memoria.
  SupabaseWalletRepository? walletRepository;
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      // ignore: deprecated_member_use
      anonKey: SupabaseConfig.anonKey,
    );
    walletRepository = SupabaseWalletRepository(Supabase.instance.client);
  }

  runApp(
    WalletApp(
      preferences: preferences,
      initialMode: initialMode,
      initialSeed: initialSeed,
      firebaseStatus: firebaseStatus,
      walletRepository: walletRepository,
    ),
  );
}
