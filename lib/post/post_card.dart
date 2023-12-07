import 'package:flutter/material.dart';
import 'package:photois/model/post_model.dart';
import 'package:photois/post/post_info.dart';
import 'package:photois/style/style.dart';
import '../Main/data.dart' as my_data;
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatelessWidget {
  final PostModel data;
  final controller = Get.put(my_data.UserInfo());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final double size;

  PostCard({super.key, required this.data, required this.size});

  Future<void> loadData() async {
    var result = await firestore.collection('userInfo').doc(data.userUid).get();
    controller.phoneNumber.value = result.data()!['phoneNumber'];
  }

  final sizeController = Get.put((my_data.SizeController()));
  @override
  Widget build(BuildContext context) {
    loadData();
    return InkWell(
      splashColor: Colors.black.withOpacity(0.2),
      onTap: () {
        Get.to(PhotoInfo(data: data));
      },
      child: Ink(
        child: Stack(
          children: [
            SizedBox(
              height: size * 1.25,
              width: size,
              child: Image.network(
                data.imageURL ?? 'No imageURL',
                fit: BoxFit.cover,
              ),
            ),

            ///장소
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColor.backgroundColor.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${data.mainAddress}",
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///하트
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                      size: 18,
                    ),
                    Text(
                      " ${data.likes.length}",
                      style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontSize: sizeController.middleFontSize.value - 3,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            ///TODO: 인스타정보 불러오기
            ///인스타아이디
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  controller.phoneNumber.value,
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: sizeController.middleFontSize.value - 3,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
