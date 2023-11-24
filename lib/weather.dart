/*
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kpostal/kpostal.dart';

// naver client ID : 'ud3er0cxg6'

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(

          ),
        ),
      ),
    );
  }
}


class NetworkHelper {
  static final NetworkHelper _instance = NetworkHelper._internal();

  factory NetworkHelper() => _instance;

  NetworkHelper._internal();

  Future getData() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/3.0/onecall?lat=${lat}.44&lon=${lng}&appid={API key}
      ),
    );

    String jsonData = response.body;

    // print(jsonData);

    if (response.statusCode == 200) {
      print(response.body);
      return (response.body);
    } else {
      print(response.statusCode);
    }
  }
}

class Weather {
  double? temp;
  double? tempMax;
  double? tempMin;
  String? condition;
  int? conditionId;
  int? humidity;

  Weather({this.temp, this.tempMax, this.tempMin, this.condition, this.conditionId, this.humidity});
}

class OpenWeatherService {
  double lat = 37;
  double lng = 126;

  final String _apiKey = dotenv.env['openWeatherApiKey']!;
  final String _baseUrl = dotenv.env['openWeatherApiBaseUrl']!;

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

    final weatherData = NetworkHelper().getData(
        '$_baseUrl?lat=${lat}&lon=${lng}&appid=$_apiKey&units=metric');
    return weatherData;
  }
}
 */
