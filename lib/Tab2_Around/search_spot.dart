import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kpostal/kpostal.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../style/style.dart';

// naver client ID : 'ud3er0cxg6'

enum SearchSeason {
  season,
  spring,
  summer,
  autumn,
  winter,
  ;

  String get title => const <SearchSeason, String>{
        SearchSeason.season: '계절 선택',
        SearchSeason.spring: '봄',
        SearchSeason.summer: '여름',
        SearchSeason.autumn: '가을',
        SearchSeason.winter: '겨울',
      }[this]!;
}

enum SearchTime {
  time,
  day,
  night,
  ;

  String get title => const <SearchTime, String>{
        SearchTime.time: '시간 선택',
        SearchTime.day: '주간',
        SearchTime.night: '야간',
      }[this]!;
}

enum SearchWeather {
  weather,
  sun,
  clouds,
  rain,
  snow;

  String get title => const <SearchWeather, String>{
        SearchWeather.weather: '날씨 선택',
        SearchWeather.sun: '맑음',
        SearchWeather.clouds: '구름',
        SearchWeather.rain: '비',
        SearchWeather.snow: '눈',
      }[this]!;
}

class SearchSpot extends StatefulWidget {
  const SearchSpot({super.key});

  @override
  State<SearchSpot> createState() => _SearchSpotState();
}

class _SearchSpotState extends State<SearchSpot> {
  double lat = 37;
  double lng = 126;
  bool locationObtained = true;
  bool clickButton = false;

  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String condition = '-';
  List<String> which = [];
  var which_one = "";
  var which_two = "";
  var which_three = "";
  var which_four = "";
  var which_String = "";

  final TextEditingController _searchController = TextEditingController();
  SearchSeason selectedSeason = SearchSeason.season;
  SearchTime selectedTime = SearchTime.time;
  SearchWeather selectedWeather = SearchWeather.weather;
  String searchLocation = '';

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
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lng = position.longitude;

      http.Response responseWeahter = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=2ed1135aa0f58dafe0d2ead1574e0242"),
      );

      String jsonDataWeather = responseWeahter.body;
      print(jsonDataWeather);
      condition = jsonDecode(jsonDataWeather)['weather'][0]['main'];

      http.Response responseAddress = await http.get(
        Uri.parse(
          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json",
        ),
        headers: headerss,
      );

      String jsonDataAddress = responseAddress.body;

      which_one = jsonDecode(jsonDataAddress)["results"][1]['region']['area1']
              ['name'] ??
          "";
      which_two = jsonDecode(jsonDataAddress)["results"][1]['region']['area2']
              ['name'] ??
          "";
      which_three = jsonDecode(jsonDataAddress)["results"][1]['region']['area3']
              ['name'] ??
          "";
      which_four = jsonDecode(jsonDataAddress)["results"][1]['region']['area4']
              ['name'] ??
          "";

      which = [which_one, which_two, which_three, which_four];

      which_String = "$which_one $which_two $which_three $which_four";

      searchLocation = which_String;
/*
      var long = jsonDecode(jsonDataAddress)['addresses'][0]['x'];
      var lati = jsonDecode(jsonDataAddress)['addresses'][0]['y'];

      print(long);
      print(lati);

 */
    } catch (e) {
      print('error');
    }
  }

  Future<void> getSearchLocation() async {
    lat = lat;
    lng = lng;
  }

  @override
  void initState() {
    super.initState();
    getPostInfoCount();
    getCurrentLocation();
  }

  int postInfoCount = 0;
  List<Map<String, dynamic>> documentsData = [];

  Future<void> getPostInfoCount() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('PostInfo').get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Convert each document to a Map
        Map<String, dynamic> documentData =
            document.data() as Map<String, dynamic>;
        documentsData.add(documentData);
      }

      // 문서 개수
      int count = querySnapshot.size;

      setState(() {
        postInfoCount = count;
      });
    } catch (e) {
      print('Error getting post info count: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeController = Get.put((SizeController()));
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          "PHOTOIS",
          style: TextStyle(
              fontSize: sizeController.bigFontSize.value,
              fontWeight: FontWeight.w900,
              color: AppColor.objectColor),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: sizeController.screenHeight.value * 0.04,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchSeason>(
                        underline: Container(height: 0),
                        iconEnabledColor: AppColor.objectColor,
                        dropdownColor: AppColor.backgroundColor,
                        hint: Center(
                          child: Text(
                            '계절 선택',
                            style: TextStyle(
                                fontSize: sizeController.middleFontSize.value,
                                fontWeight: FontWeight.w300,
                                color: AppColor.textColor),
                          ),
                        ),
                        value: selectedSeason != SearchSeason.season
                            ? selectedSeason
                            : null,
                        isExpanded: true,
                        onChanged: (SearchSeason? newValue) {
                          setState(() {
                            selectedSeason = newValue!;
                          });
                        },
                        items: SearchSeason.values.map((SearchSeason status) {
                          return DropdownMenuItem<SearchSeason>(
                            value: status,
                            child: Center(
                              child: Text(status.title,
                                  style: TextStyle(
                                      fontSize:
                                          sizeController.middleFontSize.value,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.objectColor)),
                            ),
                          );
                        }).toList()),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchTime>(
                      underline: Container(height: 0),
                      iconEnabledColor: AppColor.objectColor,
                      dropdownColor: AppColor.backgroundColor,
                      hint: Center(
                        child: Text(
                          '시간 선택',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w300,
                              color: AppColor.textColor),
                        ),
                      ),
                      value:
                          selectedTime != SearchTime.time ? selectedTime : null,
                      isExpanded: true,
                      onChanged: (SearchTime? newValue) {
                        setState(() {
                          selectedTime = newValue!;
                        });
                      },
                      items: SearchTime.values.map((SearchTime status) {
                        return DropdownMenuItem<SearchTime>(
                          value: status,
                          child: Center(
                            child: Text(status.title,
                                style: TextStyle(
                                    fontSize:
                                        sizeController.middleFontSize.value,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.objectColor)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchWeather>(
                      underline: Container(height: 0),
                      iconEnabledColor: AppColor.objectColor,
                      dropdownColor: AppColor.backgroundColor,
                      hint: Center(
                        child: Text(
                          '날씨 선택',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w300,
                              color: AppColor.textColor),
                        ),
                      ),
                      value: selectedWeather != SearchWeather.weather
                          ? selectedWeather
                          : null,
                      isExpanded: true,
                      onChanged: (SearchWeather? newValue) {
                        setState(() {
                          selectedWeather = newValue!;
                        });
                      },
                      items: SearchWeather.values.map((SearchWeather status) {
                        return DropdownMenuItem<SearchWeather>(
                          value: status,
                          child: Center(
                            child: Text(status.title,
                                style: TextStyle(
                                    fontSize:
                                        sizeController.middleFontSize.value,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.objectColor)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColor.objectColor,
              thickness: 1, // 줄의 색상 설정
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text("  "),
                      const Icon(
                        Icons.location_pin,
                        color: AppColor.objectColor,
                      ),
                      Text(
                        " $searchLocation",
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        clickButton = true;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              appBar: AppBar(
                                title: Text(
                                  "위치 검색",
                                  style: TextStyle(
                                      fontSize:
                                          sizeController.bigFontSize.value,
                                      fontWeight: FontWeight.w900,
                                      color: AppColor.backgroundColor),
                                ),
                                leading: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      size: 25,
                                      color: AppColor.backgroundColor,
                                    )),
                              ),
                              loadingColor: AppColor.backgroundColor,
                              useLocalServer: true,
                              localPort: 1024,
                              callback: (Kpostal result) {
                                setState(() {
                                  address = result.address;
                                  latitude = result.latitude.toString();
                                  longitude = result.longitude.toString();

                                  searchLocation = address;

                                  lat = double.parse(latitude);
                                  lng = double.parse(longitude);

                                  locationObtained = false;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                        color: AppColor.objectColor,
                      )),
                ],
              ),
            ),
            const Divider(
              color: AppColor.objectColor,
              thickness: 1, // 줄의 색상 설정
            ),
            Expanded(
                child: locationObtained
                    ? FutureBuilder(
                        future: getCurrentLocation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return NaverMap(
                              options: NaverMapViewOptions(
                                scaleBarEnable: false,
                                locationButtonEnable: true,
                                logoClickEnable: false,
                                extent: const NLatLngBounds(
                                  southWest: NLatLng(31.43, 122.37),
                                  northEast: NLatLng(44.35, 132.0),
                                ),
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(lat, lng),
                                  zoom: 15,
                                  bearing: 0,
                                  tilt: 0,
                                ),
                              ),
                              onMapReady: (controller) async {
                                final iconImage = await NOverlayImage.fromWidget(
                                  widget: const Icon(Icons.place,
                                      size: 32, color: AppColor.backgroundColor),
                                  size: const Size(32, 32),
                                  context: context,
                                );

                                for (var data in documentsData) {
                                  final marker = NMarker(
                                    id: data['content'],
                                    position: NLatLng(
                                        data['latitude'], data['longitude']),
                                    icon: iconImage,
                                  );

                                  marker.setOnTapListener((NMarker marker) {
                                    // 클릭 시 BottomSheet를 표시
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled:
                                          true, // 화면 전체에 BottomSheet를 표시
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6, // 높이를 60%로 설정
                                          width: MediaQuery.of(context).size.width * 1.0,
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('마커 정보'),
                                              SizedBox(height: 8.0),
                                              Text('데이터: ${data['content']}'),
                                              // 추가 필드들을 원하는 만큼 추가
                                              Spacer(), // 뒤로 가기 버튼을 하단으로 밀어냄
                                              Positioned(
                                                bottom: 16.0, // 오른쪽 하단으로 배치
                                                right: 16.0,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // 뒤로 가기 버튼 클릭 시 BottomSheet를 닫음
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('뒤로 가기'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  });

                                  controller.addOverlay(marker);
                                }
                              },
                            );
                          } else {
                            // 위치 정보를 아직 가져오지 못한 경우 로딩 표시 또는 다른 대응을 할 수 있습니다.
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    : FutureBuilder(
                        future: getSearchLocation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return NaverMap(
                              options: NaverMapViewOptions(
                                scaleBarEnable: false,
                                locationButtonEnable: true,
                                logoClickEnable: false,
                                extent: const NLatLngBounds(
                                  southWest: NLatLng(31.43, 122.37),
                                  northEast: NLatLng(44.35, 132.0),
                                ),
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(lat, lng),
                                  zoom: 15,
                                  bearing: 0,
                                  tilt: 0,
                                ),
                              ),
                              onMapReady: (controller) {
                                final marker = NMarker(
                                  id: 'test',
                                  position:
                                      const NLatLng(37.506977, 126.953289),
                                );
                                marker.setOnTapListener((NMarker marker) {
                                  // 마커를 클릭했을 때 실행할 코드
                                });
                                controller.addOverlay(marker);
                              },
                            );
                          } else {
                            // 위치 정보를 아직 가져오지 못한 경우 로딩 표시 또는 다른 대응을 할 수 있습니다.
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )),
            Visibility(
              visible: false,
              child: Padding(
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
                                searchLocation,
                                style: TextStyle(
                                    fontSize: sizeController.mainFontSize.value,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
