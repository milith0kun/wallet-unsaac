import 'package:flutter/material.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';

class FirebaseStatusCard extends StatelessWidget {
  const FirebaseStatusCard({super.key, required this.status});
  final FirebaseStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = status.isReady
        ? scheme.primaryContainer.withValues(alpha: 0.45)
        : scheme.surfaceContainerHighest;
    final icon = switch (status.state) {
      FirebaseState.ready => Icons.cloud_done_outlined,
      FirebaseState.notConfigured => Icons.cloud_off_outlined,
      FirebaseState.failed => Icons.error_outline_rounded,
    };
    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Firebase: ${status.label}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(status.hint,
                      style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12.5,
                          height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
