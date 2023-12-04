import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart' as my_data;
import 'package:photois/service/account.dart';

import '../style/style.dart';

class LoginExtra1 extends StatefulWidget {
  const LoginExtra1({super.key});

  @override
  State<LoginExtra1> createState() => _LoginExtra1State();
}

class _LoginExtra1State extends State<LoginExtra1> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((my_data.UserInfo()));
    final sizeController = Get.put((my_data.SizeController()));

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        title: Center(
          child: Text(
            "NEW MEMBER",
            style: TextStyle(
                fontSize: sizeController.bigFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.textColor),
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "닉네임",
              style: TextStyle(
                  fontSize: sizeController.mainFontSize.value,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textColor),
            ),
            SizedBox(height: sizeController.screenHeight.value * 0.02),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                maxLength: 11,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '닉네임을 입력해주세요',
                  hintStyle: TextStyle(
                      fontSize: sizeController.middleFontSize.value - 2,
                      fontWeight: FontWeight.w300,
                      color: AppColor.textColor),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.objectColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                style: TextStyle(
                    fontSize: sizeController.middleFontSize.value,
                    fontWeight: FontWeight.w300,
                    color: AppColor.textColor),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp('[a-z A-Z ㄱ-ㅎ|가-힣|0-9]'),
                    allow: true,
                  )
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임 입력은 필수입니다.';
                  }
                  return null;
                },
                onSaved: (value) async {
                  controller.nickname.value = value!;
                  final String uid = auth.currentUser!.uid;

                  debugPrint(
                      '####################################################');
                  debugPrint('uid: ${uid}');
                  debugPrint('value: ${value}');
                  debugPrint(
                      '####################################################');
                  await firestore.collection('userInfo').doc(uid).set({
                    'nickname': value,
                  });
                },
              ),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.objectColor,
                backgroundColor: AppColor.objectColor,
                shadowColor: AppColor.objectColor,
                minimumSize: Size(
                  sizeController.screenWidth.value * 0.6,
                  sizeController.screenHeight.value * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final formKeyState = _formKey.currentState!;
                if (formKeyState.validate()) {
                  formKeyState.save();
                  Get.find<AccountController>()
                      .updateNickname(controller.nickname.value);
                  Get.toNamed('/login2');
                }
              },
              child: Center(
                child: Text(
                  '다음',
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w500,
                      color: AppColor.backgroundColor),
                ),
              ),
            ),
            SizedBox(
              height: sizeController.screenHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
