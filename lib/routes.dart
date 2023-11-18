import 'package:get/get.dart';
import 'package:photois/Login/Login.dart';
import 'package:photois/Login/Login_extra1.dart';
import 'package:photois/Login/Login_extra2.dart';
import 'package:photois/Login/Login_extra3.dart';
import 'package:photois/MainScreen.dart';
import 'package:photois/SplashScreen.dart';
import 'package:photois/Tab_3_1.dart';
import 'package:photois/Tab_3_2.dart';
import 'package:photois/Tab_3_3.dart';

final page = [
  GetPage(name: '/', page: () => const SplashScreen()),
  GetPage(name: '/login', page: () => const LoginPage()),
  GetPage(name: '/login1', page: () => const LoginExtra1()),
  GetPage(name: '/login2', page: () => const LoginExtra2()),
  GetPage(name: '/login3', page: () => const LoginExtra3()),
  GetPage(name: '/main', page: () => const MainPage()),
  GetPage(name: '/spotAddress', page: () => const SelectAddress()),
  GetPage(name: '/spotTime', page: () => const SelectTime()),
  GetPage(name: '/spotCategory', page: () => const SelectCategory()),
];
