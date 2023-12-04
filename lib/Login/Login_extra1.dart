import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart' as my_data;
import 'package:photois/service/account.dart';

class LoginExtra1 extends StatefulWidget {
  const LoginExtra1({super.key});

  @override
  State<LoginExtra1> createState() => _LoginExtra1State();
}

class _LoginExtra1State extends State<LoginExtra1> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((my_data.UserInfo()));
    final sizeController = Get.put((my_data.SizeController()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(sizeController.screenHeight.value * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "추가정보를 입력해주세요",
              style: TextStyle(fontSize: sizeController.bigFontSize.value),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.03,
            ),
            Text(
              " 닉네임",
              style: TextStyle(fontSize: sizeController.middleFontSize.value),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 11,
                decoration: const InputDecoration(
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside)),
                    errorStyle: TextStyle(),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ))),
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

                  debugPrint('####################################################');
                  debugPrint('uid: ${uid}');
                  debugPrint('value: ${value}');
                  debugPrint('####################################################');
                  await firestore.collection('userInfo').doc(uid).set({
                    'nickname': value,
                  });

                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final formKeyState = _formKey.currentState!;
          if (formKeyState.validate()) {
            formKeyState.save();
            Get.find<AccountController>()
                .updateNickname(controller.nickname.value);
            Get.toNamed('/login2');
          }
        },
        child: Icon(Icons.arrow_forward_ios,
            size: sizeController.bigFontSize.value),
      ),
    );
  }
}
