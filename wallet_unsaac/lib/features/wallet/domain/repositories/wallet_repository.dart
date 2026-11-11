import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';

abstract interface class WalletRepository {
  Future<WalletSummary> loadSummary();
}
