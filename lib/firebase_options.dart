// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDigYGQ8mqT3Jhm72MRr_yiwoOEA6exf_s',
    appId: '1:956743805834:web:e560b1f946316a6c003673',
    messagingSenderId: '956743805834',
    projectId: 'paniwala-b8f1a',
    authDomain: 'paniwala-b8f1a.firebaseapp.com',
    storageBucket: 'paniwala-b8f1a.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvIaz8bkjru3Vyrh5yAR5iY__xMq1AL-k',
    appId: '1:956743805834:android:f8a15c1bd2a5b5b7003673',
    messagingSenderId: '956743805834',
    projectId: 'paniwala-b8f1a',
    storageBucket: 'paniwala-b8f1a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKPYYPyGNqCssXhxL_k6c8Lkis5b2ofIQ',
    appId: '1:956743805834:ios:2941a189ed2b7cdb003673',
    messagingSenderId: '956743805834',
    projectId: 'paniwala-b8f1a',
    storageBucket: 'paniwala-b8f1a.firebasestorage.app',
    iosClientId: '956743805834-mfnkc9vd9u2mmr76qoebtousp1gikqlf.apps.googleusercontent.com',
    iosBundleId: 'com.example.paniwala',
  );

}