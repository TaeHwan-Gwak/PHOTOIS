import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

/*
class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  State<Tab2> createState() => _MyAppState();
}

class _MyAppState extends State<Tab2> {
  double lat = 37;
  double lng = 126;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: NaverMapViewOptions(
            extent: const NLatLngBounds(
              southWest: NLatLng(31.43, 122.37),
              northEast: NLatLng(44.35, 132.0),
            ),
            initialCameraPosition: NCameraPosition(
              target: NLatLng(lat, lng),
              zoom: 10,
              bearing: 0,
              tilt: 0,
            ),
          ),
          onMapReady: (controller) {
            final marker = NMarker(
              id: 'test',
              position: const NLatLng(37.506977, 126.953289), // const 제거
            );

            controller.addOverlay(marker);
          },
        ),
      ),
    );
  }
}

 */
