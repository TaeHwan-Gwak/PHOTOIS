import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:kpostal/kpostal.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:photois/post/post_card.dart';

import '../model/post_model.dart';
import '../service/post_api_service.dart';
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
        SearchTime.time: '시간대 선택',
        SearchTime.day: '주간',
        SearchTime.night: '야간',
      }[this]!;
}

enum SearchWeather {
  weather,
  sun,
  cloud,
  rain,
  snow;

  String get title => const <SearchWeather, String>{
        SearchWeather.weather: '날씨 선택',
        SearchWeather.sun: '맑음',
        SearchWeather.cloud: '구름',
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
  double lat = 0;
  double lng = 0;
  bool locationObtained = true;
  bool clickButton = false;

  String address = '';
  String latitude = '';
  String longitude = '';
  String condition = '';

  final TextEditingController _searchController = TextEditingController();
  final sizeController = Get.put((SizeController()));
  SearchSeason selectedSeason = SearchSeason.season;
  SearchTime selectedTime = SearchTime.time;
  SearchWeather selectedWeather = SearchWeather.weather;
  SearchSeason nowSeason = SearchSeason.season;
  SearchTime nowTime = SearchTime.time;
  SearchWeather nowWeather = SearchWeather.weather;
  String searchLocation = '위치를 검색해주세요';

  Future<void> getCurrentLocation() async {
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
    } catch (e) {
      print('error');
    }
  }

  Future<void> getSearchLocation() async {
    lat = lat;
    lng = lng;
  }

  Future<void> getCurrentState() async {
    //계절 가져오기
    switch (DateFormat.M().format(DateTime.now())) {
      case '12':
      case '1':
      case '2':
        nowSeason = SearchSeason.winter;
        break;
      case '3':
      case '4':
      case '5':
        nowSeason = SearchSeason.spring;
        break;
      case '6':
      case '7':
      case '8':
        nowSeason = SearchSeason.summer;
        break;
      case '9':
      case '10':
      case '11':
        nowSeason = SearchSeason.autumn;
        break;
      default:
        nowSeason = SearchSeason.season;
        break;
    }

    //시간대 가져오기
    if (6 <= int.parse(DateFormat.H().format(DateTime.now())) &&
        int.parse(DateFormat.H().format(DateTime.now())) < 19) {
      nowTime = SearchTime.day;
    } else {
      nowTime = SearchTime.night;
    }

    /*
    //날씨 가져오기
    GetWeather weatherService = GetWeather();
    String condition =
        await weatherService.getWeatherCondition(lat, lng, DateTime.now());


    print(condition);*/

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

      http.Response responseWeather = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=2ed1135aa0f58dafe0d2ead1574e0242"),
      );

      String jsonDataWeather = responseWeather.body;
      condition = jsonDecode(jsonDataWeather)['weather'][0]['main'];

      print(condition);
    } catch (e) {
      print('error');
    }

    switch (condition) {
      case 'Clear':
        nowWeather = SearchWeather.sun;
        break;
      case 'Clouds':
        nowWeather = SearchWeather.cloud;
        break;
      case 'Rain':
        nowWeather = SearchWeather.rain;
        break;
      case 'Snow':
        nowWeather = SearchWeather.snow;
        break;
      default:
        nowWeather = SearchWeather.weather;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPost().then((_) {
      setState(() {});
    });
    /*
    getCurrentLocation().then((_) {
      setState(() {});
    });
    */
    getCurrentState().then((_) {});
  }

  List<PostModel> allPosts = [];
  List<PostModel> weatherFilterPosts = [];
  List<PostModel> finalFilterPosts = [];

  Future<void> getAllPost() async {
    try {
      allPosts = await FireService().getFireModelAll();
    } catch (e) {
      print('Error getting post info count: $e');
    }
  }

  Future<List<PostModel>> getFilteringPost() async {
    List<PostModel> FilterPosts1 = allPosts;
    List<PostModel> FilterPosts2 = allPosts;
    List<PostModel> FilterPosts3 = allPosts;
    try {
      if (selectedWeather != SearchWeather.weather) {
        weatherFilterPosts = await FireService().getFireModelWeather(
            weather: PostWeather.fromString(selectedWeather.name));
        FilterPosts1 = allPosts
            .where((post) => weatherFilterPosts
                .any((otherPost) => post.reference == otherPost.reference))
            .toList();
      }
      if (selectedSeason != SearchSeason.season) {
        FilterPosts2 = allPosts
            .where((post) => checkSeason(post.date!.toDate()) == selectedSeason)
            .toList();
      }
      if (selectedTime != SearchTime.time) {
        FilterPosts3 = allPosts
            .where((post) => checkTime(post.date!.toDate()) == selectedTime)
            .toList();
      }
      finalFilterPosts = FilterPosts1.where((post) => FilterPosts2.any(
          (otherPost) => post.reference == otherPost.reference)).toList();
      finalFilterPosts = finalFilterPosts
          .where((post) => FilterPosts3.any(
              (otherPost) => post.reference == otherPost.reference))
          .toList();
      return finalFilterPosts;
    } catch (e) {
      print('Error getting post info count: $e');
      return allPosts;
    }
  }

  SearchSeason checkSeason(DateTime date) {
    SearchSeason temp = SearchSeason.season;
    switch (DateFormat.M().format(date)) {
      case '12':
      case '1':
      case '2':
        temp = SearchSeason.winter;
        break;
      case '3':
      case '4':
      case '5':
        temp = SearchSeason.spring;
        break;
      case '6':
      case '7':
      case '8':
        temp = SearchSeason.summer;
        break;
      case '9':
      case '10':
      case '11':
        temp = SearchSeason.autumn;
        break;
      default:
        temp = SearchSeason.season;
        break;
    }
    return temp;
  }

  SearchTime checkTime(DateTime date) {
    if (6 <= int.parse(DateFormat.H().format(date)) &&
        int.parse(DateFormat.H().format(DateTime.now())) < 19) {
      return SearchTime.day;
    } else {
      return SearchTime.night;
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
              height: sizeController.screenHeight.value * 0.05,
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
                                      fontWeight: (status.title ==
                                                  nowSeason.title &&
                                              nowSeason != SearchSeason.season)
                                          ? FontWeight.w900
                                          : FontWeight.w300,
                                      color: (status.title == nowSeason.title &&
                                              nowSeason != SearchSeason.season)
                                          ? AppColor.textColor
                                          : AppColor.objectColor)),
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
                          '시간대 선택',
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
                                    fontWeight: (status.title == nowTime.title)
                                        ? FontWeight.w900
                                        : FontWeight.w300,
                                    color: (status.title == nowTime.title)
                                        ? AppColor.textColor
                                        : AppColor.objectColor)),
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
                                    fontWeight: (status.title ==
                                                nowWeather.title &&
                                            nowWeather != SearchWeather.weather)
                                        ? FontWeight.w900
                                        : FontWeight.w300,
                                    color: (status.title == nowWeather.title &&
                                            nowWeather != SearchWeather.weather)
                                        ? AppColor.textColor
                                        : AppColor.objectColor)),
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
              height: sizeController.screenHeight.value * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: AppColor.objectColor,
                        ),
                        Text(
                          " $searchLocation",
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor),
                        ),
                      ],
                    ),
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
                              onMapReady: (controller) async {
                                finalFilterPosts = await getFilteringPost();
                                print(finalFilterPosts.length);

                                for (PostModel data in finalFilterPosts) {
                                  print(data.userUid);

                                  final marker = NMarker(
                                      id: data.imageURL ?? '',
                                      position: NLatLng(data.latitude ?? 0.0,
                                          data.longitude ?? 0.0),
                                      icon: await NOverlayImage.fromWidget(
                                        widget: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: SizedBox(
                                                height: 48,
                                                width: 48,
                                                child: Image.network(
                                                  data.imageURL ??
                                                      'No imageURL',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        size: const Size(80, 80),
                                        context: context,
                                      ));

                                  marker.setOnTapListener((NMarker marker) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: sizeController
                                                  .screenHeight.value *
                                              0.6,
                                          width:
                                              sizeController.screenWidth.value,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: const BoxDecoration(
                                            color: AppColor
                                                .backgroundColor, // 배경 색상
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              height: sizeController
                                                      .screenHeight.value *
                                                  0.5 *
                                                  1.25,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0), // 원하는 모서리 반지름 설정
                                                child: PostCard(
                                                  data: data,
                                                  size: sizeController
                                                          .screenHeight.value *
                                                      0.5,
                                                ),
                                              ),
                                            ),
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
                              onMapReady: (controller) async {
                                List<PostModel> finalFilterPost =
                                    await getFilteringPost();
                                print(finalFilterPosts.length);

                                for (PostModel data in finalFilterPost) {
                                  print(data.userUid);
                                  final marker = NMarker(
                                      id: data.content ?? '',
                                      position: NLatLng(data.latitude ?? 0.0,
                                          data.longitude ?? 0.0),
                                      icon: await NOverlayImage.fromWidget(
                                        widget: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: SizedBox(
                                                height: 48,
                                                width: 48,
                                                child: Image.network(
                                                  data.imageURL ??
                                                      'No imageURL',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.place,
                                                size: 24,
                                                color:
                                                    AppColor.backgroundColor),
                                          ],
                                        ),
                                        size: const Size(80, 80),
                                        context: context,
                                      ));

                                  marker.setOnTapListener((NMarker marker) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: sizeController
                                                  .screenHeight.value *
                                              0.6,
                                          width:
                                              sizeController.screenWidth.value,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: const BoxDecoration(
                                            color: AppColor
                                                .backgroundColor, // 배경 색상
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              height: sizeController
                                                      .screenHeight.value *
                                                  0.5 *
                                                  1.25,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0), // 원하는 모서리 반지름 설정
                                                child: PostCard(
                                                  data: data,
                                                  size: sizeController
                                                          .screenHeight.value *
                                                      0.5,
                                                ),
                                              ),
                                            ),
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
                      )),
            SizedBox(
              height: sizeController.screenHeight.value * 0.002,
            ),
            const Divider(
              color: AppColor.objectColor,
              thickness: 1, // 줄의 색상 설정
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.002,
            ),
          ],
        ),
      ),
    );
  }
}
