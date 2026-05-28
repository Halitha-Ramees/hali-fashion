import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  await runZonedGuarded(
    () async {
      await _initializeFirebase();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF0A0A0A),
          statusBarIconBrightness: Brightness.light,
        ),
      );
      runApp(const KaliFashionApp());
    },
    (error, stackTrace) {
      debugPrint('Uncaught startup error: $error');
      debugPrintStack(stackTrace: stackTrace);
      runApp(const KaliFashionApp());
    },
  );
}

Future<void> _initializeFirebase() async {
  if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) return;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
  } on Object catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
