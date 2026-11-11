import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';

class WalletSummary {
  const WalletSummary({required this.movements});

  final List<Movement> movements;

  double get income => movements
      .where((m) => m.isIncome)
      .fold(0, (total, m) => total + m.amount);

  double get expenses => movements
      .where((m) => !m.isIncome)
      .fold(0, (total, m) => total + m.amount);

  double get balance => income - expenses;

  bool get isEmpty => movements.isEmpty;
}
