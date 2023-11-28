import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbAuth {
  static User? fbUser;
  static String? _fbToken;
  static DateTime? _fbTokenExpire;

  static StreamSubscription<User?>? _subsUser;

  // property
  static bool get isLogged => fbUser != null;
  static String? get uid => fbUser?.uid;

  //------------------------------------------------------------
  // init, dispose
  //------------------------------------------------------------
  static Future<void> init() async {
    _listenUser();
  }

  static void dispose() {
    _subsUser?.cancel();
    _subsUser = null;
  }

  static void _listenUser() {
    final auth = FirebaseAuth.instance;

    _subsUser?.cancel();
    _subsUser = auth.userChanges().listen((user) {
      fbUser = user;

      if (isLogged) {
        // fbUser!.getIdTokenResult().then((value) {
        //   _fbToken = value.token;
        //   _fbTokenExpire = value.expirationTime;
        // });
      }
    });
    _subsUser!.onError((err) async {
      await Future.delayed(const Duration(milliseconds: 500));
      _listenUser();
    });
  }

  //------------------------------------------------------------
  // login, logout
  //------------------------------------------------------------
  static Future<String?> signInWithGoogleSignIn({
    bool unlink = false,
  }) async {
    if (unlink) {
      await unlinkGoogle();
    }
    if (isLogged) {
      await signOut();
    }

    try {
      final googleUser = (await GoogleSignIn(scopes: ['email']).signIn())!;
      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .timeout(const Duration(seconds: 10));

      return userCredential.user?.uid;
    } catch (e) {}
    return null;
  }

  static Future<void> unlinkGoogle() async {
    try {
      await fbUser?.unlink('google.com');
    } catch (e) {}
  }

  static Future<void> signOut() async {
    if (!isLogged) return;

    try {
      await FirebaseAuth.instance.signOut();
      fbUser = null;
    } catch (e) {}
  }
}
