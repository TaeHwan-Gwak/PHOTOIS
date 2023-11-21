import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// naver client ID : 'ud3er0cxg6'

enum SearchSeason { spring, summer, autumn, winter }

enum SearchTime { day, night }

enum SearchWeather { sun, cloudSun, cloud, rainy, snow }

class Tab2 extends StatefulWidget {
  const Tab2({super.key});

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
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
        Uri
            .parse(
            "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&output=json"),
        headers: headerss);

    String jsonData = response.body;

    // print(jsonData);
    var myJson_dong =
    jsonDecode(jsonData)["results"][1]['region']['area3']['name'];
    var myJson_gu =
    jsonDecode(jsonData)["results"][1]['region']['area2']['name'];
    var myJson_si =
    jsonDecode(jsonData)["results"][1]['region']['area1']['name'];


    List<String> which = [myJson_si, myJson_gu, myJson_dong];

    print(which);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  SearchSeason selectedSeason = SearchSeason.spring;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        const SizedBox(height: 30),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: '검색',
            hintText: '찾고싶은 사진 스팟 장소를 입력해주세요',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: (value) {
            // 검색어 변경 시 동작
            print('검색어: $value');
          },
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
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
          ],
        )
      ]),
    );
     */
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
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
                    position: NLatLng(37.506977, 126.953289),
                  );
                  marker.setOnTapListener((NMarker marker) {
                    // 마커를 클릭했을 때 실행할 코드
                  });
                  controller.addOverlay(marker);
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
    );
  }
}