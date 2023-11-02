import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photois/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static final NetworkHelper _instance = NetworkHelper._internal();

  factory NetworkHelper() => _instance;

  NetworkHelper._internal();

  Future getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
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

Future<bool> _determinePermission() async {
  bool serviceEnable = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnable) {
    return Future.value(false);
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      return Future.value(false);
    }
  }
  if(permission == LocationPermission.deniedForever) {
    return Future.value(false);
  }
  return Future.value(true);
}

class OpenWeatherService {
  final String _apiKey = dotenv.env['openWeatherApiKey']!;
  final String _baseUrl = dotenv.env['openWeatherApiBaseUrl']!;

  Future<Position> _getPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    return position;
  }

  Future getWeather() async {
    Position myLocation = await _getPosition();
    // developer.log("myLocation called in network");
    /*
    try {
      await myLocation.getMyCurrentLocation();
    } catch (e) {
      // developer.log("error : getLocation ${e.toString()}");
    }
     */

    final weatherData = NetworkHelper().getData(
        '$_baseUrl?lat=${myLocation.latitude}&lon=${myLocation.longitude}&appid=$_apiKey&units=metric');
    return weatherData;
  }
}

enum LoadingStatus { completed, searching, empty }

class WeatherProvider with ChangeNotifier {
  final Weather _weather =
  Weather(temp: 20, condition: "Clouds", conditionId: 200, humidity: 50);

  Weather get weather => _weather;

  LoadingStatus _loadingStatus = LoadingStatus.empty;

  LoadingStatus get loadingStatus => _loadingStatus;

  String _message = "Loading...";

  String get message => _message;

  final OpenWeatherService _openWeatherService = OpenWeatherService();

  Future<void> getWeather() async {
    _loadingStatus = LoadingStatus.searching;

    final weatherData = await _openWeatherService.getWeather();
    if (weatherData == null) {
      _loadingStatus = LoadingStatus.empty;
      _message = 'Could not find weather. Please try again.';
    } else {
      _loadingStatus = LoadingStatus.completed;
      weather.condition = weatherData['weather'][0]['main'];
      weather.conditionId = weatherData['weather'][0]['id'];
      weather.humidity = weatherData['main']['humidity'];
      weather.temp = weatherData['main']['temp'];
      weather.temp = (weather.temp! * 10).roundToDouble() / 10;
    }

    notifyListeners();
  }
}

