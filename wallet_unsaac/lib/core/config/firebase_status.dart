enum FirebaseState { ready, notConfigured, failed }

class FirebaseStatus {
  const FirebaseStatus._(this.state, [this.detail]);
  const FirebaseStatus.ready() : this._(FirebaseState.ready);
  const FirebaseStatus.notConfigured() : this._(FirebaseState.notConfigured);
  const FirebaseStatus.failed(String detail)
      : this._(FirebaseState.failed, detail);

  final FirebaseState state;
  final String? detail;

  bool get isReady => state == FirebaseState.ready;

  String get label => switch (state) {
        FirebaseState.ready => 'conectado',
        FirebaseState.notConfigured => 'no configurado (modo local)',
        FirebaseState.failed => 'error de inicialización',
      };

  String get hint => switch (state) {
        FirebaseState.ready =>
          'firebase_core se inicializó correctamente antes de runApp.',
        FirebaseState.notConfigured =>
          'Ejecuta flutterfire configure y vuelve a compilar. '
              'Mientras tanto, la app usa datos de demostración.',
        FirebaseState.failed =>
          detail ?? 'Revisa la consola de Flutter para conocer el detalle.',
      };
}
