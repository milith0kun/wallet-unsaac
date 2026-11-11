import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallet_unsaac/core/config/supabase_config.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/supabase_wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';

/// Prueba de integración contra el Supabase real. Se omite sin credenciales:
/// flutter test --dart-define-from-file=env.json test/integration
void main() {
  final sinCredenciales = !SupabaseConfig.isConfigured;

  group('SupabaseWalletRepository (red real)', () {
    late SupabaseClient client;

    setUp(() {
      HttpOverrides.global = null; // flutter_test bloquea la red por defecto
      client = SupabaseClient(SupabaseConfig.url, SupabaseConfig.anonKey);
    });

    tearDown(() => client.dispose());

    test('carga los 7 movimientos y calcula el saldo', () async {
      final summary = await SupabaseWalletRepository(client).loadSummary();
      expect(summary.movements.length, 7);
      expect(summary.income, closeTo(1770.00, 0.001));
      expect(summary.expenses, closeTo(495.40, 0.001));
      expect(summary.balance, closeTo(1274.60, 0.001));
    });

    test('mapea tipo y fecha de cada fila', () async {
      final summary = await SupabaseWalletRepository(client).loadSummary();
      final sueldo =
          summary.movements.firstWhere((m) => m.title == 'Sueldo de prácticas');
      expect(sueldo.type, MovementType.income);
      expect(sueldo.date, DateTime(2026, 11, 2));
    });

    test('la clave anon no puede insertar (RLS)', () async {
      expect(
        () => client.from('wallet_movimientos').insert({
          'titulo': 'x',
          'categoria': 'x',
          'monto': 1,
          'tipo': 'income',
          'fecha': '2026-01-01',
        }),
        throwsA(isA<PostgrestException>()),
      );
    });
  }, skip: sinCredenciales ? 'Sin credenciales de Supabase' : false);
}
