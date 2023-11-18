import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photois/data.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  int selectedIconNum = 0;
  List<String> selectPic = [
    "assets/images/google_login.png",
    "assets/images/google_login.png",
    "assets/images/google_login.png",
    "assets/images/google_login.png",
  ];

  List<String> weather = ["맑음", "흐림", "구름", "비", "눈"];

  List<String> category = [
    "나홀로 인생샷",
    "애인과 커플샷",
    "친구와 우정샷",
    "가족과 추억샷",
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "등록",
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  const Text(
                    "원본과 보정본을 업로드해주세요\n포스팅은 보정본으로 진행됩니다.",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.asset(
                              selectPic[selectedIconNum],
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          )),
                      InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: const Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.asset(
                              selectPic[selectedIconNum],
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("원본"), Text("보정본")],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("위치"),
                subtitle: const Text("사진 해당 주소"),
                onTap: () {
                  Get.toNamed('/spotAddress');
                },
                trailing: const Icon(Icons.navigate_next),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("시간과 날씨"),
                subtitle: Obx(() {
                  if (controller.spotDate.value == DateTime(0, 0, 0)) {
                    return const Text("사진 해당 시간과 날씨");
                  } else {
                    return Obx(() => Text(
                        '${DateFormat('yy.MM.dd').format(controller.spotDate.value)}  ${controller.spotTime.value + controller.getStartHour()}~${controller.spotTime.value + controller.getStartHour() + 1}시 (${weather[controller.spotWeather.value - 1]})',
                        style: const TextStyle(color: Colors.redAccent)));
                  }
                }),
                onTap: () {
                  Get.toNamed('/spotTime');
                },
                trailing: const Icon(Icons.navigate_next),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("카테고리"),
                subtitle: Obx(() {
                  if (controller.spotCategory.value == 0) {
                    return const Text("사진 해당 카테고리");
                  } else {
                    return Text(category[controller.spotCategory.value - 1],
                        style: const TextStyle(color: Colors.redAccent));
                  }
                }),
                onTap: () {
                  Get.toNamed('/spotCategory');
                },
                trailing: const Icon(Icons.navigate_next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
