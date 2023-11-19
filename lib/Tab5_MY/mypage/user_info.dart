import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/service/account.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final user = Get.find<Account>().user;

      return Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: Text(
                user.nickname,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(Colors.black, Colors.white, 0.8)!,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  SizedBox(
                    height: 32,
                    child: Align(
                      child: Text(
                        user.email,
                      ),
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
          ],
        ),
      );
    } catch (e) {
      'FAILED UserInfo.build: $e'.log();
    }
    return const SizedBox.shrink();
  }
}
