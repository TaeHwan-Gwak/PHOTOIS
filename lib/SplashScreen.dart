import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      Get.offNamed('/login');
    });

    initServices();
  }

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.384375),
              Image.asset(
                imageLogoName,
                width: screenWidth * 0.616666,
                height: screenHeight * 0.0859375,
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
    );
  }
}
