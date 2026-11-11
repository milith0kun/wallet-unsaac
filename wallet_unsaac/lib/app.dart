import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_preferences.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/in_memory_wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/pages/wallet_home_page.dart';

class WalletApp extends StatelessWidget {
  const WalletApp({
    super.key,
    required this.preferences,
    required this.initialMode,
    required this.initialSeed,
    required this.firebaseStatus,
    this.walletRepository,
  });

  final ThemePreferences preferences;
  final ThemeMode initialMode;
  final Color initialSeed;
  final FirebaseStatus firebaseStatus;
  final WalletRepository? walletRepository;

  @override
  Widget build(BuildContext context) {
    final repo = walletRepository ?? InMemoryWalletRepository();

    return RepositoryProvider<WalletRepository>.value(
      value: repo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(
              initialMode: initialMode,
              initialSeed: initialSeed,
              preferences: preferences,
            ),
          ),
          BlocProvider(
            create: (_) => PrivacyCubit(),
          ),
          BlocProvider(
            create: (_) => BalanceCubit(repo)..load(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Wallet UNSAAC',
              debugShowCheckedModeBanner: false,
              themeMode: themeState.mode,
              theme: AppTheme.light(themeState.seedColor),
              darkTheme: AppTheme.dark(themeState.seedColor),
              home: WalletHomePage(firebaseStatus: firebaseStatus),
            );
          },
        ),
      ),
    );
  }
}
