import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

class LoginExtra3 extends StatefulWidget {
  const LoginExtra3({super.key});

  @override
  State<LoginExtra3> createState() => _LoginExtra3State();
}

class _LoginExtra3State extends State<LoginExtra3> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put((UserInfo()));
    final sizeController = Get.put((SizeController()));

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
              " 선호하는 카테고리를 선택해주세요",
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
                    backgroundColor: (controller.checkCategory.value == 1)
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
                      controller.checkCategory.value = 4;
                    });
                  },
                  child: Text('가족과 추억샷',
                      style: TextStyle(
                          fontSize: sizeController.middleFontSize.value)),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.3,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () {
                    if (controller.checkCategory.value != 0) {
                      Get.offAllNamed('/main');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('카테고리 중 하나를 선택해주세요'),
                      ));
                    }
                  },
                  child: Center(
                      child: Text(
                    '완료',
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
    );
  }
}
