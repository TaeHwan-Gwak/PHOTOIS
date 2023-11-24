import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

class SelectWeather extends StatefulWidget {
  const SelectWeather({super.key});

  @override
  State<SelectWeather> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectWeather> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "사진 정보를 입력해주세요",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'WEATHER',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Ink(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: (controller.spotWeather.value == 1)
                        ? Colors.tealAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.spotWeather.value = 1;
                      });
                    },
                    icon: const Icon(MyFlutterApp.sun),
                    iconSize: 40,
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: (controller.spotWeather.value == 2)
                        ? Colors.tealAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.spotWeather.value = 2;
                      });
                    },
                    icon: const Icon(MyFlutterApp.cloudSun),
                    iconSize: 40,
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: (controller.spotWeather.value == 3)
                        ? Colors.tealAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.spotWeather.value = 3;
                      });
                    },
                    icon: const Icon(MyFlutterApp.cloud),
                    iconSize: 40,
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: (controller.spotWeather.value == 4)
                        ? Colors.tealAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.spotWeather.value = 4;
                      });
                    },
                    icon: const Icon(MyFlutterApp.rainy),
                    iconSize: 40,
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: (controller.spotWeather.value == 5)
                        ? Colors.tealAccent
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.spotWeather.value = 5;
                      });
                    },
                    icon: const Icon(MyFlutterApp.snow),
                    iconSize: 40,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.black,
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Center(
                      child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData snow =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cloudSun =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rainy =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sun =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cloud =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
