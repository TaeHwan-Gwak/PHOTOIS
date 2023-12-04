import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
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
  final sizeController = Get.put((SizeController()));

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
                  padding: const EdgeInsets.all(8.0),
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
                    height: sizeController.screenHeight.value * 0.35 * 1.25,
                    child: FutureBuilder<List<PostModel>>(
                      future: FireService().getFireModels(),
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
                                    const SizedBox(width: 5),
                                    PostCard(
                                        data: data,
                                        size:
                                            sizeController.screenHeight.value *
                                                0.35),
                                    const SizedBox(width: 5)
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
                  padding: const EdgeInsets.all(8.0),
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
                SizedBox(
                    height: sizeController.screenHeight.value * 0.35 * 1.25,
                    child: FutureBuilder<List<PostModel>>(
                      future: FireService().getFireModels(),
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
                                    const SizedBox(width: 5),
                                    PostCard(
                                        data: data,
                                        size:
                                            sizeController.screenHeight.value *
                                                0.35),
                                    const SizedBox(width: 5)
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
