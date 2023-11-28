import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
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
            automaticallyImplyLeading: false),
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
              " CATEGORY",
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
                    backgroundColor: (controller.spotCategory.value == 1)
                        ? Colors.tealAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.spotCategory.value = 1;
                    });
                  },
                  child: Text('나홀로 인생샷',
                      style: TextStyle(
                          fontSize: sizeController.middleFontSize.value)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.spotCategory.value == 2)
                        ? Colors.tealAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.spotCategory.value = 2;
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
                    backgroundColor: (controller.spotCategory.value == 3)
                        ? Colors.tealAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.spotCategory.value = 3;
                    });
                  },
                  child: Text('친구와 우정샷',
                      style: TextStyle(
                          fontSize: sizeController.middleFontSize.value)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.spotCategory.value == 4)
                        ? Colors.tealAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.4,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.spotCategory.value = 4;
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
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.3,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Get.back();
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
    );
  }
}
