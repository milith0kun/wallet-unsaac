import 'package:flutter/material.dart';
import 'package:wallet_unsaac/core/utils/money.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.summary, this.hideBalance = false, this.onTogglePrivacy});

  final WalletSummary summary;
  final bool hideBalance;
  final VoidCallback? onTogglePrivacy;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradientEnd = Color.lerp(scheme.primary, Colors.black, 0.28)!;
    final onPrimaryMuted = scheme.onPrimary.withValues(alpha: 0.82);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [scheme.primary, gradientEnd],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.24), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.account_balance_wallet_outlined, size: 20, color: onPrimaryMuted),
            const SizedBox(width: 8),
            Text('Saldo disponible', style: TextStyle(color: onPrimaryMuted, fontSize: 14)),
            const Spacer(),
            if (onTogglePrivacy != null)
              IconButton(
                tooltip: hideBalance ? 'Mostrar saldo' : 'Ocultar saldo',
                icon: Icon(hideBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: onPrimaryMuted),
                onPressed: onTogglePrivacy,
              ),
          ]),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
            child: Text(hideBalance ? '••••••' : MoneyFormat.soles(summary.balance),
                style: TextStyle(color: scheme.onPrimary, fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: scheme.onPrimary.withValues(alpha: 0.20)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _Metric(icon: Icons.south_west_rounded, label: 'Ingresos',
                value: hideBalance ? '••••••' : MoneyFormat.soles(summary.income),
                color: scheme.onPrimary, mutedColor: onPrimaryMuted)),
            Container(width: 1, height: 38, color: scheme.onPrimary.withValues(alpha: 0.20)),
            const SizedBox(width: 16),
            Expanded(child: _Metric(icon: Icons.north_east_rounded, label: 'Egresos',
                value: hideBalance ? '••••••' : MoneyFormat.soles(summary.expenses),
                color: scheme.onPrimary, mutedColor: onPrimaryMuted)),
          ]),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value, required this.color, required this.mutedColor});
  final IconData icon; final String label, value; final Color color, mutedColor;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: mutedColor), const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: mutedColor, fontSize: 12)),
        const SizedBox(height: 2),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
            child: Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600))),
      ])),
    ]);
  }
}
