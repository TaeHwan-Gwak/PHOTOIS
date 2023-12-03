import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kpostal/kpostal.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String address = '-';
  String latitude = '-';
  String longitude = '-';

  String condition = '-';

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

      http.Response response = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=2ed1135aa0f58dafe0d2ead1574e0242"),
      );

      String jsonData = response.body;

      condition = jsonDecode(jsonData)['weather'][0]['main'];

      print(condition);

      /* 네이버 지오코딩
      String query = "";

      http.Response response = await http.get(
        Uri.parse(
          "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=${query}",
        ),
        headers: headerss,
      );

      String jsonData = response.body;

      // print(jsonData);

      var long = jsonDecode(jsonData)['addresses'][0]['x'];
      var lati = jsonDecode(jsonData)['addresses'][0]['y'];

      print(long);
      print(lati);
       */
    } catch (e) {
      print('error');
    }
  }

  Future<void> getSearchLocation() async {
    lat = this.lat;
    lng = this.lng;
  }

  @override
  void initState() {
    super.initState();
    getPostInfoCount();
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

  final TextEditingController _searchController = TextEditingController();
  SearchSeason selectedSeason = SearchSeason.season;
  SearchTime selectedTime = SearchTime.time;
  SearchWeather selectedWeather = SearchWeather.weather;
  String searchLocation = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeController = Get.put((SizeController()));
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: sizeController.screenHeight * 0.08,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '검색 버튼을 눌러 사진 스팟 장소를 찾으세요',
                          prefixIcon: IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => KpostalView(
                                      useLocalServer: true,
                                      localPort: 1024,
                                      callback: (Kpostal result) {
                                        setState(() {
                                          this.address = result.address;
                                          this.latitude =
                                              result.latitude.toString();
                                          this.longitude =
                                              result.longitude.toString();

                                          // Update the TextField with the received address
                                          _searchController.text = this.address;

                                          lat = double.parse(this.latitude);
                                          lng = double.parse(this.longitude);

                                          print(this.address);
                                          print(this.latitude);
                                          print(this.longitude);

                                          locationObtained = false;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search)),
                        ),
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value + 2.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            searchLocation = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchSeason>(
                        underline: Container(
                          height: 2,
                          color: Colors.blueGrey,
                        ),
                        hint: Text(
                          '   계절 선택',
                          style: TextStyle(
                              fontSize: sizeController.mainFontSize.value,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                            child: Text(status.title),
                          );
                        }).toList()),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchTime>(
                      underline: Container(
                        height: 2,
                        color: Colors.indigo,
                      ),
                      hint: Text(
                        '   시간 선택',
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                          child: Text(status.title),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<SearchWeather>(
                      underline: Container(
                        height: 2,
                        color: Colors.indigoAccent,
                      ),
                      hint: Text(
                        '   날씨 선택',
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                          child: Text(status.title),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
                                onMapReady: (controller) {
                                  for (var data in documentsData) {
                                    print(documentsData.length);

                                    final marker = NMarker(
                                      id: data['createdAt'],
                                      position: NLatLng(
                                          data['latitude'], data['longitude']),
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
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('마커 정보'),
                                                SizedBox(height: 8.0),
                                                Text(
                                                    '데이터: ${data['createdAt']}'),
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
            ],
          ),
        ),
      ),
    );
  }
}
