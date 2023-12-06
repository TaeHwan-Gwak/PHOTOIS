import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/service/account.dart';

import '../Main/data.dart';
import '../style/style.dart';

class GetUserInfo extends StatelessWidget {
  GetUserInfo({super.key});

  final sizeController = Get.put((SizeController()));

  @override
  Widget build(BuildContext context) {
    try {
      return GetBuilder<AccountController>(builder: (controller) {
        print(controller.user?.nickname);

        return Column(
          children: [
            SizedBox(
              height: sizeController.screenHeight.value * 0.02,
            ),
            Text(
              controller.user?.nickname ?? 'NO NICKNAME',
              style: TextStyle(
                  fontSize: sizeController.bigFontSize.value,
                  fontWeight: FontWeight.w900,
                  color: AppColor.textColor),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.02,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.textColor,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  SizedBox(
                    height: sizeController.screenHeight.value * 0.04,
                    width: sizeController.screenWidth.value * 0.7,
                    child: Align(
                      child: Text(controller.user?.email ?? 'NO EMAIL',
                          style: TextStyle(
                              fontSize: sizeController.middleFontSize.value,
                              fontWeight: FontWeight.w500,
                              color: AppColor.backgroundColor)),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    width: 20,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/google-icon.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.02,
            ),
          ],
        );
      });
    } catch (e) {
      'FAILED UserInfo.build: $e'.log();
    }
    return const SizedBox.shrink();
  }
}
