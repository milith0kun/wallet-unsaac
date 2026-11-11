import 'package:firebase_core/firebase_core.dart';
import 'package:wallet_unsaac/core/config/firebase_status.dart';
import 'package:wallet_unsaac/firebase_options.dart';

abstract final class FirebaseBootstrap {
  static bool get isConfigured {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      return options.apiKey.isNotEmpty &&
          !options.apiKey.startsWith('REEMPLAZAR');
    } catch (_) {
      return false;
    }
  }

  static Future<FirebaseStatus> initialize() async {
    if (!isConfigured) {
      return const FirebaseStatus.notConfigured();
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return const FirebaseStatus.ready();
    } on FirebaseException catch (error) {
      return FirebaseStatus.failed('${error.code}: ${error.message}');
    } catch (error) {
      return FirebaseStatus.failed(error.toString());
    }
  }
}
