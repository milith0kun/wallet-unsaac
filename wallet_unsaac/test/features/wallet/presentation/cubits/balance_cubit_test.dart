import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_state.dart';

class _FakeWalletRepository implements WalletRepository {
  _FakeWalletRepository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<WalletSummary> loadSummary() async {
    if (shouldFail) {
      throw Exception('Fallo intencional');
    }
    return
        WalletSummary(
          movements: [
            Movement(
              id: '1',
              title: 'Ingreso inicial',
              category: 'General',
              amount: 1000.0,
              type: MovementType.income,
              date: DateTime(2026, 11, 9),
            ),
          ],
        );
  }
}

void main() {
  group('BalanceCubit', () {
    test('estado inicial es BalanceInitial', () {
      final cubit = BalanceCubit(_FakeWalletRepository());
      expect(cubit.state, equals(const BalanceInitial()));
    });

    blocTest<BalanceCubit, BalanceState>(
      'load emite [BalanceLoading, BalanceSuccess] en caso exitoso',
      build: () => BalanceCubit(_FakeWalletRepository()),
      act: (cubit) => cubit.load(),
      expect: () => [
        const BalanceLoading(),
        isA<BalanceSuccess>(),
      ],
    );

    blocTest<BalanceCubit, BalanceState>(
      'load emite [BalanceLoading, BalanceFailure] ante error del repositorio',
      build: () => BalanceCubit(_FakeWalletRepository(shouldFail: true)),
      act: (cubit) => cubit.load(),
      expect: () => [
        const BalanceLoading(),
        isA<BalanceFailure>(),
      ],
    );
  });
}
