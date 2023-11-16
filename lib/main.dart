import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photois/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photois/routes.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        getPages: page);
  }
}
