import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';

class InMemoryWalletRepository implements WalletRepository {
  InMemoryWalletRepository({
    this.latency = const Duration(milliseconds: 350),
    List<Movement>? movements,
  }) : _movements = movements ?? _demoMovements;

  final Duration latency;
  final List<Movement> _movements;

  @override
  Future<WalletSummary> loadSummary() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return WalletSummary(movements: List<Movement>.unmodifiable(_movements));
  }

  static final List<Movement> _demoMovements = [
    Movement(id: 'tx-001', title: 'Sueldo de prácticas', category: 'Trabajo', amount: 1200, type: MovementType.income, date: DateTime(2026, 11, 2)),
    Movement(id: 'tx-002', title: 'Beca de comedor', category: 'Beca', amount: 450, type: MovementType.income, date: DateTime(2026, 11, 3)),
    Movement(id: 'tx-003', title: 'Venta de apuntes', category: 'Ingreso extra', amount: 120, type: MovementType.income, date: DateTime(2026, 11, 5)),
    Movement(id: 'tx-004', title: 'Pensión universitaria', category: 'Educación', amount: 350, type: MovementType.expense, date: DateTime(2026, 11, 4)),
    Movement(id: 'tx-005', title: 'Pasajes al campus', category: 'Transporte', amount: 48, type: MovementType.expense, date: DateTime(2026, 11, 6)),
    Movement(id: 'tx-006', title: 'Almuerzo en el comedor', category: 'Alimentación', amount: 7.50, type: MovementType.expense, date: DateTime(2026, 11, 6)),
    Movement(id: 'tx-007', title: 'Plan de internet', category: 'Servicios', amount: 89.90, type: MovementType.expense, date: DateTime(2026, 11, 7)),
  ];
}
