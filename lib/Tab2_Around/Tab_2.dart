import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kpostal/kpostal.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

// naver client ID : 'ud3er0cxg6'

enum SearchSeason { season, spring, summer, autumn, winter }

enum SearchTime { time, day, night }

enum SearchWeather { weather, sun, clouds, rain, snow }

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

    print(lat);
    print(lng);
  }

  @override
  void initState() {
    super.initState();
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
                        decoration: const InputDecoration(
                          hintText: '찾고싶은 사진 스팟 장소를 입력해주세요',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchLocation = value;
                          });
                        },
                      ),
                    ),
                    TextButton(
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
                                  this.latitude = result.latitude.toString();
                                  this.longitude = result.longitude.toString();

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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: sizeController.screenWidth * 0.02,
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
                            child:
                                Text("   ${status.toString().split('.').last}"),
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
                          child:
                              Text("   ${status.toString().split('.').last}"),
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
                          child:
                              Text("   ${status.toString().split('.').last}"),
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
