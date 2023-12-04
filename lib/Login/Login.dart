import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photois/Main/data.dart';
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
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: sizeController.screenHeight * 0.2,
          ),
          Image.asset(
            imageLogoName,
            width: sizeController.screenWidth.value * 0.616666,
            height: sizeController.screenHeight.value * 0.0859375,
          ),
          Divider(
              thickness: 4,
              indent: sizeController.screenWidth.value * 0.15,
              endIndent: sizeController.screenWidth.value * 0.15,
              color: Colors.black),
          Text(
            "당신만의 사진 스팟",
            style: TextStyle(fontSize: sizeController.bigFontSize.value),
          ),
          const Expanded(child: SizedBox()),
          InkWell(
              onTap: () {
                Get.offNamed('/login2');
                //Get.offNamed('/main');
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
                  "assets/images/kakao_login.png",
                  width: sizeController.screenWidth.value * 0.6,
                  fit: BoxFit.fill,
                ),
              )),
          SizedBox(
            height: sizeController.screenHeight.value * 0.03,
          ),
          InkWell(
            onTap: () async {
              final loggedUid =
                  await FbAuth.signInWithGoogleSignIn(unlink: true);
              debugPrint('loggedUid: $loggedUid');

              if (loggedUid == 'success') {
                Get.snackbar('로그인 성공', '로그인에 성공했습니다.');
                Get.offNamed('/main');
              } else if(loggedUid == 'register') {
                Get.toNamed('/login1');
              } else {
                Get.snackbar('로그인 실패', '로그인에 실패했습니다.');
              }
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
                width: sizeController.screenWidth.value * 0.6,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          )
        ],
      ),
    );
  }
}
