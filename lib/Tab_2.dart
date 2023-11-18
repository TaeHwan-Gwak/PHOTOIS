import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  State<Tab2> createState() => _MyAppState();
}

class _MyAppState extends State<Tab2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller) {
            final marker = NMarker(
                id: 'test',
                position:
                const NLatLng(37.506977, 126.953289));

            controller.addOverlay(marker);
          },
        ),
      ),
    );
  }
}