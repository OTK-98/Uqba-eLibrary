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
    apiKey: 'AIzaSyBoje3GipWOlN_cbbPQDmMCkbraRT5vZHA',
    appId: '1:597033052119:web:23a66d530ba346bc9a8d92',
    messagingSenderId: '597033052119',
    projectId: 'uqba-elibrary',
    authDomain: 'uqba-elibrary.firebaseapp.com',
    storageBucket: 'uqba-elibrary.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAr3fjeQEnO7VEFH0vJ3ySSpqsLLvsDhbo',
    appId: '1:597033052119:android:305e91b0d3f7a7b19a8d92',
    messagingSenderId: '597033052119',
    projectId: 'uqba-elibrary',
    storageBucket: 'uqba-elibrary.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3U2B8eAeBt93JiaUr9n9_FtacGnCt-vM',
    appId: '1:597033052119:ios:f05b91c20117164e9a8d92',
    messagingSenderId: '597033052119',
    projectId: 'uqba-elibrary',
    storageBucket: 'uqba-elibrary.appspot.com',
    iosBundleId: 'com.example.uqbaElibrary',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3U2B8eAeBt93JiaUr9n9_FtacGnCt-vM',
    appId: '1:597033052119:ios:f05b91c20117164e9a8d92',
    messagingSenderId: '597033052119',
    projectId: 'uqba-elibrary',
    storageBucket: 'uqba-elibrary.appspot.com',
    iosBundleId: 'com.example.uqbaElibrary',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBoje3GipWOlN_cbbPQDmMCkbraRT5vZHA',
    appId: '1:597033052119:web:5456e47e2db94f549a8d92',
    messagingSenderId: '597033052119',
    projectId: 'uqba-elibrary',
    authDomain: 'uqba-elibrary.firebaseapp.com',
    storageBucket: 'uqba-elibrary.appspot.com',
  );
}
