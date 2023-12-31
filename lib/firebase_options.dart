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
    apiKey: 'AIzaSyDL14VLMNGPZ4MXPxXFM24rhB6uySSss-U',
    appId: '1:528948528935:web:04c43ce5e7c71ae1208b02',
    messagingSenderId: '528948528935',
    projectId: 'photois-e0f82',
    authDomain: 'photois-e0f82.firebaseapp.com',
    storageBucket: 'photois-e0f82.appspot.com',
    measurementId: 'G-VVZRGDCX22',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgRK-orl-13j1r1yV3bDam77G3_IGCjMk',
    appId: '1:528948528935:android:e7a3313fc07928ff208b02',
    messagingSenderId: '528948528935',
    projectId: 'photois-e0f82',
    storageBucket: 'photois-e0f82.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjD6a-41JE0L1ytB0ABexmNrHQ98waoE8',
    appId: '1:528948528935:ios:9d6a0be5e696ec0c208b02',
    messagingSenderId: '528948528935',
    projectId: 'photois-e0f82',
    storageBucket: 'photois-e0f82.appspot.com',
    androidClientId:
        '528948528935-g6gk0lsfai79qif3342m0kb2qqoa74sm.apps.googleusercontent.com',
    iosClientId:
        '528948528935-io65rrmnmo1r9drh61eg3s5atcc8vedg.apps.googleusercontent.com',
    iosBundleId: 'com.example.photois',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjD6a-41JE0L1ytB0ABexmNrHQ98waoE8',
    appId: '1:528948528935:ios:1abb04bdef16148d208b02',
    messagingSenderId: '528948528935',
    projectId: 'photois-e0f82',
    storageBucket: 'photois-e0f82.appspot.com',
    androidClientId:
        '528948528935-g6gk0lsfai79qif3342m0kb2qqoa74sm.apps.googleusercontent.com',
    iosClientId:
        '528948528935-df4uv17oddt125narc9ondmil6b7gcfj.apps.googleusercontent.com',
    iosBundleId: 'com.cau.photois.RunnerTests',
  );
}
