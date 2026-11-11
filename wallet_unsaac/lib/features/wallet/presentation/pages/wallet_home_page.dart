import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/core/theme/theme_state.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/balance_card.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/color_seed_selector.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/firebase_status_card.dart';
import 'package:wallet_unsaac/features/wallet/presentation/widgets/movement_tile.dart';

class WalletHomePage extends StatefulWidget {
  const WalletHomePage({super.key, required this.firebaseStatus});
  final FirebaseStatus firebaseStatus;

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BalanceCubit>().load();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature se habilita en la Sesión 2.'), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Flexible(
              child: Text('Wallet UNSAAC', overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            ),
          ],
        ),
        actions: [
          IconButton(tooltip: 'Elegir color de énfasis', icon: const Icon(Icons.palette_outlined),
              onPressed: () => ColorSeedSelectorSheet.show(context)),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final (icon, tooltip) = switch (themeState.mode) {
                ThemeMode.light => (Icons.light_mode_outlined, 'Modo claro (pulsar para oscuro)'),
                ThemeMode.dark => (Icons.dark_mode_outlined, 'Modo oscuro (pulsar para sistema)'),
                ThemeMode.system => (Icons.brightness_auto_outlined, 'Modo sistema (pulsar para claro)'),
              };
              return IconButton(tooltip: tooltip, icon: Icon(icon),
                  onPressed: () => context.read<ThemeCubit>().toggle());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) => switch (state) {
          BalanceInitial() || BalanceLoading() => const Center(child: CircularProgressIndicator()),
          BalanceFailure(:final message) => _ErrorView(message: message,
              onRetry: () => context.read<BalanceCubit>().retry()),
          BalanceSuccess(:final summary) => _buildSuccess(context, summary),
        },
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, WalletSummary summary) {
    final theme = Theme.of(context);
    return BlocBuilder<PrivacyCubit, PrivacyState>(
      builder: (context, privacyState) => RefreshIndicator(
        onRefresh: () => context.read<BalanceCubit>().refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text('Hola, estudiante UNSAAC',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Resumen de tus finanzas en noviembre de 2026.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            BalanceCard(summary: summary, hideBalance: privacyState.hidden,
                onTogglePrivacy: () => context.read<PrivacyCubit>().toggle()),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: FilledButton.tonalIcon(
                  onPressed: () => _showComingSoon('Registrar ingreso'),
                  icon: const Icon(Icons.add_rounded), label: const Text('Ingreso'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(
                  onPressed: () => _showComingSoon('Registrar egreso'),
                  icon: const Icon(Icons.remove_rounded), label: const Text('Egreso'))),
            ]),
            const SizedBox(height: 28),
            Row(children: [
              Expanded(child: Text('Últimos movimientos',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
              TextButton(onPressed: () => _showComingSoon('El historial completo'), child: const Text('Ver todos')),
            ]),
            const SizedBox(height: 4),
            if (summary.isEmpty) const _EmptyMovements()
            else
              for (final m in summary.movements) ...[
                MovementTile(movement: m, hideAmount: privacyState.hidden),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 12),
            FirebaseStatusCard(status: widget.firebaseStatus),
            const SizedBox(height: 16),
            Center(child: Text('Datos de demostración · Wallet UNSAAC 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cloud_off_rounded, size: 56, color: scheme.error),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('Revisa la conexión y vuelve a intentarlo.', textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Reintentar')),
      ]),
    ));
  }
}

class _EmptyMovements extends StatelessWidget {
  const _EmptyMovements();
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(children: [
      Icon(Icons.receipt_long_outlined, size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
      const SizedBox(height: 12),
      const Text('Todavía no registraste movimientos.'),
    ]),
  ));
}
