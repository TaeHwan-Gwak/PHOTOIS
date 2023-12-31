import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as m;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../Main/data.dart' as my_data;
import 'package:photois/style/style.dart';

import '../post/post_card.dart';
import '../Tab3_Add/add_post.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';

class RecommendSpot extends StatefulWidget {
  const RecommendSpot({super.key});

  @override
  State<RecommendSpot> createState() => _RecommendSpotState();
}

class _RecommendSpotState extends State<RecommendSpot> {
  final sizeController = Get.put((my_data.SizeController()));
  final controller = Get.put(my_data.UserInfo());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  double lat = 0.0;
  double lng = 0.0;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lng = position.longitude;
    } catch (e) {
      print('error');
    }
  }

  final m.FirebaseAuth auth = m.FirebaseAuth.instance;
  String uid = '';
  String category = '';

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((_) {
      setState(() {});
    });
    uid = auth.currentUser!.uid;
    loadData().then((_) {
      setState(() {});
    });
    print(category);
  }
/*
  Future<void> loadData() async {
    var result = await firestore.collection('userInfo').doc(uid).get();
    category = result.data()!['categoryName'];
    print(category);
  }*/

  int _getTypeByCategory(String categoryName) {
    switch (categoryName) {
      case '나홀로 인생샷':
        return 1;
      case '애인과 커플샷':
        return 2;
      case '친구와 우정샷':
        return 3;
      case '가족과 추억샷':
        return 4;
      default:
        return 0;
    }
  }

  String _getUserType(String userTypeValue) {
    switch (userTypeValue) {
      case '나홀로 인생샷':
        return 'solo';
      case '애인과 커플샷':
        return 'couple';
      case '친구와 우정샷':
        return 'friend';
      case '가족과 추억샷':
        return 'family';
      default:
        return 'solo';
    }
  }

  Future<void> loadData() async {
    var result = await firestore.collection('userInfo').doc(uid).get();

    controller.nickname.value = result.data()!['nickname'];
    controller.instagramID.value = result.data()!['phoneNumber'];
    controller.checkCategory.value =
        _getTypeByCategory(result.data()!['categoryName']);
    controller.checkPhotographer.value = result.data()!['photoGrapher'];
    category = _getUserType(result.data()!['categoryName']);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          "PHOTOIS",
          style: TextStyle(
              fontSize: sizeController.bigFontSize.value,
              fontWeight: FontWeight.w900,
              color: AppColor.objectColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const Tab3());
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: AppColor.objectColor,
              ))
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 16, top: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColor.objectColor,
                      ),
                      Text(
                        " 주변 인기장소 추천",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: sizeController.screenHeight.value * 0.3 * 1.25,
                    child: FutureBuilder<List<PostModel>>(
                      future:
                          FireService().getFireModelMain1(lat: lat, lng: lng),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            List<PostModel> datas = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: datas.length,
                              itemBuilder: (BuildContext context, int index) {
                                PostModel data = datas[index];
                                return Row(
                                  children: [
                                    const SizedBox(width: 7),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: PostCard(
                                          data: data,
                                          size: sizeController
                                                  .screenHeight.value *
                                              0.3),
                                    ),
                                    const SizedBox(width: 7)
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const Text("No data");
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
                SizedBox(
                  height: sizeController.screenHeight.value * 0.02,
                ),
                const Divider(color: AppColor.objectColor, thickness: 1.5),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 16, top: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColor.objectColor,
                      ),
                      Text(
                        " 선호 카테고리 기반 추천",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                ),
                //TODO: user 선호 카테고리로 바꿔주기
                SizedBox(
                    height: sizeController.screenHeight.value * 0.3 * 1.25,
                    child: FutureBuilder<List<PostModel>>(
                      future: FireService().getFireModelMain2(
                          category: PostCategory.fromString(category)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            List<PostModel> datas = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: datas.length,
                              itemBuilder: (BuildContext context, int index) {
                                PostModel data = datas[index];
                                return Row(
                                  children: [
                                    const SizedBox(width: 7),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: PostCard(
                                          data: data,
                                          size: sizeController
                                                  .screenHeight.value *
                                              0.3),
                                    ),
                                    const SizedBox(width: 7)
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const Text("No data");
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
                SizedBox(
                  height: sizeController.screenHeight.value * 0.02,
                ),
                const Divider(color: AppColor.objectColor, thickness: 1.5),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 16, top: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColor.objectColor,
                      ),
                      Text(
                        " 전체 랭킹",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: sizeController.screenHeight.value * 0.3 * 1.25,
                    child: FutureBuilder<List<PostModel>>(
                      future: FireService().getFireModelMain3(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            List<PostModel> datas = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: datas.length,
                              itemBuilder: (BuildContext context, int index) {
                                PostModel data = datas[index];
                                return Row(
                                  children: [
                                    const SizedBox(width: 7),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: PostCard(
                                          data: data,
                                          size: sizeController
                                                  .screenHeight.value *
                                              0.3),
                                    ),
                                    const SizedBox(width: 7)
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const Text("No data");
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
                SizedBox(
                  height: sizeController.screenHeight.value * 0.02,
                ),
                const Divider(color: AppColor.objectColor, thickness: 1.5),
              ],
            ),
          ),
        );
      }),
    );
  }
}
