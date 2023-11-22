import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// naver client ID : 'ud3er0cxg6'

enum SearchSeason { season, spring, summer, autumn, winter }

enum SearchTime { time, day, night }

enum SearchWeather { weather, sun, cloudSun, cloud, rainy, snow }

class SearchSpot extends StatefulWidget {
  const SearchSpot({super.key});

  @override
  State<SearchSpot> createState() => _SearchSpotState();
}

class _SearchSpotState extends State<SearchSpot> {
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

    String query = "";

    http.Response response = await http.get(
        Uri.parse(
            "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=${query}"),
        headers: headerss);

    String jsonData = response.body;

    // print(jsonData);

    var long = jsonDecode(jsonData)['addresses'][0]['x'];
    var lati = jsonDecode(jsonData)['addresses'][0]['y'];

    print(long);
    print(lati);
  }

  @override
  void initState() {
    getCurrentLocation();
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
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: '검색',
                  hintText: '찾고싶은 사진 스팟 장소를 입력해주세요',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  searchLocation = value!;
                  print('검색어: $value');
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SearchSeason>(
                          value: selectedSeason,
                          onChanged: (SearchSeason? newValue) {
                            setState(() {
                              selectedSeason = newValue!;
                            });
                          },
                          items: SearchSeason.values.map((SearchSeason status) {
                            return DropdownMenuItem<SearchSeason>(
                              value: status,
                              child: Text(status.toString().split('.').last),
                            );
                          }).toList(),
                          icon: null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SearchTime>(
                          value: selectedTime,
                          onChanged: (SearchTime? newValue) {
                            setState(() {
                              selectedTime = newValue!;
                            });
                          },
                          items: SearchTime.values.map((SearchTime status) {
                            return DropdownMenuItem<SearchTime>(
                              value: status,
                              child: Text(status.toString().split('.').last),
                            );
                          }).toList(),
                          icon: null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SearchWeather>(
                          value: selectedWeather,
                          onChanged: (SearchWeather? newValue) {
                            setState(() {
                              selectedWeather = newValue!;
                            });
                          },
                          items:
                          SearchWeather.values.map((SearchWeather status) {
                            return DropdownMenuItem<SearchWeather>(
                              value: status,
                              child: Text(status.toString().split('.').last),
                            );
                          }).toList(),
                          icon: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: getCurrentLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return NaverMap(
                        options: NaverMapViewOptions(
                          scaleBarEnable: true,
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
                            position: const NLatLng(37.506977, 126.953289),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
