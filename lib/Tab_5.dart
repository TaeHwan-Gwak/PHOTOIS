import 'package:flutter/material.dart';

class Tab5 extends StatelessWidget {
  const Tab5({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: 390,
                height: 844,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        width: 390,
                        height: 20,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 316.63,
                              top: 4.33,
                              child: SizedBox(
                                width: 73.37,
                                height: 11.34,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 46.59,
                                      top: 0,
                                      child: SizedBox(
                                        width: 26.78,
                                        height: 11.33,
                                        child: Stack(
                                          children: [
                                            // Adjust the content as per your design
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: SizedBox(
                                width: 59.44,
                                height: 20,
                                child: Text(
                                  '9:41',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 15,
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w600,
                                    height: 0.09,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 170,
                      top: 52,
                      child: Text(
                        '전혜지',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      top: 225,
                      child: SizedBox(
                        width: 329,
                        height: 143,
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 0,
                              top: 0,
                              child: Text(
                                'Account Settings',
                                style: TextStyle(
                                  color: Color(0xFFADADAD),
                                  fontSize: 18,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 53,
                              child: SizedBox(
                                width: 329,
                                height: 29,
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      left: 0,
                                      top: 4,
                                      child: Text(
                                        '알림 설정',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 273,
                                      top: 0,
                                      child: SizedBox(
                                        width: 56,
                                        height: 29,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                width: 56,
                                                height: 29,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFFE5386D),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 30,
                                              top: 3,
                                              child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 114,
                              child: SizedBox(
                                width: 329,
                                height: 29,
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      left: 0,
                                      top: 4,
                                      child: Text(
                                        '다크 모드',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 273,
                                      top: 0,
                                      child: SizedBox(
                                        width: 56,
                                        height: 29,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              top: 0,
                                              child: Container(
                                                width: 56,
                                                height: 29,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFFD7D7D7),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 30,
                                              top: 3,
                                              child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: OvalBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 329,
                                      top: 29,
                                      child: Transform(
                                        transform: Matrix4.identity()
                                          ..translate(0.0, 0.0)
                                          ..rotateZ(-3.14),
                                        child: SizedBox(
                                          width: 56,
                                          height: 29,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Transform(
                                                  transform: Matrix4.identity()
                                                    ..translate(0.0, 0.0)
                                                    ..rotateZ(-3.14),
                                                  child: Container(
                                                    width: 56,
                                                    height: 29,
                                                    decoration: ShapeDecoration(
                                                      color: const Color(
                                                          0xFFEAEAEA),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: -30,
                                                top: -3,
                                                child: Transform(
                                                  transform: Matrix4.identity()
                                                    ..translate(0.0, 0.0)
                                                    ..rotateZ(-3.14),
                                                  child: Container(
                                                    width: 22,
                                                    height: 22,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: OvalBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 415,
                      child: Container(
                        width: 390,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFFC9C9C9),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 34,
                      top: 102,
                      child: SizedBox(
                        width: 322,
                        height: 48,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 322,
                                height: 48,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: Colors
                                      .yellow, // Set the button background color to yellow
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 16,
                                      top: 8,
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 32,
                                        height: 32,
                                      ),
                                    ),
                                    const Positioned(
                                      left: 56,
                                      top: 15,
                                      child: Text(
                                        '        heji9828@naver.com',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          letterSpacing: 0.22,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 17,
                                      top: 15,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(),
                                        child: const Stack(children: [
                                          // Adjust the content as per your design
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 196,
                      child: Container(
                        width: 390,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFFFFFFF),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      top: 697,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your logout logic here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .white, // Set the button background color to white
                            onPrimary: Colors.black,
                            elevation: 5, // Add elevation for shadow effect
                            shadowColor: Colors.grey, // Set the shadow color
                          ),
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 220,
                      top: 697,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your withdrawal logic here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .white, // Set the button background color to white
                            onPrimary: const Color(0xFFD50000),
                            elevation: 5, // Add elevation for shadow effect
                            shadowColor: Colors.grey, // Set the shadow color
                          ),
                          child: const Text(
                            '탈퇴하기',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 30,
                      top: 444,
                      child: SizedBox(
                        width: 329,
                        height: 189,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Text(
                                'More',
                                style: TextStyle(
                                  color: Color(0xFFADADAD),
                                  fontSize: 18,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 53,
                              child: SizedBox(
                                width: 329,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 1,
                                      child: Text(
                                        '개인 정보 수정',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 305,
                                      top: 0,
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 109,
                              child: SizedBox(
                                width: 329,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        '내 갤러리',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 305,
                                      top: 0,
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 165,
                              child: SizedBox(
                                width: 329,
                                height: 24,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        '내 반응 다시보기',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 305,
                                      top: 0,
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
