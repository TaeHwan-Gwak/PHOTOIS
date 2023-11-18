import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/routes.dart';
import 'package:photois/service/firebase.boot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();
  await initializeDateFormatting();

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
