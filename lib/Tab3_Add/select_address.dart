import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Main/data.dart';

// naver client ID : 'ud3er0cxg6'

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  NaverMapController? _controller;
  late final marker;
  double lat = 37;
  double lng = 126;

  Future<void> getCurrentLocation() async {
    Map<String, String> headerss = {
      "X-NCP-APIGW-API-KEY-ID": "ud3er0cxg6",
      "X-NCP-APIGW-API-KEY": "i5bTtbxYq6VpOvNCYN4A6Qlw8hDzAdFKw0AsEk6s"
    };

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude;
      lng = position.longitude;
    } catch (e) {
      print('error');
    }

    http.Response response = await http.get(
        Uri.parse(
            "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json"),
        headers: headerss);

    String jsonData = response.body;

    print(jsonData);

    var myJson_one =
        jsonDecode(jsonData)["results"][1]['region']['area1']['name'];
    var myJson_two =
        jsonDecode(jsonData)["results"][1]['region']['area2']['name'];
    var myJson_three =
        jsonDecode(jsonData)["results"][1]['region']['area3']['name'];
    var myJson_four =
        jsonDecode(jsonData)["results"][1]['region']['area4']['name'];

    List<String> which = [myJson_one, myJson_two, myJson_three, myJson_four];
    print(which);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   위치 정보를 확인해주세요.",
            style: TextStyle(fontSize: sizeController.bigFontSize.value),
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
                          widget: const FlutterLogo(),
                          size: const Size(24, 24),
                          context: context);

                      marker = NMarker(
                        id: 'which',
                        position: NLatLng(lat, lng),
                        icon: iconImage,
                      );
                      _controller?.addOverlay(marker);
                      marker.setOnTapListener((NMarker marker) {});
                    },
                    onMapTapped: (point, latLng) async {
                      lat = latLng.latitude;
                      lng = latLng.longitude;

                      print(lat);
                      print(lng);

                      final iconImage = await NOverlayImage.fromWidget(
                          widget: const FlutterLogo(),
                          size: const Size(24, 24),
                          context: context);

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
                    },
                  );
                } else {
                  // 위치 정보를 아직 가져오지 못한 경우 로딩 표시 또는 다른 대응을 할 수 있습니다.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    /*
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "위치 정보를 확인해주세요.",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
     */
  }
}
