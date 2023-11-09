import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';


class Tab_2 extends StatelessWidget {
  const Tab_2({super.key});

  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: KakaoMap(),
    );
    return const Placeholder();
  }
}