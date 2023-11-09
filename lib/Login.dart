import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login_extra1.dart';
import 'MainScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginMainScreen extends StatefulWidget {
  const LoginMainScreen({super.key});

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen> {
  @override
  Widget build(BuildContext context) {
    final String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                imageLogoName,
                width: screenWidth * 0.9,
                height: screenHeight * 0.1,
              ),
            ),
            Divider(
                thickness: 6, indent: 40, endIndent: 40, color: Colors.black),
            Text(
              "당신만의 사진 스팟",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 170,
            ),
            ElevatedButton(
                onPressed: signInWithGoogle,
                child: Text("Google")),
            /*
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => loginExtra1()));
                },
                child: Text("kakao")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                },
                child: Text("google"))

             */
          ],
        ),
      ),
    );
  }
}
