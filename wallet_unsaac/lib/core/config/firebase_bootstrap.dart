import 'package:firebase_core/firebase_core.dart';
import 'package:wallet_unsaac/core/config/backend_status.dart';
import 'package:wallet_unsaac/firebase_options.dart';

abstract final class FirebaseBootstrap {
  static Future<BackendStatus> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return const BackendStatus.ready();
    } on FirebaseException catch (error) {
      return BackendStatus.failed('${error.code}: ${error.message}');
    } catch (error) {
      return BackendStatus.failed(error.toString());
    }
  }
}
