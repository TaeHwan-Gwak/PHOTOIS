import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginMainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            //height : MediaQuery.of(context).size.height,
            //color: kPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.384375),
                Container(
                  child: Image.asset(
                    imageLogoName,
                    width: screenWidth * 0.616666,
                    height: screenHeight * 0.0859375,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  child: Text("© Copyright 2023, 포토이즈(PHOTOIS)",
                      style: TextStyle(
                        fontSize: screenWidth * (14 / 360),
                        color: Colors.black,
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0625,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
