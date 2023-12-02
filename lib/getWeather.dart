import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetWeather {
  Future<String> getWeatherCondition(
      double lat, double lng, DateTime date) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    try {
      DateTime originalDateTime = date;

      // UTC+9
      DateTime subtractedDateTime =
          originalDateTime.subtract(const Duration(hours: 9));

      int startTime = subtractedDateTime.millisecondsSinceEpoch ~/ 1000;
      int endTime = startTime + 3600;

      http.Response response = await http.get(
        Uri.parse(
            "https://history.openweathermap.org/data/2.5/history/city?lat=$lat&lon=$lng&type=hour&start=$startTime&end=$endTime&appid=2ed1135aa0f58dafe0d2ead1574e0242"),
      );
      String jsonData = response.body;

      String condition = jsonDecode(jsonData)['list'][0]['weather'][0]['main'];

      print(condition);
      return condition;
    } catch (e) {
      print('Error: $e');
      return '-';
    }
  }
}
/*
void main() async {
  WeatherService weatherService = WeatherService();
  double latitude = 37.7749;
  double longitude = -122.4194;
  DateTime date = DateTime.now();

  String condition = await weatherService.getWeatherCondition(latitude, longitude, date);
  print('Weather condition: $condition');
}*/
