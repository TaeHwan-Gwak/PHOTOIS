import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    final sizeController = Get.put((SizeController()));
    const String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeController.screenHeight * 0.05,
          ),
          Padding(
            padding: EdgeInsets.all(sizeController.screenHeight.value * 0.02),
            child: Image.asset(
              imageLogoName,
              width: sizeController.screenWidth.value * 0.3,
            ),
          ),
          const Divider(
              thickness: 2, indent: 0, endIndent: 0, color: Colors.black),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.all(sizeController.screenHeight.value * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " 주변 인기사진 스팟",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value),
                    ),
                    SizedBox(
                      height: sizeController.screenWidth.value * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            width: sizeController.screenWidth.value * 0.3,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.02,
                          ),
                          Container(
                            width: sizeController.screenWidth.value * 0.3,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.02,
                          ),
                          Container(
                            width: sizeController.screenWidth.value * 0.3,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.02,
                          ),
                          Container(
                            width: sizeController.screenWidth.value * 0.3,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.02,
                          ),
                          Container(
                            width: sizeController.screenWidth.value * 0.3,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: sizeController.screenWidth.value * 0.02,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeController.screenHeight.value * 0.03,
                    ),
                    Text(
                      " 주변 인기사진 스팟",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value),
                    ),
                    Container(
                      height: sizeController.screenWidth.value * 0.3,
                      width: sizeController.screenWidth.value * 0.3,
                      color: Colors.deepOrangeAccent,
                    ),
                    SizedBox(
                      height: sizeController.screenHeight.value * 0.03,
                    ),
                    Text(
                      " 주변 인기사진 스팟",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value),
                    ),
                    Container(
                      height: sizeController.screenWidth.value * 0.3,
                      width: sizeController.screenWidth.value * 0.3,
                      color: Colors.deepOrangeAccent,
                    ),
                    SizedBox(
                      height: sizeController.screenHeight.value * 0.03,
                    ),
                    Text(
                      " 주변 인기사진 스팟",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value),
                    ),
                    Container(
                      height: sizeController.screenWidth.value * 0.3,
                      width: sizeController.screenWidth.value * 0.3,
                      color: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
