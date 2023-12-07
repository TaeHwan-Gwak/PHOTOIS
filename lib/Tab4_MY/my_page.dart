import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as m;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Tab4_MY/my_like_posts.dart';
import 'package:photois/Tab4_MY/report_posts.dart';
import 'package:photois/Tab4_MY/user_info.dart';
import 'package:photois/service/firebase.auth.dart';

import '../Main/data.dart';
import '../post/post_user.dart';
import '../style/style.dart';
import 'modify_my_info.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  GlobalKey bottomButtonsKey = GlobalKey();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sizeController = Get.put((SizeController()));
  final ScrollController _scrollController = ScrollController();
  final m.FirebaseAuth auth = m.FirebaseAuth.instance;
  String uid = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = auth.currentUser!.uid;
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetUserInfo(),
                  const Divider(color: AppColor.objectColor, thickness: 1),
                  selectButton("내 정보 수정", () {
                    Get.to(ModifyMyInfo());
                  }),
                  selectButton("내 게시물", () {
                    Get.to(UserPost(
                      userUID: uid,
                    ));
                  }),
                  selectButton("내가 좋아요한 게시물", () {
                    Get.to(MyLikePost(
                      userUID: uid,
                    ));
                  }),
                  Visibility(
                      visible: uid == 'iuiqdD2URcWFHzgjIVtFF9EANM62',
                      child: Column(
                        children: [
                          const Divider(
                              color: AppColor.objectColor, thickness: 1),
                          selectButton("신고 받은 포스트", () {
                            Get.to(ReportPost(
                              userUID: 'jin',
                            ));
                          }),
                        ],
                      )),
                ],
              )),
          const Expanded(child: SizedBox()),
          SizedBox(
            height: sizeController.screenHeight.value * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              accountButton("로그아웃", () {
                FbAuth.signOut();
              }),
              accountButton("탈퇴", () {
                FbAuth.deleteUser();
                final String uid = auth.currentUser!.uid;
                firestore.collection('userInfo').doc(uid).delete();
              }),
            ],
          ),
          SizedBox(
            height: sizeController.screenHeight.value * 0.03,
          ),
        ],
      ),
    );
  }

  Widget selectButton(
    String title,
    void Function()? onTap,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.textColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w700,
                color: AppColor.objectColor),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColor.objectColor,
          ),
        ],
      ),
    );
  }

  Widget accountButton(
    String title,
    void Function()? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColor.objectColor,
          backgroundColor: AppColor.objectColor,
          shadowColor: AppColor.objectColor,
          minimumSize: Size(
            sizeController.screenWidth.value * 0.4,
            sizeController.screenHeight.value * 0.06,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: sizeController.middleFontSize.value,
                fontWeight: FontWeight.w600,
                color: AppColor.backgroundColor),
          ),
        ),
      ),
    );
  }
}
