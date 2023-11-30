import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photois/Main/data.dart';

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';

import 'package:photois/model/post_model.dart';
import '../service/post_api_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  State<Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  int selectedIconNum = 0;

  List<String> weather = ['sun', 'clouds', 'rain', 'snow'];

  List<String> category = ['solo', 'couple', 'friend', 'family'];

  final picker = ImagePicker();
  String? imageDownLoadURL;

  XFile? pickedFile;
  Exif? exif;
  Map<String, Object>? attributes;
  DateTime? shootingDate;
  ExifLatLong? coordinates;

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

    exif = await Exif.fromPath(pickedFile!.path);
    attributes = await exif!.getAttributes();
    shootingDate = await exif!.getOriginalDate();
    coordinates = await exif!.getLatLong();

    setState(() {
      if (pickedFile != null) {
        if (int.parse(DateFormat.H().format(shootingDate!)) > 12) {
          controller.spotTimeHour.value =
              int.parse(DateFormat.H().format(shootingDate!)) - 12;
          controller.spotTimePeriod = [false, true];
        } else {
          controller.spotTimeHour.value =
              int.parse(DateFormat.H().format(shootingDate!));
        }
        controller.spotTimeMinute.value =
            int.parse(DateFormat.m().format(shootingDate!));
        controller.checkPickedFile.value = true;
        controller.spotDate.value = shootingDate!;
        controller.spotLongitude.value = coordinates!.longitude;
        controller.spotLatitude.value = coordinates!.latitude;
      }
    });
  }

  Future closeImage() async {
    await exif?.close();
    shootingDate = null;
    attributes = {};
    exif = null;
    coordinates = null;

    setState(() {});
  }

  Future<void> _uploadImage() async {
    if (pickedFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/${DateTime.now()}.jpg");
      UploadTask uploadTask = storageReference.putFile(File(pickedFile!.path));

      await uploadTask.whenComplete(() async {
        imageDownLoadURL = await storageReference.getDownloadURL();
        print(
            'Image uploaded to Firebase Storage , Download URL: $imageDownLoadURL');
      });
    } else {
      print('No image selected.');
    }
  }

  Widget _buildPhotoArea() {
    return pickedFile != null
        ? SizedBox(
            width: sizeController.screenWidth.value * 0.9,
            height: sizeController.screenWidth.value * 0.9,
            child: Image.file(
              File(pickedFile!.path),
              fit: BoxFit.cover,
            ), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Icon(
            Icons.add_box_rounded,
            size: sizeController.screenWidth.value * 0.8,
            color: Colors.grey,
          );
  }

  final controller = Get.put((PhotoSpotInfo()));
  final sizeController = Get.put((SizeController()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '새 게시물',
            style: TextStyle(fontSize: sizeController.bigFontSize.value),
          ),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                _goBackConfirmDialog(context);
              },
              icon: Icon(Icons.arrow_back,
                  size: sizeController.bigFontSize.value)),
          actions: [
            TextButton(
                onPressed: () {
                  _postConfirmDialog(context);
                },
                child: Text(
                  "등록",
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      color: Colors.blueGrey),
                )),
          ],
        ),
        body: Obx(() {
          controller.printInfo();
          return SafeArea(
              child: SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              spotImage(),
              Visibility(
                key: UniqueKey(),
                visible: controller.checkPickedFile.value,
                child: Column(
                  children: [
                    const Divider(),
                    spotInfo(),
                    Visibility(
                        key: UniqueKey(),
                        replacement: Column(
                          children: [
                            const Text(
                              "* 위치 및 시간 정보를 입력해주세요.\n* 입력 후 날씨 정보를 받을 수 있습니다.",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                            Gap(sizeController.screenHeight.value * 0.7),
                          ],
                        ),
                        visible: (controller.spotMainAddress.value != '' &&
                            controller.spotDate.value !=
                                DateTime(0, 0, 0, 0, 0)),
                        child: Column(
                          children: [
                            const Divider(),
                            spotWeather(),
                            Visibility(
                                key: UniqueKey(),
                                replacement: Column(
                                  children: [
                                    const Text(
                                      "* 날씨 정보를 자동으로 불러오지 못했습니다.\n* 직접 입력해주세요.",
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent),
                                    ),
                                    Gap(sizeController.screenHeight.value *
                                        0.7),
                                  ],
                                ),
                                visible: (controller.spotWeather.value != 0),
                                child: Column(
                                  children: [
                                    const Divider(),
                                    spotCategory(),
                                    Gap(sizeController.screenHeight.value *
                                        0.6),
                                  ],
                                )),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          )));
        }));
  }

  Widget spotImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(sizeController.screenHeight.value * 0.02),
        _buildGroupTitle('사진 업로드'),
        Gap(sizeController.screenHeight.value * 0.03),
        InkWell(onTap: getImage, child: _buildPhotoArea()),
        Gap(sizeController.screenHeight.value * 0.05),
        if (pickedFile == null)
          const Text(
            "* 사진은 한장만 업로드합니다.\n* 사진 업로드 후 추가 정보를 설정할 수 있습니다.",
            style: TextStyle(color: Colors.deepOrangeAccent),
          )
      ],
    );
  }

  Widget spotInfo() {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(sizeController.screenHeight.value * 0.05),
          _buildGroupTitle('위치 및 시간 정보'),
          Gap(sizeController.screenHeight.value * 0.05),
          _buildLabeledItem(
            '위치 추가',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotAddress');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
          Gap(sizeController.screenHeight.value * 0.02),
          _buildSpotInfo(Obx(() => Text(
              (controller.spotMainAddress.value == '')
                  ? ''
                  : (controller.spotExtraAddress.value == '')
                      ? controller.spotMainAddress.value
                      : '${controller.spotMainAddress.value}\n${controller.spotExtraAddress.value}',
              style:
                  TextStyle(fontSize: sizeController.middleFontSize.value)))),
          Gap(sizeController.screenHeight.value * 0.05),
          _buildLabeledItem(
            '시간 추가',
            (context) {
              return _buildRightArrow();
            },
            onTap: () {
              if (pickedFile != null) {
                Get.toNamed('/spotTime');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('먼저 사진을 업로드해주세요.'),
                  ),
                );
              }
            },
          ),
          _buildSpotInfo(Obx(() => Text(
              (controller.spotDate.value == DateTime(0, 0, 0))
                  ? ''
                  : DateFormat("yyyy년 MM월 dd일 ")
                      .add_Hm()
                      .format(controller.spotDate.value),
              style:
                  TextStyle(fontSize: sizeController.middleFontSize.value)))),
          Gap(sizeController.screenHeight.value * 0.05),
        ],
      );
    });
  }

  Widget spotWeather() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(sizeController.screenHeight.value * 0.05),
        _buildGroupTitle('날씨 정보'),
        Gap(sizeController.screenHeight.value * 0.02),
        SizedBox(
          height: sizeController.screenHeight.value * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 1)
                    ? Colors.tealAccent
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 1;
                  });
                },
                icon: const Icon(MyFlutterApp.sun),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 2)
                    ? Colors.tealAccent
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 2;
                  });
                },
                icon: const Icon(MyFlutterApp.cloud),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 3)
                    ? Colors.tealAccent
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 3;
                  });
                },
                icon: const Icon(MyFlutterApp.rainy),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
            Ink(
              padding:
                  EdgeInsets.all(sizeController.screenHeight.value * 0.001),
              decoration: BoxDecoration(
                color: (controller.spotWeather.value == 4)
                    ? Colors.tealAccent
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    controller.spotWeather.value = 4;
                  });
                },
                icon: const Icon(MyFlutterApp.snow),
                iconSize: sizeController.bigFontSize.value * 2,
              ),
            ),
          ],
        ),
        Gap(sizeController.screenHeight.value * 0.02),
        Obx(() => Text(
            (controller.spotWeather.value == 0)
                ? ""
                : PostWeather.fromString(
                        weather[controller.spotWeather.value - 1])
                    .title,
            style: TextStyle(fontSize: sizeController.mainFontSize.value))),
        Gap(sizeController.screenHeight.value * 0.05),
      ],
    );
  }

  Widget spotCategory() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(sizeController.screenHeight.value * 0.05),
        _buildGroupTitle('카테고리'),
        Gap(sizeController.screenHeight.value * 0.02),
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
                  style:
                      TextStyle(fontSize: sizeController.middleFontSize.value)),
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
                  style:
                      TextStyle(fontSize: sizeController.middleFontSize.value)),
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
                  style:
                      TextStyle(fontSize: sizeController.middleFontSize.value)),
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
                  style:
                      TextStyle(fontSize: sizeController.middleFontSize.value)),
            ),
          ],
        ),
        /*
        Gap(sizeController.screenHeight.value * 0.02),
        Obx(() => Text(
            (controller.spotCategory.value == 0)
                ? ''
                : PostCategory.fromString(
                        category[controller.spotCategory.value - 1])
                    .title,
            style: TextStyle(fontSize: sizeController.mainFontSize.value))),

         */
        Gap(sizeController.screenHeight.value * 0.05),
      ],
    );
  }

  Widget _buildGroupTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: sizeController.bigFontSize.value,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFADADAD),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledItem(
    String text,
    Widget Function(BuildContext context) builder, {
    void Function()? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.3),
        onTap: onTap,
        child: Ink(
          height: 40,
          padding: EdgeInsets.symmetric(
              horizontal: sizeController.screenHeight.value * 0.03),
          child: Row(
            children: [
              SizedBox(
                width: sizeController.screenWidth.value * 0.7,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: sizeController.mainFontSize.value,
                    color: Colors.black,
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

  Widget _buildSpotInfo(Widget info) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24), child: info));
  }

  Widget _buildRightArrow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: sizeController.mainFontSize.value,
      ),
    );
  }

  void _goBackConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('돌아가시겠습니까?\n작성 중인 글은 저장되지 않습니다.',
              style: TextStyle(fontSize: sizeController.mainFontSize.value)),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text('확인',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: sizeController.mainFontSize.value)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소',
                  style:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
            ),
          ],
        );
      },
    );
  }

  void _postConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('사진을 등록하시겠습니까?',
              style: TextStyle(fontSize: sizeController.mainFontSize.value)),
          actions: [
            TextButton(
              onPressed: () async {
                if (pickedFile != null) {
                  //TODO: 조건 더 붙이기
                  await _uploadImage();
                  String spotAddress =
                      "${controller.spotMainAddress.value} ${controller.spotExtraAddress.value}";
                  double spotlongitude = controller.spotLongitude.value;
                  double spotLatitude = controller.spotLatitude.value;
                  DateTime spotDate = controller.spotDate.value;
                  String spotWeather =
                      weather[controller.spotWeather.value - 1];
                  String spotCategory =
                      category[controller.spotCategory.value - 1];

                  PostModel fireModel = PostModel(
                      postID: '',
                      createdAt: DateTime.now(),
                      userUid: '',
                      imageURL: imageDownLoadURL!,
                      address: spotAddress,
                      longitude: spotlongitude,
                      latitude: spotLatitude,
                      date: spotDate,
                      weather: PostWeather.fromString(spotWeather),
                      category: PostCategory.fromString(spotCategory));

                  await FireService().createPostInfo(fireModel.toJson());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('사진 등록 완료'),
                  ));
                  Get.back();
                  Get.back();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('먼저 사진을 업로드해주세요.'),
                    ),
                  );
                  Get.back();
                }
              },
              child: Text('등록',
                  style:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('돌아가기',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: sizeController.mainFontSize.value)),
            ),
          ],
        );
      },
    );
  }
}

class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData snow =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rainy =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sun =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cloud =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
