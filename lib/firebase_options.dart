// File generated manually from google-services.json
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web is not supported.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-KbGV4R1HpDCet2QYV552Vr0FOSsDUmE',
    appId: '1:947771628186:android:eab96196060537478c5d23',
    messagingSenderId: '947771628186',
    projectId: 'flowmarket-511aa',
    storageBucket: 'flowmarket-511aa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-KbGV4R1HpDCet2QYV552Vr0FOSsDUmE',
    appId: '1:947771628186:ios:000000000000000000000000',
    messagingSenderId: '947771628186',
    projectId: 'flowmarket-511aa',
    storageBucket: 'flowmarket-511aa.firebasestorage.app',
    iosBundleId: 'com.flowmarket.flowmarketApp',
  );
}
