// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    // if (kIsWeb) {
    //   return web;
    // }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // case TargetPlatform.iOS:
      //   return ios;
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

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyB5aC8WwOk_MMR9E16bvbcp4sXISkfkybA',
  //   appId: '1:251067474901:web:7a8a20811d3b1f83d3935c',
  //   messagingSenderId: '251067474901',
  //   projectId: 'thinpc-scanner',
  //   authDomain: 'thinpc-scanner.firebaseapp.com',
  //   databaseURL: 'https://thinpc-scanner-default-rtdb.firebaseio.com',
  //   storageBucket: 'thinpc-scanner.appspot.com',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDJ-p1i5_metMjWItnw-jVMUNvjdORuX0',
    appId: '1:660615930066:android:5a5e1a7a1f2ea5a804cd0b',
    messagingSenderId: '660615930066',
    projectId: 'tulip-diagnostics-prod',
    // databaseURL: 'https://thinpc-scanner-default-rtdb.firebaseio.com',
    storageBucket: 'tulip-diagnostics-prod.appspot.com',
  );
  //
  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyDjwSqgt3Upn38HcFRTpSIsPi1gOuqLJ5A',
  //   appId: '1:559148365146:web:b073d36ff937ec1834ef63',
  //   messagingSenderId: '559148365146',
  //   projectId: 'fcxt-21ec4',
  //   databaseURL: 'https://fcxt-21ec4-default-rtdb.firebaseio.com',
  //   storageBucket: 'fcxt-21ec4.appspot.com',
  //   // androidClientId: '251067474901-bjhhqi80109ro03cu260id7rfnshbemn.apps.googleusercontent.com',
  //   // iosClientId: '251067474901-qe8unqb26jehs08ubvebk3t128i3818g.apps.googleusercontent.com',
  //   // iosBundleId: 'com.example.thinpcScanner',
  // );
}
