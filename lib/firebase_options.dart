import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase is configured for Android and web only.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0hP1dfTy0uShdWmrXUqslXY_ylJr6WaY',
    appId: '1:665121432464:android:dd4d7f2b84ad70ace88915',
    messagingSenderId: '665121432464',
    projectId: 'hali-fashion',
    authDomain: 'hali-fashion.firebaseapp.com',
    storageBucket: 'hali-fashion.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0hP1dfTy0uShdWmrXUqslXY_ylJr6WaY',
    appId: '1:665121432464:android:dd4d7f2b84ad70ace88915',
    messagingSenderId: '665121432464',
    projectId: 'hali-fashion',
    storageBucket: 'hali-fashion.firebasestorage.app',
  );
}
