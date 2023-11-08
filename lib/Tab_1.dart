import 'package:flutter/material.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    final String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Image.asset(
                imageLogoName,
                width: screenWidth * 0.3,
                height: screenHeight * 0.06,
              ),
            ),
            Divider(thickness: 3, indent: 0, endIndent: 0, color: Colors.black),
            SizedBox(
              height: 10,
            ),
            Text(
              " 주변 인기사진 스팟",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
