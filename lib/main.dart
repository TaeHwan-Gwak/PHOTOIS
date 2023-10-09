import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photois/firebase_options.dart';

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
      title: 'Start Screen',
      theme: ThemeData(primaryColor: Colors.blue, fontFamily: 'BMHANNAPro'),
      home: MyHomePage(),
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
