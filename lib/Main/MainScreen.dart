import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/service/account.dart';
import 'package:photois/setting.dart';
import 'package:photois/Main/data.dart';

import '../Tab1_Home/Tab_1.dart';
import '../Tab2_Around/Tab_2.dart';
import '../Tab3_Add/add_post.dart';
import 'package:photois/Tab4_MY/mypage/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      late String uid;
      if (kDebugMode && kDevUseTempUser) {
        uid = 'test';
      } else {
        //TODO: pass uid from login
        uid = Get.parameters['uid']!;
      }

      // 'MainPage initState: $uid'.log();
      if (await Get.find<Account>().tryLogin(uid) != true) {
        Get.offNamed('/login');
      }
      // 'MainPage initState: ${Get.find<Account>().uid}'.log();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        Get.to(const Tab3());
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      // body: pages[_selectedIndex],
      body: buildContentPage(),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: sizeController.bigFontSize.value,
        unselectedItemColor: Colors.black,
        unselectedFontSize: sizeController.middleFontSize.value,
        selectedItemColor: Colors.lightBlue,
        selectedFontSize: sizeController.middleFontSize.value,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'AROUND'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'ADD'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: 'MY'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildContentPage() {
    switch (_selectedIndex) {
      case 0:
        return const Tab1();
      case 1:
        return const SearchSpot();
      case 3:
        return const MyPage();
      default:
        return const Tab1();
    }
  }
}
