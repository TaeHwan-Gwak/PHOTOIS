import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:photois/model/user_model.dart';
import 'package:photois/service/account.dart';

class LoginExtra2 extends StatefulWidget {
  const LoginExtra2({super.key});

  @override
  State<LoginExtra2> createState() => _LoginExtra2State();
}

class _LoginExtra2State extends State<LoginExtra2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put((UserInfo()));
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black)),
      ),
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
              " 포토그래퍼 여부",
              style: TextStyle(fontSize: sizeController.middleFontSize.value),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.checkPhotographer.value == 1)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkPhotographer.value = 1;
                    });
                  },
                  child: Text(
                    "포토그래퍼",
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.checkPhotographer.value == 2)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkPhotographer.value = 2;
                    });
                  },
                  child: Text(
                    "일반 사용자",
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.05,
            ),
            Text(
              " 인스타그램 아이디(선택)",
              style: TextStyle(fontSize: sizeController.middleFontSize.value),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                    counterText: '정확하게 기입해주세요',
                    counterStyle: TextStyle(
                        fontSize: sizeController.middleFontSize.value),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside)),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text.';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.instagramID.value = value!;
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.checkPhotographer.value != 0) {
            //todo UserType 추가
            Get.find<AccountController>().changeUserType(
                UserType.fromString(controller.checkPhotographer.value == 1 ? '포토그래퍼' : '일반 사용자'),
            );

            Get.toNamed('/login3');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('포토그래퍼 여부를 선택해주세요'),
            ));
          }
        },
        mini: true,
        child: Icon(Icons.arrow_forward_ios,
            size: sizeController.bigFontSize.value),
      ),
    );
  }
}
