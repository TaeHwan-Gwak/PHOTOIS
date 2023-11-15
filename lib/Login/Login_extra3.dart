import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/data.dart';

class LoginExtra3 extends StatefulWidget {
  const LoginExtra3({super.key});

  @override
  State<LoginExtra3> createState() => _LoginExtra3State();
}

class _LoginExtra3State extends State<LoginExtra3> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put((UserInfo()));
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "추가정보를 입력해주세요",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              " 선호하는 카테고리를 선택해주세요",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 20,
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
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkCategory.value = 1;
                    });
                  },
                  child: const Text('나홀로 인생샷'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.checkCategory.value == 2)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkCategory.value = 2;
                    });
                  },
                  child: const Text('애인과 커플샷'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkCategory.value = 3;
                    });
                  },
                  child: const Text('친구와 우정샷'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: (controller.checkCategory.value == 4)
                        ? Colors.redAccent
                        : Colors.white,
                    shadowColor: Colors.black,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.checkCategory.value = 4;
                    });
                  },
                  child: const Text('가족과 추억샷'),
                ),
              ],
            ),
            const SizedBox(
              height: 320,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black,
                    shadowColor: Colors.black,
                    minimumSize: const Size(130, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () {
                    if (controller.checkCategory.value != 0) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/main', (Route<dynamic> route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('카테고리 중 하나를 선택해주세요'),
                      ));
                    }
                  },
                  child: const Center(
                      child: Text(
                    '완료',
                    style: TextStyle(color: Colors.white),
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
