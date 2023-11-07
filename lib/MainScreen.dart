import 'package:flutter/material.dart';
import 'Tab_1.dart';
import 'Tab_2.dart';
import 'Tab_3.dart';
import 'Tab_4.dart';
import 'Tab_5.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: const TabBarView(
          children: [
            Tab(child: Tab1()),
            Tab(child: Tab_2()),
            Tab(child: Tab_3()),
            Tab(child: Tab_4()),
            Tab(child: Tab_5()),
          ],
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          color: Colors.white, //색상
          child: Container(
            height: 70,
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            child: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.indigoAccent,
              indicatorWeight: 3,
              labelColor: Colors.indigoAccent,
              unselectedLabelColor: Colors.black38,
              labelStyle: TextStyle(
                fontSize: 11,
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                  ),
                  text: 'HOME',
                ),
                Tab(
                  icon: Icon(Icons.map),
                  text: 'AROUND',
                ),
                Tab(
                  icon: Icon(
                    Icons.add_a_photo,
                  ),
                  text: 'ADD',
                ),
                Tab(
                  icon: Icon(
                    Icons.chat,
                  ),
                  text: 'PAGE',
                ),
                Tab(
                  icon: Icon(
                    Icons.account_box,
                  ),
                  text: 'MY',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
