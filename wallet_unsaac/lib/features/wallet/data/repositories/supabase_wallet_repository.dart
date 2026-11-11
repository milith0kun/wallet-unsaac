import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';

/// Lee los movimientos de la tabla `wallet_movimientos` en Supabase.
class SupabaseWalletRepository implements WalletRepository {
  SupabaseWalletRepository(this._client);

  final SupabaseClient _client;

  static const String table = 'wallet_movimientos';

  @override
  Future<WalletSummary> loadSummary() async {
    final rows = await _client
        .from(table)
        .select()
        .order('fecha', ascending: false)
        .order('creado_en', ascending: false);
    return WalletSummary(
      movements: List<Movement>.unmodifiable(rows.map(movementFromRow)),
    );
  }

  static Movement movementFromRow(Map<String, dynamic> row) => Movement(
        id: row['id'] as String,
        title: row['titulo'] as String,
        category: row['categoria'] as String,
        amount: (row['monto'] as num).toDouble(),
        type: row['tipo'] == 'income'
            ? MovementType.income
            : MovementType.expense,
        date: DateTime.parse(row['fecha'] as String),
      );
}
