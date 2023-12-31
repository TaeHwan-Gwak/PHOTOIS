import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photois/service/account.dart';

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
    final FirebaseAuth auth = FirebaseAuth.instance;

    fbUser = auth.currentUser;
    if(fbUser != null) {
      Get.find<AccountController>().getUserInfo(fbUser);
    }

    _subsUser?.cancel();
    _subsUser = auth.userChanges().listen((user) {
      fbUser = user;

      if (isLogged) {
        // fbUser!.getIdTokenResult().then((value) {
        //   _fbToken = value.token;
        //   _fbTokenExpire = value.expirationTime;
        // });
      } else {
        Get.offNamed('/login');
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
  static Future<String> signInWithGoogleSignIn({
    bool unlink = false,
  }) async {
    if (unlink) {
      await unlinkGoogle();
    }
    // if (isLogged) {
    //   await signOut();
    // }

    try {
      final GoogleSignInAccount googleUser = (await GoogleSignIn(scopes: ['email']).signIn())!;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .timeout(const Duration(seconds: 10));

      print('userCredential.additionalUserInfo?.isNewUser :${userCredential.additionalUserInfo?.isNewUser} ');
      Get.find<AccountController>().getUserInfo(userCredential.user);
      if(userCredential.additionalUserInfo?.isNewUser ?? true) {
        return 'register';
      } else {
        return 'success';
      }

    } catch (e) {
      return 'fail';
    }

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

  static Future<void> deleteUser() async {
    if (!isLogged) return;

    try {
      await fbUser?.delete();

      fbUser = null;
    } catch (e) {}
  }
}
