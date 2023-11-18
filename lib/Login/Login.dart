import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photois/service/firebase.auth.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              imageLogoName,
              width: screenWidth * 0.9,
              height: screenHeight * 0.1,
            ),
            const Divider(
                thickness: 6, indent: 40, endIndent: 40, color: Colors.black),
            const Text(
              "당신만의 사진 스팟",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 200,
            ),
            InkWell(
                onTap: () {
                  Get.offNamed('/login1');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset:
                            const Offset(0, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/kakao_login.png",
                    width: 250,
                    fit: BoxFit.fill,
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                final loggedUid = await FbAuth.signInWithGoogleSignIn(
                  unlink: true,
                );
                debugPrint('loggedUid: $loggedUid');

                if (loggedUid != null) {
                  Get.snackbar('로그인 성공', '로그인에 성공했습니다.');
                  Get.offNamed('/main');
                } else {
                  Get.snackbar('로그인 실패', '로그인에 실패했습니다.');
                }

                // Get.offNamed('/main');
                //signInWithGoogle;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: const Offset(0, 10), // changes position of shadow
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/images/google_login.png",
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
