import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit(this._repository) : super(const BalanceInitial());

  final WalletRepository _repository;

  Future<void> load() async {
    emit(const BalanceLoading());
    try {
      final summary = await _repository.loadSummary();
      if (isClosed) return;
      emit(BalanceSuccess(summary));
    } on Exception {
      if (isClosed) return;
      emit(const BalanceFailure('No se pudo cargar el resumen de la billetera.'));
    } catch (_) {
      if (isClosed) return;
      emit(const BalanceFailure('Ocurrió un error inesperado.'));
    }
  }

  Future<void> retry() => load();
  Future<void> refresh() => load();
}
