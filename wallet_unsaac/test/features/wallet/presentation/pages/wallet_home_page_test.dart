import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/movement.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/pages/wallet_home_page.dart';

class _FakeRepo implements WalletRepository {
  @override
  Future<WalletSummary> loadSummary() async {
    return WalletSummary(
      movements: [
        Movement(
          id: '1',
          title: 'Beca UNSAAC',
          category: 'Educación',
          amount: 500.0,
          type: MovementType.income,
          date: DateTime(2026, 11, 9),
        ),
      ],
    );
  }
}

void main() {
  Widget buildTestableWidget() {
    final repo = _FakeRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => PrivacyCubit()),
        BlocProvider(create: (_) => BalanceCubit(repo)),
      ],
      child: const MaterialApp(
        home: WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
      ),
    );
  }

  testWidgets('Renderiza el título Wallet UNSAAC y los elementos principales', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Wallet UNSAAC'), findsOneWidget);
    expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('Pulsar el botón de privacidad alterna a modo oculto', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Ver que está visible inicialmente
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    // Pulsar botón de privacidad
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();

    // Ahora debe estar oculto
    expect(find.text('••••••'), findsWidgets);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
