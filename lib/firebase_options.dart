import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyC1jqTqWfzOkhsJA78IXV4xJbwOByvPcJE',
      appId: '1:268196543476:web:2fcc58c383699b253297a1',
      messagingSenderId: '268196543476',
      projectId: 'momo-companion',
      authDomain: 'momo-companion.firebaseapp.com',
      storageBucket: 'momo-companion.firebasestorage.app',
    );
  }
}
