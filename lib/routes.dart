import 'package:flutter/material.dart';

import 'package:photois/SplashScreen.dart';
import 'package:photois/Login/Login.dart';
import 'package:photois/Login/Login_extra1.dart';
import 'package:photois/Login/Login_extra2.dart';
import 'package:photois/Login/Login_extra3.dart';
import 'package:photois/MainScreen.dart';
import 'package:photois/Tab_3.dart';
import 'package:photois/Tab_3_2.dart';
import 'package:photois/Tab_3_3.dart';

final routes = {
  '/': (BuildContext context) => const SplashScreen(),
  '/login': (BuildContext context) => const LoginPage(),
  '/login+1': (BuildContext context) => const LoginExtra1(),
  '/login+2': (BuildContext context) => const LoginExtra2(),
  '/login+3': (BuildContext context) => const LoginExtra3(),
  '/main': (BuildContext context) => const MainPage(),
  '/tab3': (BuildContext context) => const Tab3(),
  '/category': (BuildContext context) => const SelectCategory(),
};
