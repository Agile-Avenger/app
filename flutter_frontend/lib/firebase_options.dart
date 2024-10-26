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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDc9dwrAQ_l25L2wsJLn1JYwMWZqcF8FwI',
    appId: '1:494988082252:web:803a5deb6090b8b42ec8e9',
    messagingSenderId: '494988082252',
    projectId: 'medidignose',
    authDomain: 'medidignose.firebaseapp.com',
    storageBucket: 'medidignose.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDszcQSe8XW3tOseoT_oa5er8rlVnmmjTQ',
    appId: '1:494988082252:android:c6c723612dabdade2ec8e9',
    messagingSenderId: '494988082252',
    projectId: 'medidignose',
    storageBucket: 'medidignose.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCX2ypohHQf5SeRmzb_f7oNyAUgrZDrJc4',
    appId: '1:494988082252:ios:b2cea6b2e095098a2ec8e9',
    messagingSenderId: '494988082252',
    projectId: 'medidignose',
    storageBucket: 'medidignose.appspot.com',
    iosBundleId: 'com.example.flutterFrontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCX2ypohHQf5SeRmzb_f7oNyAUgrZDrJc4',
    appId: '1:494988082252:ios:b2cea6b2e095098a2ec8e9',
    messagingSenderId: '494988082252',
    projectId: 'medidignose',
    storageBucket: 'medidignose.appspot.com',
    iosBundleId: 'com.example.flutterFrontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDc9dwrAQ_l25L2wsJLn1JYwMWZqcF8FwI',
    appId: '1:494988082252:web:96b4e3d2d906d72d2ec8e9',
    messagingSenderId: '494988082252',
    projectId: 'medidignose',
    authDomain: 'medidignose.firebaseapp.com',
    storageBucket: 'medidignose.appspot.com',
  );
}
