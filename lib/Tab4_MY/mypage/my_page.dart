import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.key.dart';
import 'package:photois/Tab4_MY/mypage/user_info.dart';
import 'package:photois/service/account.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  GlobalKey bottomButtonsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody()),
    );
  }

  Widget buildBody() {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverToBoxAdapter(child: buildUserInfo()),
                const Gap(8),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: buildAccountSetting()),
                const Gap(8),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(child: buildMore()),
                const Gap(180),
              ],
            ),
          ],
        ),
        ...buildFloatings(),
      ],
    );
  }

  Widget buildUserInfo() {
    return const Align(
      child: UserInfo(),
    );
  }

  Widget buildAccountSetting() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('계정 설정'),
          ),
          const Gap(4),
          _buildLabeledItem(
            '알림설정',
            (context) {
              return Align(
                alignment: Alignment.centerRight,
                child: Switch.adaptive(
                  value: true,
                  onChanged: (v) {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFFADADAD),
        ),
      ),
    );
  }

  Widget _buildLabeledItem(
    String label,
    Widget Function(BuildContext context) builder, {
    void Function()? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: InkWell(
        splashColor: Colors.blue.withOpacity(0.3),
        // splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              SizedBox(
                width: screenWidth * 0.4,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: builder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMore() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildGroupTitle('More'),
          ),
          const Gap(4),
          _buildLabeledItem(
            '개인 정보 수정',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {},
          ),
          _buildLabeledItem(
            '내 갤러리',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {},
          ),
          _buildLabeledItem(
            '내 반응 다시보기',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRightArrow() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
      ),
    );
  }

  List<Widget> buildFloatings() {
    return [
      Positioned(
        // bottom: 8,
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: buildLogoutButtons(),
      ),
    ];
  }

  Widget buildLogoutButtons() {
    const kH = 48.0;
    final w = MediaQuery.of(context).size.width * 0.35;

    final h = bottomButtonsKey.globalPaintBounds?.height ?? 0;

    return Stack(
      key: bottomButtonsKey,
      children: [
        if (h > 0) ...[
          buildFrost(
            context,
            width: MediaQuery.of(context).size.width,
            height: h,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
            //  Colors.white.withOpacity(0.5),
            // opacity: 0.8,
          ),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: w,
                height: kH,
                child: RoundedButton(
                  onTap: () {
                    // 계정 변경 테스트
                    Get.find<AccountController>().changeUser();
                  },
                  child: const Text('로그아웃'),
                ),
              ),
              SizedBox(
                width: w,
                height: kH,
                child: RoundedButton(
                  onTap: () {},
                  child: const Text(
                    '탈퇴하기',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const RoundedButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: InkWell(
        splashColor: Colors.blue.withOpacity(0.3),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 16,
              // fontFamily: 'BMHANNAPro',
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

Widget buildFrost(BuildContext context,
    {Key? key,
    double sigma = 10.0,
    Color? color,
    double? width,
    double? height,
    double? radius,
    double opacity = 0.4}) {
  return Container(
    key: key,
    width: width,
    height: height,
    decoration: radius != null
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          )
        : null,
    clipBehavior: radius != null ? Clip.hardEdge : Clip.none,
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: color ?? Colors.grey.shade200.withOpacity(opacity),
        ),
      ),
    ),
  );
}
