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

  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "ud3er0cxg6",
    "X-NCP-APIGW-API-KEY": "i5bTtbxYq6VpOvNCYN4A6Qlw8hDzAdFKw0AsEk6s"
  };

  double lat = 37;
  double lng = 126;

  List<String> which = [];
  var which_one = '-';
  var which_two = '-';
  var which_three = '-';
  var which_four = '-';
  var which_add = '-';

  var land = '-';

  Future<void> getCurrentLocation() async {
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
            "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json&orders=roadaddr"),
        headers: headerss);

    String jsonData = response.body;

    which_one = jsonDecode(jsonData)["results"][0]['region']['area1']['name'];
    which_two = jsonDecode(jsonData)["results"][0]['region']['area2']['name'];
    which_three = jsonDecode(jsonData)["results"][0]['region']['area3']['name'];
    which_four = jsonDecode(jsonData)["results"][0]['region']['area4']['name'];
    which_add = jsonDecode(jsonData)["results"][0]['land']['number1'];

    land = jsonDecode(jsonData)["results"][0]['land']['addition0']['value'];

    which = [which_one, which_two, which_three, which_four, which_add];
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String currentAddress = '';
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back,
                  size: sizeController.bigFontSize.value)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "위치 정보를 확인해주세요.",
              style: TextStyle(fontSize: sizeController.bigFontSize.value),
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

                      http.Response response = await http.get(
                          Uri.parse(
                              "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json&orders=roadaddr"),
                          headers: headerss);

                      String jsonData = response.body;

                      which_one = jsonDecode(jsonData)["results"][0]['region']
                          ['area1']['name'];
                      which_two = jsonDecode(jsonData)["results"][0]['region']
                          ['area2']['name'];
                      which_three = jsonDecode(jsonData)["results"][0]['region']
                          ['area3']['name'];
                      which_four = jsonDecode(jsonData)["results"][0]['region']
                          ['area4']['name'];
                      which_add =
                          jsonDecode(jsonData)["results"][0]['land']['number1'];

                      land = jsonDecode(jsonData)["results"][0]['land']
                          ['addition0']['value'];

                      which = [
                        which_one,
                        which_two,
                        which_three,
                        which_four,
                        which_add,
                      ];

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
          Padding(
            padding: EdgeInsets.all(sizeController.screenHeight.value * 0.03),
            child: SizedBox(
              height: sizeController.screenHeight.value * 0.25,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_pin),
                        Text(
                          controller.spotMainAddress.value,
                          style: TextStyle(
                              fontSize: sizeController.mainFontSize.value),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            hintText: '상세 주소를 정확하게 기입해주세요',
                            hintStyle: TextStyle(
                                fontSize: sizeController.middleFontSize.value),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                    strokeAlign:
                                        BorderSide.strokeAlignOutside)),
                            focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ))),
                        onSaved: (value) {
                          controller.spotExtraAddress.value = value!;
                        },
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueGrey,
                          backgroundColor: Colors.blueGrey,
                          shadowColor: Colors.black,
                          minimumSize: Size(
                              sizeController.screenWidth.value * 0.6,
                              sizeController.screenHeight.value * 0.05),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final formKeyState = _formKey.currentState!;
                          if (formKeyState.validate()) {
                            formKeyState.save();
                            Get.back();
                          }
                        },
                        child: Center(
                            child: Text(
                          '이 위치로 주소 설정',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizeController.middleFontSize.value),
                        ))),
                    SizedBox(
                      height: sizeController.screenHeight * 0.03,
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
