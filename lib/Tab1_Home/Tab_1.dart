import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

import '../Tab3_Add/add_post.dart';
import '../model/post_model.dart';
import '../service/post_api_service.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  final sizeController = Get.put((SizeController()));

  @override
  Widget build(BuildContext context) {
    const String imageLogoName = 'assets/images/PHOTOIS_LOGO.png';
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          imageLogoName,
          width: sizeController.screenWidth.value * 0.3,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const Tab3());
              },
              icon: const Icon(Icons.add_a_photo))
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Divider(
            height: 2,
            color: Colors.black,
            thickness: 2, // 줄의 색상 설정
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeController.screenHeight.value * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " 주변 인기사진 스팟",
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
              ),
              SizedBox(
                  height: sizeController.screenHeight.value * 0.3,
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
                              return postCard(data);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text("No data");
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
              SizedBox(
                height: sizeController.screenHeight.value * 0.02,
              ),
              const Divider(),
              SizedBox(
                height: sizeController.screenHeight.value * 0.02,
              ),
              Text(
                " 선호 카테고리 사진 스팟",
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
              ),
              SizedBox(
                  height: sizeController.screenHeight.value * 0.3,
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
                              return postCard(data);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text("No data");
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
              SizedBox(
                height: sizeController.screenHeight.value * 0.02,
              ),
              const Divider(),
              SizedBox(
                height: sizeController.screenHeight.value * 0.02,
              ),
              Text(
                " 전체 인기사진 스팟",
                style: TextStyle(fontSize: sizeController.mainFontSize.value),
              ),
              SizedBox(
                  height: sizeController.screenHeight.value * 0.3,
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
                              return postCard(data);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text("No data");
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget postCard(PostModel data) {
    return Stack(children: [
      SizedBox(
          height: sizeController.screenHeight.value * 0.3,
          width: sizeController.screenHeight.value * 0.3,
          child: Image.network(
            data.imageURL ?? 'No imageURL',
            fit: BoxFit.cover,
          )),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.black.withOpacity(0.2), // 배경색 및 투명도 설정
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                "${data.address}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: sizeController.middleFontSize.value * 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const Icon(
                Icons.favorite_outlined,
                color: Colors.deepOrange,
              ),
              Text(
                " ${data.like ?? 0}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: sizeController.middleFontSize.value,
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
