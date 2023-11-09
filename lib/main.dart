import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photois/firebase_options.dart';
import 'SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHOTOIS',
      theme:
          ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'BMHANNAPro'),
      home: const splashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/PHOTOIS_LOGO.png'),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
