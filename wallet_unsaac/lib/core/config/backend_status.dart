enum BackendState { ready, notConfigured, failed }

/// Estado de la conexión con el backend (Supabase).
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
        BackendState.failed => 'error de conexión',
      };

  String get hint => switch (state) {
        BackendState.ready =>
          'Los movimientos se leen de la tabla wallet_movimientos.',
        BackendState.notConfigured =>
          'Compila con --dart-define-from-file=env.json para conectar. '
              'Mientras tanto, la app usa datos de demostración.',
        BackendState.failed =>
          detail ?? 'Revisa la consola de Flutter para conocer el detalle.',
      };
}
