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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxo6jxQAb7MAYSq018lBarJlpTMdlvv10',
    appId: '1:148615248582:android:31964c7e37e4d6a8ee35c7',
    messagingSenderId: '148615248582',
    projectId: 'book-41cab',
    storageBucket: 'book-41cab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAz7oOcS-11zbP7TnZsRfuXb52JZ7xlngc',
    appId: '1:148615248582:ios:0af808e8e4f96795ee35c7',
    messagingSenderId: '148615248582',
    projectId: 'book-41cab',
    storageBucket: 'book-41cab.appspot.com',
    androidClientId: '148615248582-11spr1t6pp3n3m3mgflktk069c5cmb3g.apps.googleusercontent.com',
    iosClientId: '148615248582-fs7phb9fecqrmh1qbtl6sdne1c745hla.apps.googleusercontent.com',
    iosBundleId: 'com.example.ebook',
  );
}
