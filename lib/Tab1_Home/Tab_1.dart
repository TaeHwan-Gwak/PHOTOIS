import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

import '../Tab3_Add/add_post.dart';

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
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
          title: Image.asset(
            imageLogoName,
            width: sizeController.screenWidth.value * 0.3,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const Tab3());
                },
                icon: const Icon(Icons.add_photo_alternate_outlined))
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(-10),
            child: Divider(
              height: 2,
              color: Colors.black,
              thickness: 2, // 줄의 색상 설정
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeController.screenHeight.value * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " 주변 인기사진 스팟",
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
    );
  }
}
