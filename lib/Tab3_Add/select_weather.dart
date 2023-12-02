import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../style/weather_icon.dart';

class SelectWeather extends StatefulWidget {
  const SelectWeather({super.key});

  @override
  State<SelectWeather> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectWeather> {
  double lat = 37;
  double lng = 126;

  int start = 0;
  int end = 0;

  String condition = '-';

  Future getWeather() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lng = position.longitude;

      http.Response response = await http.get(
        Uri.parse(
            "https://history.openweathermap.org/data/2.5/history/city?lat=${lat}&lon=${lng}&type=hour&start=${start}&end=${end}&appid=2ed1135aa0f58dafe0d2ead1574e0242"),
      );

      String jsonData = response.body;

      String condition = jsonDecode(jsonData)['list'][0]['weather'][0]['main'];

      print(condition);
    } catch (e) {
      print('error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    final sizeController = Get.put((SizeController()));

    DateTime originalDateTime = controller.spotDate.value;

    // UTC+9
    DateTime subtractedDateTime = originalDateTime.subtract(Duration(hours: 9));

    int startTime = subtractedDateTime.millisecondsSinceEpoch ~/ 1000;
    start = startTime;
    int endTime = startTime + 3600;
    end = endTime;

    getWeather();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeController.screenHeight.value * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "날씨 정보를 확인해주세요",
              style: TextStyle(fontSize: sizeController.bigFontSize.value),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.03,
            ),
            Text(
              " WEATHER",
              style: TextStyle(fontSize: sizeController.mainFontSize.value),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Ink(
                  padding:
                      EdgeInsets.all(sizeController.screenHeight.value * 0.001),
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
                    icon: const Icon(WeatherIcon.sun),
                    iconSize: sizeController.bigFontSize.value * 2,
                  ),
                ),
                Ink(
                  padding:
                      EdgeInsets.all(sizeController.screenHeight.value * 0.001),
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
                    icon: const Icon(WeatherIcon.cloud),
                    iconSize: sizeController.bigFontSize.value * 2,
                  ),
                ),
                Ink(
                  padding:
                      EdgeInsets.all(sizeController.screenHeight.value * 0.001),
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
                    icon: const Icon(WeatherIcon.rain),
                    iconSize: sizeController.bigFontSize.value * 2,
                  ),
                ),
                Ink(
                  padding:
                      EdgeInsets.all(sizeController.screenHeight.value * 0.001),
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
                    icon: const Icon(WeatherIcon.snow),
                    iconSize: sizeController.bigFontSize.value * 2,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.3,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Center(
                      child: Text(
                    '확인',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: sizeController.middleFontSize.value),
                  ))),
            ),
            SizedBox(
              height: sizeController.screenHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
