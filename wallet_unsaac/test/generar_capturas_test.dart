import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/core/theme/app_theme.dart';
import 'package:wallet_unsaac/core/theme/theme_cubit.dart';
import 'package:wallet_unsaac/features/wallet/data/repositories/in_memory_wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/domain/entities/wallet_summary.dart';
import 'package:wallet_unsaac/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/balance_state.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/pages/wallet_home_page.dart';

class _FakeWalletRepository implements WalletRepository {
  @override
  Future<WalletSummary> loadSummary() async => InMemoryWalletRepository(latency: Duration.zero).loadSummary();
}

class _StaticBalanceCubit extends BalanceCubit {
  _StaticBalanceCubit(BalanceState initial) : super(_FakeWalletRepository()) {
    emit(initial);
  }
  @override
  Future<void> load() async {}
}

class _CapturaWrapper extends StatelessWidget {
  const _CapturaWrapper({
    required this.child,
    required this.themeMode,
    required this.seedColor,
  });

  final Widget child;
  final ThemeMode themeMode;
  final Color seedColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(seedColor),
      darkTheme: AppTheme.dark(seedColor),
      home: child,
    );
  }
}

Future<void> _guardarPng(WidgetTester tester, String nombre) async {
  final boundary = tester.renderObject(find.byType(RepaintBoundary).first)
      as RenderRepaintBoundary;
  final bytes = (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }))!;

  final outDir = Directory(
      'd:/Proyectos/Desarrollo de Sotfware 2/wallet_unsaac/informe/imagenes');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }
  final file = File('${outDir.path}/$nombre');
  file.writeAsBytesSync(bytes);
}

void main() {
  setUpAll(() async {
    const fontPath =
        r'C:\Users\PC\flutter\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf';
    final fontFile = File(fontPath);
    if (fontFile.existsSync()) {
      final bytes = fontFile.readAsBytesSync();
      final fontLoader = FontLoader('MaterialIcons');
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await fontLoader.load();
    }
    final texto = FontLoader('Roboto');
    for (final f in ['segoeui.ttf', 'segoeuib.ttf']) {
      final archivo = File('C:/Windows/Fonts/$f');
      if (archivo.existsSync()) {
        final b = archivo.readAsBytesSync();
        texto.addFont(Future.value(ByteData.view(b.buffer)));
      }
    }
    await texto.load();
  });

  setUp(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first.physicalSize =
        const Size(1080, 2220);
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first.devicePixelRatio =
        2.625;
  });

  testWidgets('Figura 1: Modo Claro', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit(initialMode: ThemeMode.light)),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_01_reto1_modo_claro.png');
  });

  testWidgets('Figura 2: Modo Oscuro', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.dark,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit(initialMode: ThemeMode.dark)),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_02_reto1_modo_oscuro.png');
  });

  testWidgets('Figura 3: Importes Visibles', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_03_reto2_importes_visibles.png');
  });

  testWidgets('Figura 4: Importes Ocultos', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    final privacyCubit = PrivacyCubit()..toggle();
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider.value(value: privacyCubit),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_04_reto2_importes_ocultos.png');
  });

  testWidgets('Figura 5: Estado Carga', (tester) async {
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(const BalanceLoading())),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_05_reto3_estado_carga.png');
  });

  testWidgets('Figura 6: Estado Error', (tester) async {
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(const BalanceFailure('Error de conexion con el servidor.'))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_06_reto3_estado_error.png');
  });

  testWidgets('Figura 7: Color Azul', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    const azul = Color(0xFF1E88E5);
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.light,
        seedColor: azul,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit(initialSeed: azul)),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await _guardarPng(tester, 'figura_07_reto4_color_azul.png');
  });

  testWidgets('Figura 8: Selector de Color en Oscuro', (tester) async {
    final repo = InMemoryWalletRepository(latency: Duration.zero);
    final summary = await repo.loadSummary();
    await tester.pumpWidget(
      _CapturaWrapper(
        themeMode: ThemeMode.dark,
        seedColor: AppTheme.seed,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit(initialMode: ThemeMode.dark)),
            BlocProvider(create: (_) => PrivacyCubit()),
            BlocProvider<BalanceCubit>(create: (_) => _StaticBalanceCubit(BalanceSuccess(summary))),
          ],
          child: const WalletHomePage(firebaseStatus: FirebaseStatus.notConfigured()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byIcon(Icons.palette_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    await _guardarPng(tester, 'figura_08_reto4_selector_color_oscuro.png');
  });
}
