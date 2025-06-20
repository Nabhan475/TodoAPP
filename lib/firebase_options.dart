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
    apiKey: 'AIzaSyDkDmLuszhFpRh_ZdLr8FS6JoOedTE1iM8',
    appId: '1:843593401152:web:1d72d9d97994c4e04db0a5',
    messagingSenderId: '843593401152',
    projectId: 'todoapp-651a4',
    authDomain: 'todoapp-651a4.firebaseapp.com',
    storageBucket: 'todoapp-651a4.firebasestorage.app',
    measurementId: 'G-6J82DV1LW5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5s1RuIYHKxbV7YTmr2Zanb7us8_-Su_8',
    appId: '1:843593401152:android:3394fa44cbda29014db0a5',
    messagingSenderId: '843593401152',
    projectId: 'todoapp-651a4',
    storageBucket: 'todoapp-651a4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCM9o69pddEhwQSwmETCeDBvi_q5EG4FZ8',
    appId: '1:843593401152:ios:adcd3c6d6d61e9de4db0a5',
    messagingSenderId: '843593401152',
    projectId: 'todoapp-651a4',
    storageBucket: 'todoapp-651a4.firebasestorage.app',
    iosBundleId: 'com.example.todoapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCM9o69pddEhwQSwmETCeDBvi_q5EG4FZ8',
    appId: '1:843593401152:ios:adcd3c6d6d61e9de4db0a5',
    messagingSenderId: '843593401152',
    projectId: 'todoapp-651a4',
    storageBucket: 'todoapp-651a4.firebasestorage.app',
    iosBundleId: 'com.example.todoapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkDmLuszhFpRh_ZdLr8FS6JoOedTE1iM8',
    appId: '1:843593401152:web:8675c081545f1be94db0a5',
    messagingSenderId: '843593401152',
    projectId: 'todoapp-651a4',
    authDomain: 'todoapp-651a4.firebaseapp.com',
    storageBucket: 'todoapp-651a4.firebasestorage.app',
    measurementId: 'G-CL47YSB74Q',
  );
}
