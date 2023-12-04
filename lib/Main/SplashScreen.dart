import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/service/firebase.auth.dart';

import '../style/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /*
    Timer(const Duration(milliseconds: 2000), () {
      Get.offNamed('/login');
    });
    */
    if (FbAuth.isLogged) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offNamed('/main');
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offNamed('/login');
      });
    }

    // initServices();
  }

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: Center(
            child: Image.asset(
              imageLogoName,
              width: screenWidth * 0.6,
              height: screenHeight * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
