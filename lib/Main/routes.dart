import 'package:get/get.dart';
import 'package:photois/Login/Login.dart';
import 'package:photois/Login/Login_extra1.dart';
import 'package:photois/Login/Login_extra2.dart';
import 'package:photois/Login/Login_extra3.dart';
import 'package:photois/Main/MainScreen.dart';
import 'package:photois/Main/SplashScreen.dart';
import 'package:photois/Tab3_Add/select_address.dart';
import 'package:photois/Tab3_Add/select_time.dart';
import 'package:photois/Tab3_Add/select_category.dart';

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
