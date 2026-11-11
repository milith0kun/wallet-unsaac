import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError('Wallet UNSAAC solo se distribuye para Android.');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REEMPLAZAR_API_KEY',
    appId: 'REEMPLAZAR_APP_ID',
    messagingSenderId: 'REEMPLAZAR_MESSAGING_SENDER_ID',
    projectId: 'REEMPLAZAR_PROJECT_ID',
    storageBucket: 'REEMPLAZAR_PROJECT_ID.firebasestorage.app',
  );
}
