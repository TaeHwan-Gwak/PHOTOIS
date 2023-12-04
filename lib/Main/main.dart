import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/Main/routes.dart';
import 'package:photois/service.dart';
import 'package:photois/service/firebase.boot.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(clientId: 'ud3er0cxg6');

  initServices();
  await initFirebase();
  await initializeDateFormatting();
  await Firebase.initializeApp();

  'initFirebase complete'.log();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PHOTOIS',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: 'BMHANNAPro'),
      initialRoute: '/',
      getPages: page,
      debugShowCheckedModeBanner: false,
    );
  }
}
