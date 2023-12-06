import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart' as my_data;
import 'package:photois/model/user_model.dart';
import 'package:photois/service/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../style/style.dart';

class ModifyMyInfo extends StatefulWidget {
  const ModifyMyInfo({super.key});

  @override
  State<ModifyMyInfo> createState() => _ModifyMyInfoState();
}

class _ModifyMyInfoState extends State<ModifyMyInfo> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _getUserType(int userTypeValue) {
    switch (userTypeValue) {
      case 1:
        return '나홀로 인생샷';
      case 2:
        return '애인과 커플샷';
      case 3:
        return '친구와 우정샷';
      case 4:
        return '가족과 추억샷';
      default:
        return '알수 없는 값';
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(my_data.UserInfo());
    final sizeController = Get.put(my_data.SizeController());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        title: Center(
          child: Text(
            "MY PAGE",
            style: TextStyle(
                fontSize: sizeController.bigFontSize.value,
                fontWeight: FontWeight.w900,
                color: AppColor.textColor),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColor.objectColor,
            )),
        actions: [SizedBox(width: sizeController.screenWidth.value * 0.13)],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
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
                      SizedBox(
                          height: sizeController.screenHeight.value * 0.02),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _controller,
                          maxLength: 11,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '닉네임을 입력해주세요',
                            hintStyle: TextStyle(
                                fontSize:
                                    sizeController.middleFontSize.value - 2,
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
                            await firestore
                                .collection('userInfo')
                                .doc(uid)
                                .set({
                              'nickname': value,
                            });
                          },
                        ),
                      ),
                      Text(
                        "포토그래퍼 여부",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textColor),
                      ),
                      SizedBox(
                          height: sizeController.screenHeight.value * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  (controller.checkPhotographer.value == 1)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                              '포토그래퍼',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  (controller.checkPhotographer.value == 2)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                              '일반 사용자',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizeController.screenHeight.value * 0.03,
                      ),
                      Visibility(
                        visible: controller.checkPhotographer.value == 1,
                        replacement: Text(
                          "* 포토그래퍼 선택시 인스타그램 아이디를 입력받습니다\n",
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value - 2,
                              fontWeight: FontWeight.w300,
                              color: AppColor.objectColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Instagram ID",
                              style: TextStyle(
                                  fontSize: sizeController.mainFontSize.value,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.textColor),
                            ),
                            SizedBox(
                                height:
                                    sizeController.screenHeight.value * 0.02),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  prefixText: '@ ',
                                  prefixStyle: TextStyle(
                                      fontSize:
                                          sizeController.middleFontSize.value,
                                      fontWeight: FontWeight.w300,
                                      color: AppColor.textColor),
                                  border: OutlineInputBorder(),
                                  hintText: 'Instagram ID',
                                  hintStyle: TextStyle(
                                      fontSize:
                                          sizeController.middleFontSize.value -
                                              2,
                                      fontWeight: FontWeight.w300,
                                      color: AppColor.textColor),
                                  labelText: '@뒤에 ID를 정확히 입력해주세요',
                                  labelStyle: TextStyle(
                                      fontSize:
                                          sizeController.middleFontSize.value -
                                              2,
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
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
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
                                    fontSize:
                                        sizeController.middleFontSize.value,
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.textColor),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '포토그래퍼를 선택하시면 인스타그램 입력은 필수입니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  controller.phoneNumber.value = '@${value!}';
                                },
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
                        "선호하는 카테고리를 선택해주세요",
                        style: TextStyle(
                            fontSize: sizeController.mainFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textColor),
                      ),
                      SizedBox(
                        height: sizeController.screenHeight.value * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  (controller.checkCategory.value == 1)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                            child: Text(
                              '나홀로 인생샷',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  (controller.checkCategory.value == 2)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                            child: Text(
                              '애인과 커플샷',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
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
                              backgroundColor:
                                  (controller.checkCategory.value == 3)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                            child: Text(
                              '친구와 우정샷',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  (controller.checkCategory.value == 4)
                                      ? AppColor.objectColor
                                      : AppColor.textColor,
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
                            child: Text(
                              '가족과 추억샷',
                              style: TextStyle(
                                  fontSize: sizeController.middleFontSize.value,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.backgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
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
                onPressed: () async {
                  if (controller.checkPhotographer.value == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('포토그래퍼 여부를 선택해주세요'),
                    ));
                  } else if (controller.checkPhotographer.value == 1 &&
                      !(_formKey.currentState?.validate() ?? false)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('인스타그램 아이디를 입력해주세요'),
                    ));
                  } else if (controller.checkCategory.value == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('카테고리 중 하나를 선택해주세요'),
                    ));
                  } else {
                    _formKey.currentState?.save();
                    Get.find<AccountController>()
                        .updateNickname(controller.nickname.value);
                    Get.find<AccountController>().changeUserType(
                        UserType.fromString(
                            _getUserType(controller.checkPhotographer.value)));
                    Get.find<AccountController>().changeUserCategory(
                      PrefferedCategory.fromString(
                          controller.checkCategory.value == 1
                              ? '포토그래퍼'
                              : '일반 사용자'),
                    );
                    Get.find<AccountController>()
                        .changeUserNumber(controller.phoneNumber.value);

                    final String uid = auth.currentUser!.uid;

                    await firestore.collection('userInfo').doc(uid).set({
                      'uid': Get.find<AccountController>().user!.uid,
                      'email': Get.find<AccountController>().user!.email,
                      'nickname': controller.nickname.value,
                      'photoGrapher': controller.checkPhotographer.value,
                      'phoneNumber': controller.phoneNumber.value,
                      'categoryName':
                          _getUserType(controller.checkCategory.value),
                    });

                    Get.offAllNamed('/main');
                  }
                },
                child: Center(
                  child: Text(
                    '수정하기',
                    style: TextStyle(
                        fontSize: sizeController.middleFontSize.value,
                        fontWeight: FontWeight.w500,
                        color: AppColor.backgroundColor),
                  ),
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
