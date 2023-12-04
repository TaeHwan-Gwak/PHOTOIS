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
    final controller = Get.put(UserInfo());
    final sizeController = Get.put(SizeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                  style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
                        backgroundColor:
                            (controller.checkPhotographer.value == 1)
                                ? Colors.tealAccent
                                : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
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
                        backgroundColor:
                            (controller.checkPhotographer.value == 2)
                                ? Colors.tealAccent
                                : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
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
                Visibility(
                  visible: controller.checkPhotographer.value == 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " 인스타그램 아이디",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value),
                      ),
                      SizedBox(
                        height: sizeController.screenHeight.value * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: '정확하게 기입해주세요',
                                hintStyle: TextStyle(
                                    fontSize:
                                        sizeController.middleFontSize.value),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside)),
                                focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '포토그래퍼를 선택하시면 인스타그램 입력은 필수입니다.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              controller.instagramID.value = value!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizeController.screenHeight.value * 0.03,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeController.screenHeight.value * 0.03,
                ),
                Text(
                  " 선호하는 카테고리를 선택해주세요",
                  style: TextStyle(fontSize: sizeController.mainFontSize.value),
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
                        backgroundColor: (controller.checkCategory.value == 1)
                            ? Colors.tealAccent
                            : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
                            sizeController.screenHeight.value * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.checkCategory.value = 1;
                        });
                      },
                      child: Text('나홀로 인생샷',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: (controller.checkCategory.value == 2)
                            ? Colors.tealAccent
                            : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
                            sizeController.screenHeight.value * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.checkCategory.value = 2;
                        });
                      },
                      child: Text('애인과 커플샷',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value)),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeController.screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: (controller.checkCategory.value == 3)
                            ? Colors.tealAccent
                            : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
                            sizeController.screenHeight.value * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.checkCategory.value = 3;
                        });
                      },
                      child: Text('친구와 우정샷',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: (controller.checkCategory.value == 4)
                            ? Colors.tealAccent
                            : Colors.white,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.4,
                            sizeController.screenHeight.value * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.checkCategory.value = 4;
                        });
                      },
                      child: Text('가족과 추억샷',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value)),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeController.screenHeight * 0.05,
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueGrey,
                        backgroundColor: Colors.blueGrey,
                        shadowColor: Colors.black,
                        minimumSize: Size(
                            sizeController.screenWidth.value * 0.3,
                            sizeController.screenHeight.value * 0.07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (controller.checkPhotographer.value == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('포토그래퍼 여부를 선택해주세요'),
                          ));
                        } else if (controller.checkPhotographer.value == 1 &&
                           !( _formKey.currentState?.validate() ?? false)) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('인스타그램 아이디를 입력해주세요'),
                          ));
                        } else if (controller.checkCategory.value == 0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('카테고리 중 하나를 선택해주세요'),
                          ));
                        } else {
                           _formKey.currentState?.save();
                          Get.find<AccountController>()
                              .updateNickname(controller.nickname.value);
                          Get.find<AccountController>().changeUserType(
                            UserType.fromString(
                                controller.checkPhotographer.value == 1
                                    ? '포토그래퍼'
                                    : '일반 사용자'),
                          );

                          Get.offAllNamed('/main');
                        }
                      },
                      child: Center(
                          child: Text(
                        '확인',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: sizeController.middleFontSize.value),
                      ))),
                ),
                SizedBox(
                  height: sizeController.screenHeight * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
