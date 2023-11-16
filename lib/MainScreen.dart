import 'package:flutter/material.dart';
import 'Tab_1.dart';
import 'Tab_2.dart';
import 'Tab_3.dart';
import 'Tab_4.dart';
import 'Tab_5.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    const Tab1(),
    const Tab2(),
    const Tab3(),
    const Tab4(),
    const Tab5()
  ];

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
    return Scaffold(
      body: pages[_selectedIndex],
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 18.0,
        unselectedItemColor: Colors.black,
        unselectedFontSize: 10.0,
        selectedItemColor: Colors.lightBlue,
        selectedFontSize: 12.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'AROUND'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'ADD'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'PAGE'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: 'MY'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
