enum BackendState { ready, notConfigured, failed }

/// Estado de la conexión con el backend (Firebase).
class BackendStatus {
  const BackendStatus._(this.state, [this.detail]);
  const BackendStatus.ready() : this._(BackendState.ready);
  const BackendStatus.notConfigured() : this._(BackendState.notConfigured);
  const BackendStatus.failed(String detail)
      : this._(BackendState.failed, detail);

  final BackendState state;
  final String? detail;

  bool get isReady => state == BackendState.ready;

  String get label => switch (state) {
        BackendState.ready => 'conectado',
        BackendState.notConfigured => 'no configurado (modo local)',
        BackendState.failed => 'error de inicialización',
      };

  String get hint => switch (state) {
        BackendState.ready =>
          'firebase_core se inicializó correctamente antes de runApp.',
        BackendState.notConfigured =>
          'Ejecuta flutterfire configure y vuelve a compilar. '
              'Mientras tanto, la app usa datos de demostración.',
        BackendState.failed =>
          detail ?? 'Revisa la consola de Flutter para conocer el detalle.',
      };
}
