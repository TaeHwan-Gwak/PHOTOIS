//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:photois/style/style.dart';
import 'dart:convert';

import '../Main/data.dart';

// naver client ID : 'ud3er0cxg6'

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  final photoController = Get.put((PhotoSpotInfo()));
  final sizeController = Get.put((SizeController()));

  NaverMapController? _controller;
  late NMarker marker;

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "ud3er0cxg6",
    "X-NCP-APIGW-API-KEY": "i5bTtbxYq6VpOvNCYN4A6Qlw8hDzAdFKw0AsEk6s"
  };

  double lat = 0;
  double lng = 0;

  List<String> which = [];
  var which_one = "";
  var which_two = "";
  var which_three = "";
  var which_four = "";
  var which_String = "";

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = (photoController.spotLatitude.value == 0.0)
          ? position.latitude
          : photoController.spotLatitude.value;
      lng = (photoController.spotLongitude.value == 0.0)
          ? position.longitude
          : photoController.spotLongitude.value;
    } catch (e) {
      print('error');
    }

    http.Response response = await http.get(
      Uri.parse(
        "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json",
      ),
      headers: headerss,
    );

    String jsonData = response.body;

    which_one =
        jsonDecode(jsonData)["results"][1]['region']['area1']['name'] ?? "";
    which_two =
        jsonDecode(jsonData)["results"][1]['region']['area2']['name'] ?? "";
    which_three =
        jsonDecode(jsonData)["results"][1]['region']['area3']['name'] ?? "";
    which_four =
        jsonDecode(jsonData)["results"][1]['region']['area4']['name'] ?? "";

    which = [which_one, which_two, which_three, which_four];

    which_String = "$which_one $which_two $which_three $which_four";

    photoController.spotExtraAddress.value = which_String;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "세부 위치 조정",
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w700,
                color: AppColor.textColor),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeController.screenHeight.value * 0.05,
            child: Center(
              child: Text(
                "\"사진 명소의 자세한 위치로 조정해주세요\"",
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w300,
                    color: AppColor.textColor),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final cameraPosition = NCameraPosition(
                    target: NLatLng(lat, lng),
                    zoom: 15,
                    bearing: 0,
                    tilt: 0,
                  );
                  return NaverMap(
                    options: NaverMapViewOptions(
                      scaleBarEnable: false,
                      locationButtonEnable: true,
                      logoClickEnable: false,
                      extent: const NLatLngBounds(
                        southWest: NLatLng(31.43, 122.37),
                        northEast: NLatLng(44.35, 132.0),
                      ),
                      initialCameraPosition: cameraPosition,
                    ),
                    onMapReady: (controller) async {
                      _controller = controller;

                      final iconImage = await NOverlayImage.fromWidget(
                        widget: const Icon(Icons.place,
                            size: 32, color: AppColor.backgroundColor),
                        size: const Size(32, 32),
                        context: context,
                      );

                      marker = NMarker(
                        id: 'which',
                        position: NLatLng(lat, lng),
                        icon: iconImage,
                      );

                      _controller?.addOverlay(marker);

                      //photoController.spotMainAddress.value = photoController.spotMainAddress.value;
                    },
                    onMapTapped: (point, latLng) async {
                      lat = latLng.latitude;
                      lng = latLng.longitude;

                      http.Response response = await http.get(
                        Uri.parse(
                          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json",
                        ),
                        headers: headerss,
                      );

                      String jsonData = response.body;

                      which_one = jsonDecode(jsonData)["results"][1]['region']
                              ['area1']['name'] ??
                          "";
                      which_two = jsonDecode(jsonData)["results"][1]['region']
                              ['area2']['name'] ??
                          "";
                      which_three = jsonDecode(jsonData)["results"][1]['region']
                              ['area3']['name'] ??
                          "";
                      which_four = jsonDecode(jsonData)["results"][1]['region']
                              ['area4']['name'] ??
                          "";

                      which = [which_one, which_two, which_three, which_four];

                      which_String =
                          "$which_one $which_two $which_three $which_four";

                      final iconImage = await NOverlayImage.fromWidget(
                        widget: const Icon(Icons.place,
                            size: 32, color: AppColor.backgroundColor),
                        size: const Size(32, 32),
                        context: context,
                      );

                      final updatedMarker = NMarker(
                        id: 'which',
                        position: NLatLng(lat, lng),
                        icon: iconImage,
                      );

                      final cameraUpdate = NCameraUpdate.withParams(
                        target: NLatLng(lat, lng),
                      );

                      _controller?.updateCamera(cameraUpdate);

                      _controller?.addOverlay(updatedMarker);

                      photoController.spotExtraAddress.value =
                          "$which_one $which_two $which_three $which_four";
                    },
                  );
                } else {
                  // 위치 정보를 아직 가져오지 못한 경우 로딩 표시 또는 다른 대응을 할 수 있습니다.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: sizeController.screenHeight.value * 0.2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: AppColor.objectColor,
                        ),
                        Obx(
                          () => Text(
                            ' ${photoController.spotExtraAddress.value}',
                            style: TextStyle(
                                fontSize: sizeController.mainFontSize.value,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textColor),
                          ),
                        )
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.objectColor,
                        backgroundColor: AppColor.objectColor,
                        shadowColor: AppColor.objectColor,
                        minimumSize: Size(
                          sizeController.screenWidth.value * 0.6,
                          sizeController.screenHeight.value * 0.05,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        photoController.spotLatitude.value = lat;
                        photoController.spotLongitude.value = lng;
                        Get.back();
                      },
                      child: Center(
                        child: Text(
                          '이 위치로 주소 설정',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w500,
                              color: AppColor.backgroundColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeController.screenHeight * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
